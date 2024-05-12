function [T] = Thershold(data,EC,NL_EC_Array)

Payload = length(data);

if EC < Payload
    T = inf;
else
    ec = 0;
    for t = 0 : 255
        ec = ec + NL_EC_Array(t+1,1);
        if ec >= Payload
            break;
        end
    end
    T = t+1;
end

end