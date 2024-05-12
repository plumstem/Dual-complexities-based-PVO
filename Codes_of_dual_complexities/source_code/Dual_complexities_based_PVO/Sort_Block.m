function [sorted_blk,reshape_blk] = Sort_Block(blk)

[blkh,blkw] = size(blk);

pixel       = zeros(blkh*blkw,4);
reshape_blk = zeros(blkh*blkw,1);

count = 0;

% scanning order
for ii = 1:blkh
    for jj = 1:blkw
        count = count+1;
        pixel(count,1) = blk(ii,jj);
        pixel(count,4) = count;
        pixel(count,2:3) = [ii,jj];
        reshape_blk(count) = blk(ii,jj);
    end
end

sorted_blk = sortrows(pixel,1,'ascend');

end