function [max_NL,NL_Map] = Calculate_NL(img,block_height,block_width)

[height,width] = size(img);

% block size
blkh = block_height;
blkw = block_width;

% matrix difinition
NL_Map      = zeros(floor(height/blkh),floor(width/blkw));

% LPVO prediction
for i = 1 : floor(height/blkh)
    for j = 1 : floor(width/blkw)

        LU = [(i-1)*blkh+1,(j-1)*blkw+1]; % left up (start) point of block
        RB = [(i)*blkh,(j)*blkw];         % right bottom (end) point of block

        blk                      = img(LU(1):RB(1),LU(2):RB(2));
        [sorted_blk,reshape_blk] = Sort_Block(blk);
        sigma                    = sorted_blk(:,4);

        % calculate complexity

        NL_Map(i,j) = reshape_blk(sigma(blkh*blkw-1),1)-reshape_blk(sigma(2),1);
    end
end

max_NL = max(NL_Map(:));

end