function [max_rows] = getColumn(path_parent,type,subject,speed,trail,sensor)
max_rows = 0;
temp = dir(path_parent);
ftype_name = temp(type+2).name;
path_type = strcat(path_parent,'\',ftype_name); 

    %For Subject Direc
    sublen = length(subject);
    for i = 1:sublen
        temp = dir(path_type);
%         disp(path_type)
%         disp(temp)
        subject_name = temp(subject(i)+2).name;
        path_sub = strcat(path_type,'\',subject_name);
        
            %For Speed Direc
            speedlen = length(speed);
            for j = 1:speedlen
                temp = dir(path_sub);
                speed_name = temp(speed(j)+2).name;
                path_speed = strcat(path_sub,'\',speed_name);
               
                    %For Trail Direc
                    traillen = length(trail);
                    for k = 1:traillen
                        temp = dir(path_speed);
                        trail_name = temp(trail(k)+2).name;
                        path_trail = strcat(path_speed,'\',trail_name);
                        
                            %For max width finding                            
                            disp(path_trail);
                            temp = readtable(path_trail);
                            senlen = length(sensor);
                               for m = 1:senlen
                                   shape = size(temp(:,sensor(m)+1));
                                   if shape(1) > max_rows
                                       max_rows = shape(1);
                                   end
                               end  
                               
                    end
            end
    end

end

