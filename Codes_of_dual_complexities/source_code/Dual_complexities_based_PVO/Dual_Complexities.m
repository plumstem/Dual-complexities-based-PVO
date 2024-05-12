function [DC_PE_Loc_cell] = Dual_Complexities(img,Flag_Map,block_height,block_width,PE_Map)

[height,width] = size(img);

% block size
blkh = block_height;
blkw = block_width;

% matrix definition
max_t = 10;
DC_PE_Loc_cell  = cell(1,max_t+1);
CNT = 0;

for i = 1 : floor(height/blkh)
    for j = 1 : floor(width/blkw)

        LU = [(i-1)*blkh+1,(j-1)*blkw+1]; % left up (start) point of block
        RB = [(i)*blkh,(j)*blkw];         % right bottom (end) point of block

        blk                      = img(LU(1):RB(1),LU(2):RB(2));
        [sorted_blk,reshape_blk] = Sort_Block(blk);
        sigma                    = sorted_blk(:,4);

        a = (i-1)*blkh + sorted_blk(blkh*blkw,2);
        b = (j-1)*blkw + sorted_blk(blkh*blkw,3);
        p = reshape_blk(sigma(blkw*blkh-1));

        [cmax,cnum] = Cal_Dual(a,b,p,img,Flag_Map,1,max_t);

        for t = 0:max_t
            DC_PE_Loc_cell{1,t+1}(CNT+1,:) = [cmax(1,t+1) cnum(1,t+1) PE_Map(a,b) a b];
        end

        CNT = CNT+1;

        c = (i-1)*blkh + sorted_blk(1,2);
        d = (j-1)*blkw + sorted_blk(1,3);
        p = reshape_blk(sigma(2));

        [cmax,cnum] = Cal_Dual(c,d,p,img,Flag_Map,0,max_t);

        for t = 0:max_t
            DC_PE_Loc_cell{1,t+1}(CNT+1,:) = [cmax(1,t+1) cnum(1,t+1) PE_Map(c,d) c d];
        end

        CNT = CNT+1;

    end
end

    function [cmax,cnum] = Cal_Dual(x,y,p,img,Flag_Map,flag,max_T)  % (x,y) is the location of predicted pixel, p is the value of prediction pixel
    
    % neighborhood definition
    N4  = {[x-1,y];[x,y-1];[x+1,y];[x,y+1]};
    N8  = {[x-2,y];[x-1,y-1];[x,y-2];[x+1,y-1];[x+2,y];[x+1,y+1];[x,y+2];[x-1,y+1]};
    N12 = {[x-3,y];[x-2,y-1];[x-1,y-2];[x,y-3];[x+1,y-2];[x+2,y-1];[x+3,y];[x+2,y+1];[x+1,y+2];[x,y+3];[x-1,y+2];[x-2,y+1]};
    % N16 = {[x-4,y];[x-3,y-1];[x-2,y-2];[x-1,y-3];[x,y-4];[x+1,y-3];[x+2,y-2];[x+3,y-1];[x+4,y];[x+3,y+1];[x+2,y+2];[x+1,y+3];[x,y+4];[x-1,y+3];[x-2,y+2];[x-3,y+1]};
    
    % generate NPEs
    NPE4 = nan(length(N4),1);
    for jj = 1:length(N4)
        xx = N4{jj}(1); yy = N4{jj}(2);
        if xx >= 1 && xx <= height && yy >= 1 && yy <= width
            if ~isnan(Flag_Map(xx,yy)) %&& overblock(xx,yy) == 1
                if flag == 1
                    NPE4(jj) = img(xx,yy)-p;
                else
                    NPE4(jj) = p-img(xx,yy);
                end
            end
        end
    end
    
    NPE8 = nan(length(N8),1);
    for jj = 1:length(N8)
        xx = N8{jj}(1); yy = N8{jj}(2);
        if xx >= 1 && xx <= height && yy >= 1 && yy <= width
            if ~isnan(Flag_Map(xx,yy)) %&& overblock(xx,yy) == 1
                if flag == 1
                    NPE8(jj) = img(xx,yy)-p;
                else
                    NPE8(jj) = p-img(xx,yy);
                end
            end
        end
    end
    
    NPE12 = nan(length(N12),1);
    for jj = 1:length(N12)
        xx = N12{jj}(1); yy = N12{jj}(2);
        if xx >= 1 && xx <= height && yy >= 1 && yy <= width
            if ~isnan(Flag_Map(xx,yy)) %&& overblock(xx,yy) == 1
                if flag == 1
                    NPE12(jj) = img(xx,yy)-p;
                else
                    NPE12(jj) = p-img(xx,yy);
                end
            end
        end
    end

%     NPE16 = nan(length(N16),1);
%     for jj = 1:length(N16)
%         xx = N16{jj}(1); yy = N16{jj}(2);
%         if xx >= 1 && xx <= height && yy >= 1 && yy <= width
%             if ~isnan(Flag_Map(xx,yy)) %&& overblock(xx,yy) == 1
%                 if flag == 1
%                     NPE16(jj) = img(xx,yy)-p;
%                 else
%                     NPE16(jj) = p-img(xx,yy);
%                 end
%             end
%         end
%     end

    % calculate cmax and cnum

    cnum = zeros(1,max_T+1); cmax = zeros(1,max_T+1);

    for T = 0:max_T
        NPE = [NPE4;NPE8;NPE12];

        NPE = NPE(~isnan(NPE));  % exclude nan value

        if isempty(NPE)
            cmax(1,T+1) = 10;
        else
            % calculate the sum of NPEs
            %cmax = sum(abs(NPE));
            % directly use the maximum NPE
            cmax(1,T+1) = max(abs(NPE));
        end

        if ~isempty(NPE)
            cnum(1,T+1) = length(find(abs(NPE(:)) <= T));  % T represents thershold
        end
    end
    
        function blockflag = overblock(xx,yy)
            if xx >= LU(1) && xx <= RB(1) && yy >= LU(2) && yy <= RB(2)
                blockflag = 0;
            else
                blockflag = 1;
            end
        end

    end

end