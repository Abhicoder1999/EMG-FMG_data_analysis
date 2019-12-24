clear all;
clc
%% Initial Settings
warning('off','all');
T = [];
disp('select the Parent Directory...');
path_parent = uigetdir('..');

segmentaion_type = 1; % 2 (segmentaion on basis of heel data), 1 (segmentaion on basis of toe data)

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
    EMG_sensor = input('enter the EMG sensor(1-4):');
    FMG_sensor = input('enter the FMG sensor(1-8):');
    
    marker_base = 'zmarker'; %change the base name
    marker_extension = '.csv'; %marker extention 
else
    disp('Program Terminated...')
end
%% Data Loading

path_speed = getPath(path_parent,2,subject,speed,0);
path_marker = strcat(path_speed,'\',sprintf('%s%d%s',marker_base,trail,marker_extension));
mdata = readtable(path_marker);
Mdata = table2array(mdata);
    
max_column1 = getColumn(path_parent,1,subject,speed,trail,1:4); % to interpolate the data
max_column2 = getColumn(path_parent,2,subject,speed,trail,1:8); % to interpolate the data

Edata = uploadData(path_parent,1,subject,speed,trail,EMG_sensor,max_column1);
Fdata_temp = uploadData(path_parent,2,subject,speed,trail,FMG_sensor,max_column2);

if max_column1 > max_column2
    Fdata = zeros(max_column1,length(FMG_sensor));
    for m = 1:length(FMG_sensor)
        Fdata(:,m) = intrpData(Fdata_temp(:,m),max_column1);
    end
    T = intrpData(T,max_column1);

else
    temp = zeros(max_column2,length(EMG_sensor));
    for m = 1:length(EMG_sensor)
        temp(:,m) = intrpData(Edata(:,m),max_column2);
        clear Edata;
        Edata = temp;
    end
end


peaks = Mdata(:,segmentaion_type) >0;
peaks(max_column1) = 0;

peaks1 = Mdata(:,1)>0;
peaks2 = Mdata(:,2)>0;
peaks1(max_column1) = 0;
peaks2(max_column1) = 0;
%% Preprocess Data
for m = 1:length(EMG_sensor)
    Edata(:,m) = filterData(Edata(:,m),1);
end
for m = 1:length(FMG_sensor)
    Fdata(:,m) = filterData(Fdata(:,m),2);
end

points = find(peaks);
diff_max = 0;
diff_min = length(peaks);
    
 for m = 1:length(points)-1
    temp = points(m+1)- points(m);
    if temp > diff_max
       diff_max = temp+1;
    end
    if temp < diff_min
       diff_min = temp;
    end
end
    

%% Segmentation
choice = input('want to view segemented data?(1/0):');
if choice == 1

    row = input('Number of rows for ploting:');
    column = input('Number of column for ploting:');
    
    figure(2)
for i = 1:length(EMG_sensor)
    data1 = [];
    for m = 1:length(points)-1
        temp = Edata(points(m):points(m+1),i);
        temp = temp(1:diff_min);
        data1 = [data1,temp]; 
    end
    subplot(row,column,i)
    plot(data1)
    title(sprintf('%s%d','For Multiple Gait Cycle reading of EMGS',EMG_sensor(i)))
    xlabel('time (ms)')
    ylabel('EMG Amplitude')
    xlim([0 diff_min])
   
end

for i = 1:length(FMG_sensor)
    data2 = [];
    for m = 1:length(points)-1
        temp = Fdata(points(m):points(m+1),i);
        temp = temp(1:diff_min);
        data2 = [data2,temp]; 
    end
    subplot(row,column,i+length(EMG_sensor))
    plot(data2)
    title(sprintf('%s%d','For Multiple Gait Cycle reading of FMGS',FMG_sensor(i)))
    xlabel('time (ms)')
    ylabel('FMG Amplitude')
    xlim([0 diff_min])
end
end
%% Avg & Standard Deviation Plots

choice = input('Want Avg & StdDev plots?(1/0):');
if choice == 1
row = input('Number of rows for ploting:');
column = input('Number of column for ploting:');

figure(3)
for i = 1:length(EMG_sensor)
    data1 = [];
    for m = 1:length(points)-1
        temp = Edata(points(m):points(m+1),i);
        temp = temp(1:diff_min);
        data1 = [data1,temp]; 
    end
    data = mean_stdDev(data1); % input in shape (:,no_of_segment)
    temp = transpose(1:length(data));
    subplot(row,column,i)
    plot(data)
    plot(temp',data(:,2)','k','Linewidth',2)
    hold on
    plot(temp',data(:,1)','k')
    hold on
    plot(temp',data(:,3)','k')
    fill([temp' fliplr(temp')],[data(:,3)' fliplr(data(:,1)')],'k');
    alpha(0.5);
   
    title(sprintf('%s%d','For Multiple Gait Cycle reading of EMGS',EMG_sensor(i)))
    xlabel('time (ms)')
    ylabel('EMG Amplitude')
%     legend('upper_limit','mean','lower_limit')
    xlim([0 diff_min])
   
end

for i = 1:length(FMG_sensor)
    data2 = [];
    for m = 1:length(points)-1
        temp = Fdata(points(m):points(m+1),i);
        temp = temp(1:diff_min);
        data2 = [data2,temp]; 
    end
    data = mean_stdDev(data2);% input in shape (:,no_of_segment)
    temp = transpose(1:length(data));

    subplot(row,column,i+length(EMG_sensor))
    plot(temp',data(:,2)','k','Linewidth',2)
    hold on
    plot(temp',data(:,1)','k')
    hold on
    plot(temp',data(:,3)','k')
   
    fill([temp' fliplr(temp')],[data(:,3)' fliplr(data(:,1)')],'k');
    alpha(0.5);
%     legend('upper_limit','mean','lower_limit')
    title(sprintf('%s%d','For Multiple Gait Cycle reading of FMGS',FMG_sensor(i)))
    xlabel('time (ms)')
    ylabel('FMG Amplitude')
    xlim([0 diff_min])
end 

EMG_scale = input('enter EMG scale:');
FMG_scale = input('enter FMG scale:');

figure(3)
for i = 1:length(EMG_sensor)
    data1 = [];
    for m = 1:length(points)-1
        temp = Edata(points(m):points(m+1),i);
        temp = temp(1:diff_min);
        data1 = [data1,temp]; 
    end
    data = mean_stdDev(data1); % input in shape (:,no_of_segment)
    data = data/EMG_scale;
    temp = transpose(1:length(data));
    subplot(row,column,i)
    plot(data)
    plot(temp',data(:,2)','k','Linewidth',2)
    hold on
    plot(temp',data(:,1)','k')
    hold on
    plot(temp',data(:,3)','k')
    fill([temp' fliplr(temp')],[data(:,3)' fliplr(data(:,1)')],'k');
    alpha(0.5);
   
    title(sprintf('%s%d','For Multiple Gait Cycle reading of EMGS',EMG_sensor(i)))
    xlabel('time (ms)')
    ylabel('EMG Amplitude')
%     legend('upper_limit','mean','lower_limit')
    xlim([0 diff_min])
   
end

for i = 1:length(FMG_sensor)
    data2 = [];
    for m = 1:length(points)-1
        temp = Fdata(points(m):points(m+1),i);
        temp = temp(1:diff_min);
        data2 = [data2,temp]; 
    end
    data = mean_stdDev(data2);% input in shape (:,no_of_segment)
    data = data/FMG_scale;
    temp = transpose(1:length(data));

    subplot(row,column,i+length(EMG_sensor))
    plot(temp',data(:,2)','k','Linewidth',2)
    hold on
    plot(temp',data(:,1)','k')
    hold on
    plot(temp',data(:,3)','k')
   
    fill([temp' fliplr(temp')],[data(:,3)' fliplr(data(:,1)')],'k');
    alpha(0.5);
%     legend('upper_limit','mean','lower_limit')
    title(sprintf('%s%d','For Multiple Gait Cycle reading of FMGS',FMG_sensor(i)))
    xlabel('time (ms)')
    ylabel('FMG Amplitude')
    xlim([0 diff_min])
end 

end
%% Ploting sensor with marker

choice = input('view toe & heel markers for sensor data?(1/0):');
if choice == 1
% row = input('Number of rows for ploting:');
% column = input('Number of column for ploting:');

for i = 1:length(EMG_sensor)
figure(i)
    subplot(211)
    plot(Edata(:,i))
    title(sprintf('%s%d','For Multiple Gait Cycle reading of EMGS',EMG_sensor(i)))
    xlim([0 size(Fdata,1)])
    grid on
    
    subplot(212)
    plot(peaks1)
    hold on
    plot(-peaks2)
    legend('toeOff','heelStrike')
    grid on
    xlim([0 size(Fdata,1)])
    xlabel('time (ms)')
    ylabel('EMG Amplitude')
end

for i = 1:length(FMG_sensor)
    figure(i+length(EMG_sensor))
    subplot(211)
    plot(Fdata(:,i))
    title(sprintf('%s%d','For Multiple Gait Cycle reading of FMGS',FMG_sensor(i)))
    xlim([0 size(Fdata,1)])
    grid on
    
    subplot(212)
    plot(peaks1)
    hold on
    plot(-peaks2)
    legend('toeOff','heelStrike')
    xlim([0 size(Fdata,1)])
    xlabel('time (ms)')
    ylabel('FMG Amplitude')
    grid on
end

end
disp('Program Over')

%% Onset and Offset Estimation

% data = Fdata(:,1);
% figure(1)
% subplot(311)
% plot(data);
% xlim([0 length(data)])
% 
% % Filt Design
% var = 0.3;
% x = -1:0.001:1;
% gaus = exp(-0.5.*((x)/var).^2)/sqrt(2*pi);
% filt = diff(gaus);
% 
% 
% filt_data = conv(data,-filt);
% subplot(312)
% plot(filt_data);
% xlim([0 length(data)])
% 
% filt_data = conv(data,filt);
% subplot(313)
% plot(filt_data);
% xlim([0 length(data)])

