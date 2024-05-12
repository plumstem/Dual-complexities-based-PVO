%% PVO--lzj's implementation BOSSbase

tic;

clc;clear;

% set parameters
block_height_op = 2;
block_height_ed = 4;
block_width_op  = 2;
block_width_ed  = 4;

file_path =  '../dataset/';% 图像文件夹路径  
img_path_list = dir(strcat(file_path,'*.pgm'));
% dir 列出当前文件夹中的文件信息
img_num = length(img_path_list); %获取图像总数量
num = 1000;
res = zeros(num,4);
S = zeros(num,4);
stat_res = zeros(2,4);
stat_S = zeros(2,4);

if img_num > 0 %有满足条件的图像
    for j = 1:num%img_num %逐一读取图像
        img_name = [file_path,int2str(j),'.pgm'];
        image = imread(img_name);

        if mod(j,100) == 0 || j == 1
            fprintf('For image %d\n',j)
        end

        % a cell recording parameter (EC-PSNR) under different block size
        Parameter_Block = cell((block_height_ed-block_height_op+1)*(block_width_ed-block_width_op+1),1);
        count           = 0;
        % tic;
        for block_height = block_height_op:block_height_ed
            for block_width = block_width_op:block_width_ed

                % image preprocessing--grayscale:overflow
                [height,width,grayimage,AUX] = preprocess(image,block_height,block_width);

                % calculate max NL
                [max_NL,NL_Map] = Calculate_NL(grayimage,block_height,block_width);

                % prediction procedure--LPVO prdiction
                [PE_Map,PE_Histo,NL_EC,Flag_Map] = Prediction(grayimage,block_height,block_width,max_NL);

                % calculate max embedding capacity
                max_EC = sum(NL_EC);

                % fprintf('Max EC = %d -- Max NL = %d\n',max_EC,max_NL)

                % calculate dual complexities
                % tic;
                [DC_PE_Loc_cell] = Dual_Complexities(grayimage,Flag_Map,block_height,block_width,PE_Map);
                % toc;

                parameters = zeros(4,3);  % block_size Payload Eembedded_data PSNR
                cnt = 0;

                for length_of_data = [1000,5000,10000,20000]%1000+AUX:1000:max_EC

                    % secret data
                    data = round(rand(1,length_of_data));

                    % calculate dual thersholds
                    [T_cmax,T_cnum,op_matrix,results] = Dual_Thersholds(DC_PE_Loc_cell,length_of_data,grayimage,block_height,block_width);

                    % embedding procedure--PVO embedding
                    [PSNR,SSIM,Embedded_Data] = Embedding(grayimage,data,PE_Map,block_height,block_width,op_matrix,results);

                    % display results
                    % disp('Block size: '+string(block_height)+'--'+string(block_width))
                    % disp('Payload: '+string(length_of_data)+'--Eembedded data: '+string(Embedded_Data-1)+'--PSNR: '+string(PSNR))

                    % recording
                    parameters(cnt+1,:) = [length_of_data,PSNR,SSIM];
                    cnt = cnt+1;
                    % toc;

                end

                Parameter_Block{count+1} = parameters;
                count                    = count+1;

                % fprintf('kodim%d--Block size: %d X %d has finished !\n',index,block_height,block_width)

            end
        end

        % toc;
        [res(j,:),S(j,:)] = Compare(Parameter_Block);
        for n = 1:4
            if res(j,n) == 0
                res(j,n) = nan; S(j,n) = nan;
            end
        end

        % fprintf('kodim%d has finished !\n',index)

        toc;
    end
end
stat_res(1,:) = mean(res,1,'omitnan'); stat_res(2,:) = std(res,1,'omitnan');
stat_S(1,:) = mean(S,1,'omitnan'); stat_S(2,:) = std(S,1,'omitnan');

% save parameters
filename = 'Improved_PVO-PSNR-SSIM,BOSSbase.xlsx';
writematrix(res,filename,'Sheet',1)
writematrix(stat_res,filename,'Sheet',2)
writematrix(S,filename,'Sheet',3)
writematrix(stat_S,filename,'Sheet',4)