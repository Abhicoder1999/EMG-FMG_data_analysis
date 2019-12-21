function [] = findPeak(data,m,var)
figure(1)
subplot(411)
plot(data)
xlim([0 length(data)])
grid on

fdata = conv(data,ones(1,m)/m);
subplot(412)
plot(fdata)
xlim([0 length(data)])
grid on

% Filter Design
% var = 0.3;
x = -1:0.001:1;
gaus = exp(-0.5.*((x)/var).^2)/sqrt(2*pi);
filt = diff(gaus);


filt_data = conv(-fdata,filt);
subplot(413)
plot(filt_data);
xlim([0 length(data)])
% findpeaks(filt_data)

filt_data = conv(fdata,filt);
subplot(414)
plot(filt_data);
xlim([0 length(data)])
% findpeaks(filt_data)

end

