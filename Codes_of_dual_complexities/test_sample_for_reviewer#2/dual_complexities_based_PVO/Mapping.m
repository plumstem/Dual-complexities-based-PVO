function [modi_e,update] = Mapping(e,data)

update = 0;

if e == 1
    modi_e = e+data;
    update = 1;
elseif e > 1
    modi_e = e+1;
else
    modi_e = e;
end

end