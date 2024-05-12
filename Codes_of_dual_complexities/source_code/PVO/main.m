%% PVO--lzj's implementation

tic;

clc;clear;

% set parameters
block_height_op = 2;
block_height_ed = 5;
block_width_op  = 2;
block_width_ed  = 5;

image = imread('../lena.tiff');

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
        [PE_Map,PE_Histo,NL_EC] = Prediction(grayimage,block_height,block_width,max_NL);

        % calculate max embedding capacity
        max_EC = sum(NL_EC);

        fprintf('Max EC = %d -- Max NL = %d\n',max_EC,max_NL)

        parameters = zeros(floor((max_EC-1000)/1000)+1,6);  % block_size Payload Eembedded_data PSNR
        for length_of_data = 1000+AUX:1000:max_EC

            % secret data
            data = round(rand(1,length_of_data));

            % searching thershold
            [Thershold] = Get_T(length_of_data,max_EC,NL_EC);

            % embedding procedure--PVO embedding
            [PSNR,Embedded_Data] = Embedding(grayimage,data,NL_Map,PE_Map,block_height,block_width,Thershold);

            % display results
            % disp('Block size: '+string(block_height)+'--'+string(block_width))
            % disp('Payload: '+string(length_of_data)+'--Eembedded data: '+string(Embedded_Data-1)+'--PSNR: '+string(PSNR))

            % recording
            parameters(floor((length_of_data-1000-AUX)/1000)+1,:) = [block_height,block_width,Thershold,length_of_data-AUX,Embedded_Data-1-AUX,PSNR];
            % toc;

        end

        Parameter_Block{count+1} = parameters;
        count                    = count+1;

        fprintf('Block size: %d X %d has finished !\n',block_height,block_width)

    end
end

% toc;
[Optimal_parameters] = Compare(Parameter_Block,index);

toc;
