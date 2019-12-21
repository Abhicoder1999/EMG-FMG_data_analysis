function [data] = mean_stdDev(input)
data = zeros(length(input),3);
temp = transpose(input);
data_std = std(temp);
data_mean = mean(temp);

temp = data_mean + data_std;
data(:,1) = transpose(temp);
temp = data_mean;
data(:,2) = transpose(temp);
temp = data_mean - data_std;
data(:,3) = transpose(temp);

% disp(size(data))
end

