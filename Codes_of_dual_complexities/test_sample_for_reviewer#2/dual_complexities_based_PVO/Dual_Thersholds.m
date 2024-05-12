function [T_cmax,T_cnum,op_matrix,results] = Dual_Thersholds(DC_PE_Loc_cell,Payload,img,block_height,block_width)

[height,width] = size(img);

% block size
blkh = block_height;
blkw = block_width;

minimum_ed = 100000000000000000;
results    = zeros(1,4);
op_matrix  = [];
max_t = 10;

% generate prediction-error
for t = 0:max_t

    % double sort
    matrix = DC_PE_Loc_cell{1,t+1};
    matrix = sortrows(matrix,1,'ascend');
    matrix = sortrows(matrix,2,'descend');

    % search thersholds meeting payload
    ec = 0; ed = 0;
    T_cmax = inf; T_cnum = inf; Seq = inf;
    for i = 1:length(matrix)
        e = matrix(i,3);
        if e == 1
            ec = ec+1;
        elseif e > 1
            ed = ed+1;
        end
        if ec >= Payload
            T_cmax = matrix(i,1); T_cnum = matrix(i,2); Seq = i;
            % fprintf('%d X %d ; ed = %d\n',blkh,blkw,ed)
            if ed < minimum_ed
                minimum_ed = ed;
                results = [T_cmax,T_cnum,t,Seq];
                op_matrix = matrix;
            end
            break
        end
    end
end

% fprintf('%d X %d,Payload = %d : minimum_ed = %d\n',blkh,blkw,Payload,minimum_ed)

end