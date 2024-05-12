function [PSNR,SSIM,k] = Embedding(img,data,NL_Map,PE_Map,blkh,blkw,T,name)

[height,width] = size(img);

length_of_data = length(data);

flag = 0;
k    = 1;

embedded_image = img;

if T == inf
    PSNR = 0; SSIM = 0;
else

    for i = 1 : floor(height/blkh)
        for j = 1 : floor(width/blkw)

            LU = [(i-1)*blkh+1,(j-1)*blkw+1]; % left up (start) point of block
            RB = [(i)*blkh,(j)*blkw];         % right bottom (end) point of block

            blk                      = img(LU(1):RB(1),LU(2):RB(2));
            [sorted_blk,reshape_blk] = Sort_Block(blk);
            sigma                    = sorted_blk(:,4);

            if NL_Map(i,j) <= T

                % locate the embedded pixel e_max in the maximum end

                a           = (i-1)*blkh + sorted_blk(blkh*blkw,2);
                b           = (j-1)*blkw + sorted_blk(blkh*blkw,3);

                e_max = PE_Map(a,b);
                [modi_e,update] = Mapping(e_max,data(1,k));

                embedded_image(a,b) = sorted_blk(blkh*blkw-1,1)+modi_e;

                if update == 1
                    k = k+1;
                end

                if k > length_of_data
                    flag = 1;
                    break;
                end


                % the same operaters in the minimum end

                % locate the embedded pixel e_min in the minimum end
                c           = (i-1)*blkh + sorted_blk(1,2);
                d           = (j-1)*blkw + sorted_blk(1,3);

                e_min = PE_Map(c,d);
                [modi_e,update] = Mapping(e_min,data(1,k));

                embedded_image(c,d) = sorted_blk(2,1)-modi_e;

                if update == 1
                    k = k+1;
                end

                if k > length_of_data
                    flag = 1;
                    break;
                end
            end

        end

        if flag == 1
            break;
        end

    end

end

if flag == 1
    PSNR = psnr(embedded_image,img,255);
    SSIM = ssim(embedded_image,img);
    imwrite(uint8(embedded_image),sprintf('stegoImages(%d)/stego_%s.bmp',length_of_data,name),'bmp');
else
    PSNR = 0; SSIM = 0;
end

end