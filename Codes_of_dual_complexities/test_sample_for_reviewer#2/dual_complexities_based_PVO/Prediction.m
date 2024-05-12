function [PE_Map,PE_Histo,NL_EC,Flag_Map] = Prediction(img,block_height,block_width,max_NL)

[height,width] = size(img);

% block size
blkh = block_height;
blkw = block_width;

% matrix difinition
PE_Map      = nan(height,width);
PE_Histo    = zeros(256,1);  % 1D PEH
NL_Map      = zeros(floor(height/blkh),floor(width/blkw));
NL_EC       = zeros(max_NL+1,1);
Flag_Map    = zeros(height,width);  % record location of modified pixel (NaN represents modified pixel)

% IPVO prediction
for i = 1 : floor(height/blkh)
    for j = 1 : floor(width/blkw)

        LU = [(i-1)*blkh+1,(j-1)*blkw+1]; % left up (start) point of block
        RB = [(i)*blkh,(j)*blkw];         % right bottom (end) point of block

        blk        = img(LU(1):RB(1),LU(2):RB(2));
        [sorted_blk,reshape_blk] = Sort_Block(blk);
        sigma      = sorted_blk(:,4);

        % calculate NL
        NL_Map(i,j) = reshape_blk(sigma(blkh*blkw-1),1)-reshape_blk(sigma(2),1);

        % calculate prediction error in the maximum end--PVO predictor

        e_max = reshape_blk(sigma(blkh*blkw))-reshape_blk(sigma(blkh*blkw-1));

        % locate the embedded pixel e_max in the maximum end
        a           = (i-1)*blkh + sorted_blk(blkh*blkw,2);
        b           = (j-1)*blkw + sorted_blk(blkh*blkw,3);
        PE_Map(a,b) = e_max;

        % the same operaters in the minimum end

        % calculate prediction error in the minimum end--PVO predictor

        e_min = reshape_blk(sigma(2))-reshape_blk(sigma(1));

        % locate the embedded pixel e_min in the minimum end
        c           = (i-1)*blkh + sorted_blk(1,2);
        d           = (j-1)*blkw + sorted_blk(1,3);
        PE_Map(c,d) = e_min;

        % statistic, generate 1D PEH
        if ~isempty(e_max)
            PE_Histo(e_max+1,1) = PE_Histo(e_max+1,1)+1;
            PE_Histo(e_min+1,1) = PE_Histo(e_min+1,1)+1;
        end

        % statistic, generate NL_EC

        if e_max == 1
            NL_EC(NL_Map(i,j)+1,1) = NL_EC(NL_Map(i,j)+1,1)+1;
        end

        if e_min == 1
            NL_EC(NL_Map(i,j)+1,1) = NL_EC(NL_Map(i,j)+1,1)+1;
        end

        % mark the embedded pixel
        Flag_Map(a,b) = nan; Flag_Map(c,d) = nan;

    end
end

end