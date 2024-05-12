function [row,S] = Compare(Parameter_Block)

len = zeros(length(Parameter_Block),1);

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

row = Optimal_parameters(:,2)';
S = Optimal_parameters(:,3)';

% save parameters
% filename = 'PVO (EC-PSNR,kodak).xlsx';
% writematrix(Optimal_parameters,filename,'Sheet',number)

end
