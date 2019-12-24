function [T] = uploadData(path_parent,type,subject,speed,trail,sensor,max_column)

T = [];
%For Type Direc

temp = dir(path_parent);
ftype_name = temp(type+2).name;
path_type = strcat(path_parent,'\',ftype_name); 

    %For Subject Direc
    sublen = length(subject);
    for i = 1:sublen
        temp = dir(path_type);
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
                        
                            %For Data Loading                            
%                           disp(path_trail); % uncomment for debugging
                        
                            temp = readtable(path_trail);
                            
                            if type == 1
                                senlen = length(sensor);
                                for m = 1:senlen
                                    store = table2array(temp(:,(sensor(m)-1)*10 + 1));
                                    store(max_column) = 0;
                                    T = [ T, store ]; 
                                    
                                end
                            end
                            
                            if type == 2
                                senlen = length(sensor);
                                for m = 1:senlen
                                    store = table2array(temp(:,sensor(m)+1));
                                    store(max_column) = 0;
                                    T = [ T, store ];                                     
                                end
                            end
                    end
            end
    end

end

