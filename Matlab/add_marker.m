clear all;
clc
%% Initial Settings
warning('off','all');
T = [];
disp('select the Parent Directory...');
path_parent = uigetdir('..');


%% Input Section
speed = [];
subject = [];
type = [];
trail = [];
sensor = [];

if path_parent ~= 0
    disp('Provide Path Details to Targeted FMG sensor Toe_data...');
    subject = input('enter the subjects no:');
    speed = input('1.44kms/h(1),2.88kms/h(2),5.04kms/h(3):');
    trail = input('enter the trails to load:');
    toe_column = 12; %change to update the selected column
    heel_column = 13; %change to update the selected column 
else
    disp('Program Terminated...')
end
%% Loading EMG & FMG Data for a particular Trail
heel_column = heel_column -1;
toe_column = toe_column -1;
foot_sensors = [toe_column heel_column];
EMG_sensor = 1:4;%taking any sensor%input('Enter the EMG sensor(1-4):');

max_column2 = getColumn(path_parent,2,subject,speed,trail,foot_sensors); % to interpolate the data
max_column1 = getColumn(path_parent,1,subject,speed,trail,EMG_sensor); % to interpolate the data

temp = uploadData(path_parent,2,subject,speed,trail,foot_sensors,max_column2);

for i = 1:size(temp,2)
    T(:,i) = intrpData(temp(:,i),max_column1);
end

final_data = zeros(size(T));



%% Finding & Uploading Toe Marker

% Tunable Parameter    
shifted = -200; % how much you want to shift the segmentaion points by left, -ve for right shifting
ratio_avg = 1.5;
deriv_less = 0.1;

pdata1 = filterData(T(:,1),4);% change filterData for type == 4 parameter to change the chareceteristics
disp('preprocessing done..!');

%avragging
toe_data = pdata1(:,1);
data = toe_data;  

avg_num = length(data)/ratio_avg; % Avg of number of points to set the threshold
temp = sort(data,'descend');
avg = sum(temp(1:avg_num))/avg_num;

%derivative
bool = data >avg;
data = data .*bool;

deriv = abs(diff(data)) < deriv_less;
% bool = toe_data >0;
% deriv = deriv.*bool(1:length(deriv));
deriv = deriv.*data(1:length(deriv));

figure(1)
subplot(411)
plot(toe_data)
title('Toe off original data')

subplot(412)
plot(data)
title('segmented sections for peak selection')

subplot(413)
stem(deriv)
title('detected peaks of signal')

%index selection
max_winlen = 0;
cnt = 0;
for i = 1:length(data)
    
    if(data(i) ~= 0 )
        cnt = cnt +1;
    else
        if cnt > max_winlen
            max_winlen = cnt;
        end
        cnt = 0;
    end
end
index = find(deriv);
peaks = [];
cnt = 0;
derivf = zeros(length(deriv),1);
varlen = length(find(deriv));
for  i = 1:varlen
    if index(i)+floor(max_winlen) <= length(deriv)
        temp1 = deriv(index(i):index(i)+floor(max_winlen),1);
    else
        temp1 = deriv(index(i):length(deriv),1);
    end
    
    [val,idx] = max(temp1);
    if cnt == 0 || peaks(cnt) ~= (idx+index(i)-1)
        peaks = [peaks, idx+index(i)-1];
        cnt = cnt + 1;
        bool = zeros(length(temp1),1);
        bool(idx) = 1;
        temp2 = temp1.*bool;
        if index(i)+floor(max_winlen) <= length(deriv)
            deriv(index(i):index(i) + floor(max_winlen),1) = temp2;
            derivf(index(i):index(i) + floor(max_winlen),1) = temp2;
            varlen = length(find(deriv));
        else
            deriv(index(i):length(deriv)) = temp2;
            derivf(index(i):length(deriv)) = temp2;
            varlen = length(find(deriv));
        end
    end
end

% Segmentation pointes

derivf = circshift(derivf,-shifted); % negetive for left shift
derivf(length(data)) = 0;
peaks = find(derivf);
derivf(peaks(1)) = 0;
derivf(peaks(length(peaks))) = 0;

subplot(414)
stem(derivf)
hold on
plot(toe_data)
title('final selected marker points')

final_data(:,1) = derivf;

%% Finding & Uploading Heel Marker

% Tunable Parameter    
shifted = 400; % how much you want to shift the segmentaion points by left, -ve for right shifting
ratio_avg = 1.5;
deriv_less = 0.3;

pdata2 = filterData(T(:,2),3);% change filterData for type == 3 parameter to change the chareceteristics
disp('preprocessing done..!');

%avragging
heel_data = pdata2(:,1);

data = heel_data;  
avg_num = length(data)/ratio_avg; % Avg of number of points to set the threshold
temp = sort(data,'descend');
avg = sum(temp(1:avg_num))/avg_num;

%derivative
bool = data >avg;
data = data .*bool;

deriv = abs(diff(data)) < deriv_less;
% bool = toe_data >0;
% deriv = deriv.*bool(1:length(deriv));
deriv = deriv.*data(1:length(deriv));

figure(2)
subplot(411)
plot(heel_data)
title('heel strike original data')

subplot(412)
plot(data)
title('segmented sections for peak selection')

subplot(413)
stem(deriv)
title('detected peaks of signal')

%index selection
max_winlen = 0;
cnt = 0;
for i = 1:length(data)
    
    if(data(i) ~= 0 )
        cnt = cnt +1;
    else
        if cnt > max_winlen
            max_winlen = cnt;
        end
        cnt = 0;
    end
end
index = find(deriv);
peaks = [];
cnt = 0;
derivf = zeros(length(deriv),1);
varlen = length(find(deriv));
for  i = 1:varlen
    if index(i)+floor(max_winlen) <= length(deriv)
        temp1 = deriv(index(i):index(i)+floor(max_winlen),1);
    else
        temp1 = deriv(index(i):length(deriv),1);
    end
    
    [val,idx] = max(temp1);
    if cnt == 0 || peaks(cnt) ~= (idx+index(i)-1)
        peaks = [peaks, idx+index(i)-1];
        cnt = cnt + 1;
        bool = zeros(length(temp1),1);
        bool(idx) = 1;
        temp2 = temp1.*bool;
        if index(i)+floor(max_winlen) <= length(deriv)
            deriv(index(i):index(i) + floor(max_winlen),1) = temp2;
            derivf(index(i):index(i) + floor(max_winlen),1) = temp2;
            varlen = length(find(deriv));
        else
            deriv(index(i):length(deriv)) = temp2;
            derivf(index(i):length(deriv)) = temp2;
            varlen = length(find(deriv));
        end
    end
end

% Segmentation pointes

derivf = circshift(derivf,-shifted); % negetive for left shift
derivf(length(data)) = 0;
peaks = find(derivf);
derivf(peaks(1)) = 0;
derivf(peaks(length(peaks))) = 0;

subplot(414)
stem(derivf)
hold on
plot(heel_data)
title('final selected marker points')

final_data(:,2) = derivf;

%% Uploading Markers
choice = input('Do you want to update the File(1/0):');
    if choice == 1
        path_name = getPath(path_parent,2,subject,speed,[]);
        marker_base = 'zmarker';
        name = sprintf('%s%d',strcat(path_name,'\',marker_base),trail(1));
        xlswrite(name, final_data)
        disp('file saved in following location..')
        disp(name)
    end
%% General Offset and Onset Detection Algo
% data = T(:,2);
% findPeak(data,100,0.1);


