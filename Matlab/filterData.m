function [pdata] = filterData(data,type)

shape = size(data);
pdata = zeros(shape);

if type == 1  %For EMG
    order = 4;
    Fs = 1000;
    Fc = 6;
    wn = Fc/(Fs/2);
    for i = 1:shape(2)
        temp = data(:,i);
        temp = abs(temp);
        [b,a] = butter(order,wn);
        pdata(:,i) = filter(b,a,temp);
    end
end

if type == 2  %For FMG
    order = 4;
    Fs = 200;
    Fc = 5;
    wn = Fc/(Fs/2);
    for i = 1:shape(2)
        temp = data(:,i);
        [b,a] = butter(order,wn);
        pdata(:,i) = filter(b,a,temp);
    end
end

if type == 3  %For Hill_Data
    order = 5;
    Fs = 200;
    Fc = 2;
    wn = Fc/(Fs/2);
    for i = 1:shape(2)
        temp = data(:,i);
        [b,a] = butter(order,wn);
        pdata(:,i) = filter(b,a,temp);
       
    end
end

if type == 4  %For Toe_Data
    order = 5;
    Fs = 200;
    Fc = 2;
    wn = Fc/(Fs/2);
    for i = 1:shape(2)
        temp = data(:,i);
        [b,a] = butter(order,wn);
        pdata(:,i) = filter(b,a,temp);
   
    end
end


end

