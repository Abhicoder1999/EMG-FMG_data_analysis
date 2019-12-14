clear all;
clc
%% Initial Settings
warning('off','all');
T = [];
disp('select the Parent Directory...');
path_parent = uigetdir();


%% Input Section
speed = [];
subject = [];
type = [];
trail = [];
sensor = [];

if path_parent ~= 0
    disp('Data Loading Enabled...');
    type = input('EMG(1),FMG(2)signal:');
    subject = input('enter the subjects no:');
    speed = input('1.44kms/h(1),2.88kms/h(2),5.04kms/h(3):');
    trail = input('enter the trails to load:');
    sensor = input('enter sensor_data to load EMG(1-4), FMG(1-8):');
    
else
    disp('Program Terminated...')
end

%% Loading
max_column = getColumn(path_parent,type,subject,speed,trail,sensor); % to interpolate the data
T = uploadData(path_parent,type,subject,speed,trail,sensor,max_column);


%% Mode
mode = input('enter the variant mode Trail(1),Subject(2),Speed(3),Sensor(4):');

% Preprocess
data = T;
pdata = filterData(data,type);
disp('preprocessing done..!');


% Results
if mode == 4
    figure(4)
    for i = 1:length(sensor)
        subplot(length(sensor),1,i)
        plot(pdata(:,i))
        title(sprintf('%s%d','Sensor',sensor(i)));
        xlim([0 max_column])
        if type == 1
            ylabel('EMG Amplitude')
            xlabel('time (ms)')
        else
            ylabel('FMG Amplitude')
            xlabel('time (ms)')
        end
    end
elseif mode == 3
    figure(3)
    names = [];
    for i = 1:length(speed)
          plot(pdata(:,i));
          names = [names; sprintf('%s%d','Speed',speed(i))];
          legend(names)
          hold on;
          xlim([0 max_column])
          
         
    end
    if type == 1
            title(sprintf('%s%d','EMG senor',sensor(1)))
            ylabel('EMG Amplitude')
            xlabel('time (ms)')
    else
            title(sprintf('%s%d','FMG senor',sensor(1)))
            ylabel('FMG Amplitude')
            xlabel('time (ms)')
    end

elseif mode == 2
    figure(2)
    names = [];
    for i = 1:length(subject)
           plot(pdata(:,i));
          names = [names; sprintf('%s%d','Subject',subject(i))];
          legend(names)
          hold on;
          xlim([0 max_column])
    end
    if type == 1
            title(sprintf('%s%d','EMG senor',sensor(1)))
            ylabel('EMG Amplitude')
            xlabel('time (ms)')
    else
            title(sprintf('%s%d','FMG senor',sensor(1)))
            ylabel('FMG Amplitude')
            xlabel('time (ms)')
    end
  
 elseif mode == 1
    figure(1)
    names = [];
    for i = 1:length(trail)
          plot(pdata(:,i));
          names = [names; sprintf('%s%d','Trail',trail(i))];
          legend(names)
          hold on;
          xlim([0 max_column])
    end
    if type == 1
            title(sprintf('%s%d','EMG senor',sensor(1)))
            ylabel('EMG Amplitude')
            xlabel('time (ms)')
    else
            title(sprintf('%s%d','FMG senor',sensor(1)))
            ylabel('FMG Amplitude')
            xlabel('time (ms)')
    end
end
disp('Results shown')