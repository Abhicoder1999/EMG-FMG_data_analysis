function [data,diff_min] = segmentData(path_parent,type,subject,speed,trail,sensor)

    max_column = getColumn(path_parent,type,subject,speed,trail,sensor); % to interpolate the data
    T = uploadData(path_parent,type,subject,speed,trail,[sensor,13],max_column);
    peaks = T(:,length(sensor)+1);
    points = find(peaks);
    diff_max = 0;
    diff_min = length(peaks);
    
    for i = 1:length(points)-1
        temp = points(i+1)- points(i);
        if temp > diff_max
            diff_max = temp+1;
        end
        if temp < diff_min
            diff_min = temp;
        end
    end
    data = [];
    sensor_data = T(:,1);
    sensor_data = filterData(sensor_data,2);
    for i = 1:length(points)-1
        temp = sensor_data(points(i):points(i+1));
        temp = temp(1:diff_min);
        data = [data,temp];
    end
    

end

