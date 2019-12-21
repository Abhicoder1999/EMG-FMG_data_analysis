function [intrData] = intrpData(data,m)
    DATA = fft(data);
    DATA(m) = 0;
    intrData = real(ifft(DATA));
end

