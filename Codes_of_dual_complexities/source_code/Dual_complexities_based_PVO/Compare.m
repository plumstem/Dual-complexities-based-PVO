function [Optimal_parameters] = Compare(Parameter_Block,number)

len = zeros(length(Parameter_Block),1);  %16x1

for i = 1:length(Parameter_Block)
    [len(i),~] = size(Parameter_Block{i});
end

max_len = max(len);

Optimal_parameters = zeros(max_len,size(Parameter_Block{1,1}(1,:),2));

for i = 1:max_len
    PSNR = zeros(length(Parameter_Block),1);
    for j = 1:length(Parameter_Block)
        if i <= size(Parameter_Block{j},1)
            PSNR(j) = Parameter_Block{j}(i,end);
        end
    end
    [~,idx] = max(PSNR);
    Optimal_parameters(i,:) = Parameter_Block{idx}(i,:);
end

% save parameters
filename = 'Improved PVO (EC-PSNR,kodak).xlsx';
writematrix(Optimal_parameters,filename,'Sheet',number)

end
