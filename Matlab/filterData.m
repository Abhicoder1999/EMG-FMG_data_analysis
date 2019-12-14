function [pdata] = filterData(data,type)

shape = size(data);
pdata = zeros(shape);

if type == 1
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

if type == 2
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

end

