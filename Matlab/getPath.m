function [path_trail] = getPath(path_parent,type,subject,speed,trail)
temp = dir(path_parent);
ftype_name = temp(type+2).name;
path_type = strcat(path_parent,'\',ftype_name); 

temp = dir(path_type);
subject_name = temp(subject+2).name;
path_sub = strcat(path_type,'\',subject_name);

temp = dir(path_sub);
speed_name = temp(speed+2).name;
path_speed = strcat(path_sub,'\',speed_name);

temp = dir(path_speed);
if trail ~= 0
trail_name = temp(trail+2).name;
path_trail = strcat(path_speed,'\',trail_name);
else
path_trail = path_speed;
end

end

