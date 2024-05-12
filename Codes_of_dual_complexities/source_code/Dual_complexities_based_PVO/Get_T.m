function [Thershold] = Get_T(length_of_secret_data,max_EC,NL_EC)

if max_EC < length_of_secret_data
    Thershold = inf;
else
    ec = 0;
    for T = 0 : length(NL_EC)-1
        ec = ec + NL_EC(T+1,1);
        if ec >= length_of_secret_data
            break;
        end
    end
    Thershold = T;
end