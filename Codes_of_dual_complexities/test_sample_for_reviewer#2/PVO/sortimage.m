function [sorted_image] = sortimage(grayimage,block_height,block_width)
%½«Í¼Ïñ·Ö¿éÅÅÐò
[height,width] = size(grayimage);
sorted_image = zeros(height,width);
block = zeros(block_height,block_width);
sorted_block = zeros(block_height,block_width);
for i = 1:floor(height/block_height)
    for j = 1:floor(width/block_width)
        for m = 1:block_height
            for n = 1:block_width
                block(m,n) = grayimage((i-1)*block_height+m,(j-1)*block_width+n);
            end
        end
        sorted_array = sort(block(:));
        for m = 1:block_height
            for n = 1:block_width
                sorted_block(m,n) = sorted_array((m-1)*block_width+n,1);
            end
        end
        for m = 1:block_height
            for n = 1:block_width
                sorted_image((i-1)*block_height+m,(j-1)*block_width+n) = sorted_block(m,n);
            end
        end
    end
end
end