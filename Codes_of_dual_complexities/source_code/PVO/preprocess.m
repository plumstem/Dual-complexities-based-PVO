function [height,width,grayimg,AUX] = preprocess(img,block_height,block_width)

grayimg = double(im2gray(img));

[height,width] = size(grayimg);

% block size
blkh = block_height;
blkw = block_width;

LM = zeros(floor(height/block_height),floor(width/block_width));

for i = 1:floor(height/block_height)
    for j = 1:floor(width/block_width)

        LU = [(i-1)*blkh+1,(j-1)*blkw+1]; % left up (start) point of block
        RB = [(i)*blkh,(j)*blkw];         % right bottom (end) point of block

        blk        = img(LU(1):RB(1),LU(2):RB(2));
        [sorted_blk,reshape_blk] = Sort_Block(blk);
        sigma      = sorted_blk(:,4);

        if sorted_blk(end,1)-sorted_blk(end-1,1) >= 1 && sorted_blk(end,1) == 255
            a           = (i-1)*blkh + sorted_blk(blkh*blkw,2);
            b           = (j-1)*blkw + sorted_blk(blkh*blkw,3);
            grayimg(a,b) = 254;
            LM(i,j) = 1;
        end
        if sorted_blk(2,1)-sorted_blk(1,1) >= 1 && sorted_blk(1,1) == 0
            c           = (i-1)*blkh + sorted_blk(1,2);
            d           = (j-1)*blkw + sorted_blk(1,3);
            grayimg(c,d) = 1;
            LM(i,j) = 1;
        end
    end
end

xC{1,1} = LM;
compressed_LM = Arith07(xC);

AUX = 4+8+8*length(compressed_LM);

end