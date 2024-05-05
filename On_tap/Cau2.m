clear ; clc

%{
bitstream = randi([0 1], 1, 20000); % So luong bit
fb=100; %(bps)
pulse_high = 1;
pulse_low = -1;
yy=[];
ts = 0.25; % Toc do lay mau
for bit = 1:length(bitstream)
    % set bit time
    bt = bit-1:ts:(bit-0.25);
    if bitstream(bit) == 0
        % low level pulse
        y = (bt<bit)*pulse_low;
    else
        % high level pulse
        y = (bt<bit) * pulse_high;
    end
    yy=[yy y];
end
k=zeros(100,800); % tong so mau: (1/ts)*so luong bit
for j=1:1:100
    k(j,:)=yy(800*j-799:800*j);
    sep(j,:)=fft(k(j,:),128);
end
n=size(sep,2);
fs=4*fb;
f = (0:n-1)*(fs/n); % frequency range
m_sep=mean((abs(sep).^2),1)/fs;
figure(1);
plot(f,m_sep);
% draw grid
grid on;
ylabel('Mean square voltage');
xlabel('Frequency');
title('Polar Non-Return-to-Zero Level');
%}


bitstream = randi([0 1], 1, 20000);
fb=100;
yy=[];
pulse = 5;
ts = 0.25;
current_level = -pulse;
for bit = 1:length(bitstream)
    % set bit time
    bt = bit-1:ts:(bit-0.25);
    if bitstream(bit) == 0
        % binary 0, set to zero
        y = (bt<bit)*0;
    else
        % each binary 1 has the opposite pulse level from the previous
        current_level = -current_level;
        y = (bt<bit)*current_level;
    end
    % assign last pulse point by inspecting the following bit
    try
        % we care only about ones as they use alternate levels
        if bitstream(bit+1) == 1
            y(end) = -current_level;
        end
    catch e
        % bitstream end; assume next bit is 0
        y(end) = -current_level;
    end
    yy=[yy y];
end
k=zeros(200,400);
for j=1:1:200
    k(j,:)=yy(400*j-399:400*j);
    sep(j,:)=fft(k(j,:),128);
end
n=size(sep,2);
fs=4*fb;
f = (0:n-1)*(fs/n); % frequency range
m_sep=mean((abs(sep).^2),1)/fs;
figure(1);
plot(f,m_sep);
grid on;
xlabel('Frequency')
title('Bipolar - AMI')

%{
num_bit = 20000;
bitstream = randi([0 1], 1, num_bit);
fb=100;
fs = 4;
pulse = 1;
yy=[];
for bit = 1:length(bitstream)
    % set bit time
    bt = bit-1:1/fs:(bit-0.25);
    if bitstream(bit) == 1
        % low -> high
        y = (bt<bit) * pulse - 2*pulse * (bt < bit- 0.5);
        % set last pulse point to high level
        current_level = pulse;
    else
        % high -> low
        y = -(bt<bit) * pulse + 2*pulse*(bt < bit - 0.5);
        % set last pulse point to low level
        current_level = -pulse;
    end
    try
        % if the next bit is the same as this one
        %change the level
        if bitstream(bit+1) == bitstream(bit)
            y(end) = -current_level;
        else
            y(end) = current_level;
        end
    catch e
        % assume next bit is the same as the last one
        y(end) = current_level;
    end
    yy=[yy y];
end
num_sample = fs*num_bit/100;
k=zeros(100,num_sample);
for j=1:1:100
    k(j,:)=yy(num_sample*j-(num_sample-1):num_sample*j);
    sep(j,:)=fft(k(j,:),128);
end
n=size(sep,2);
fs=4*fb;
f = (0:n-1)*(fs/n); % frequency range
m_sep=mean((abs(sep).^2),1)/fs;
figure(1);
plot(f,m_sep);
grid on;
xlabel('Frequency')
title('Manchester')
%}