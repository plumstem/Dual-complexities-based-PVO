function [optimal,T1,T2] = Search(Table,length_of_data,max_NL)
optimal = 0;
for t1 = 1:max_NL+1
    for t2 = t1+1:max_NL+1
        if Table(t1,t2,1) >= length_of_data
            if Table(t1,t2,3) > optimal
                optimal = Table(t1,t2,3);
                T1 = t1; T2 = t2;
            end
        end
    end
end