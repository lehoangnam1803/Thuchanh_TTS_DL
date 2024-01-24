clear;clc
%bitstream = [ 0 0 0 0 0 0 0 0 0 0 0];
%bitstream = [ 1 1 1 1 1 1 1 1 1 1];
bitstream = [ 0 1 0 0 1 1 0 0 0 1 0];
pulse_high = 5;
pulse_low = -5;
for bit = 1:length(bitstream)
    % set bit time
    bt = bit-1:0.001:bit;
    if bitstream(bit) == 0
        % low level pulse
        y = (bt<bit)*pulse_low;
    else
        % high level pulse
        y = (bt<bit) * pulse_high;
    end

    try
        if bitstream(bit+1) == 1
            y(end) = pulse_high;
        else
            y(end) = pulse_low;
        end
    catch e
        % assume next bit is 1
        y(end) = pulse_high;
    end

    % draw pulse and label
    plot(bt, y, 'LineWidth', 2);
    text(bit-0.5,pulse_high+0.5, num2str(bitstream(bit)), 'FontWeight', 'bold');
    hold on;
end

% draw grid
grid on;
axis([0 length(bitstream) pulse_low-1 pulse_high+1]);
set(gca,'YTick', [pulse_low pulse_high])
set(gca,'XTick', 1:length(bitstream))
title('Unipolar Non-Return-to-Zero Level')

%% Part 2
clear ; clc
bitstream = randi([0 1], 1, 10000);
fb=100;

pulse_high = 1;
pulse_low = -1;
yy=[];
for bit = 1:length(bitstream)
    % set bit time
    bt = bit-1:0.25:(bit-0.25);
    if bitstream(bit) == 0
        % low level pulse
        y = (bt<bit)*pulse_low;

    else
        % high level pulse
        y = (bt<bit) * pulse_high;
    end
    yy=[yy y];

end
k=zeros(100,400);
for j=1:1:100
    k(j,:)=yy(400*j-399:400*j);
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

%% Part 3
clear;clc
bitstream = [ 0 1 0 0 1 1 0 0 0 1 0];
% pulse height
pulse = 5;
% assume that current pulse level is a "low" pulse (binary 1)
% this is the pulse level for the bit before given bitstream
current_level = -pulse;
for bit = 1:length(bitstream)
    % set bit time
    bt=bit-1:0.001:bit;
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

    % draw pulse and label
    plot(bt, y, 'LineWidth', 2);
    text(bit-0.5,pulse+0.5, num2str(bitstream(bit)), 'FontWeight', 'bold');
    hold on;
end

% draw grid
grid on;
axis([0 length(bitstream) -5 6]);
set(gca,'YTick', [-pulse pulse])
set(gca,'XTick', 1:length(bitstream))
title('Unipolar Non-Return-to-Zero Level')

%% Part 4: spectrum of AMI
clear ; clc
bitstream = randi([0 1], 1, 10000);
fb=100;
yy=[];

pulse = 5;
current_level = -pulse;
for bit = 1:length(bitstream)
    % set bit time
    bt = bit-1:0.25:(bit-0.25);
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
k=zeros(100,400);
for j=1:1:100
    k(j,:)=yy(400*j-399:400*j);
    sep(j,:)=fft(k(j,:),128);
end
n=size(sep,2);
fs=4*fb;
f = (0:n-1)*(fs/n); % frequency range

m_sep=mean((abs(sep).^2),1)/fs;
figure(1);
plot(f,m_sep);

%% Manchester
clear;clc
bitstream = [ 0 1 0 0 1 1 0 0 0 1 0];
% pulse height
pulse = 1;
yy=[];
for bit = 1:length(bitstream)
    % set bit time
    bt = bit-1:0.01:(bit);
    if bitstream(bit) == 1
        % low -> high
        y = (bt<bit) * pulse - 2*pulse * (bt < bit - 0.5);
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

     % draw pulse and label
    plot(bt, y, 'LineWidth', 2);
    text(bit-0.5,pulse+0.25, num2str(bitstream(bit)), 'FontWeight', 'bold');
    hold on;
end

% draw grid
grid on;
axis([0 length(bitstream) -1 1.5]);
set(gca,'YTick', [-pulse pulse])
set(gca,'XTick', 1:length(bitstream))
title('Unipolar Non-Return-to-Zero Level')

%% Spectrum of Manchester
clear ; clc
bitstream = randi([0 1], 1, 10000);
fb=100;
yy=[];

pulse = 1;
yy=[];
for bit = 1:length(bitstream)
    % set bit time
    bt = bit-1:0.25:(bit-0.25);
    if bitstream(bit) == 1
        % low -> high
        y = (bt<bit) * pulse - 2*pulse * (bt < bit - 0.5);
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
k=zeros(100,400);
for j=1:1:100
    k(j,:)=yy(400*j-399:400*j);
    sep(j,:)=fft(k(j,:),128);
end
n=size(sep,2);
fs=4*fb;
f = (0:n-1)*(fs/n); % frequency range

m_sep=mean((abs(sep).^2),1)/fs;
figure(1);
plot(f,m_sep);