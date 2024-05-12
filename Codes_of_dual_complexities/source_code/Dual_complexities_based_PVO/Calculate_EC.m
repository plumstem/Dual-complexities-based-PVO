function [max_EC] = Calculate_EC(PE_Histo)

max_EC = 0;

max_EC = max_EC+PE_Histo(1,1)+PE_Histo(2,1)+PE_Histo(2,2)+PE_Histo(2,3)+...
                PE_Histo(3,3)+PE_Histo(1,2)+PE_Histo(1,3);

for i = 1:256
    for j = 1:256
        if i > 3 || j > 3
            if i+1 == j || i == j
                max_EC = max_EC+PE_Histo(i,j);
            end
        end
    end
end

end