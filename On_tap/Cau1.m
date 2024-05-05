clear;clc

%{
% NRZ-L
%% ======== Init
bitstream = [0 1 0 0 1 0 1 1 0 1]
pulse_high = 5;
pulse_low = 0;

%% ======== Create signal
for bit = 1:length(bitstream)
    %set bit time
    bt = bit-1:0.001:bit;
    if bitstream(bit) == 1
        y = (bt<bit)*pulse_high;
    else
        y = (bt<bit)*pulse_low;
    end
    try
        if bitstream(bit+1)==1
            y(end) = pulse_high;
        end
    catch e
        y(end) = pulse_high;
    end
    % draw pulse and label
    figure(1)
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
%}
% =======================================================
%{
% AMI
bitstream = [0 1 0 0 1 0 1 1 0 1]
pulse = 5;
current_pulse = -pulse;
for bit = 1:length(bitstream)
    bit_time = bit-1:0.001:bit;
    if bitstream(bit) == 0
        y = (bit_time<bit)*0;
    else
        current_pulse = -current_pulse;
        y = (bit_time<bit)*current_pulse;
    end
    try
        if bitstream(bit+1) == 1
            y(end) = -current_pulse;
        end
    catch e
        y(end) = -current_pulse;
    end
    plot(bit_time, y, 'LineWidth', 2);
    text(bit-0.5,pulse+0.5, num2str(bitstream(bit)), 'FontWeight', 'bold');
    hold on;
end
grid on;
axis([0 length(bitstream) -5 6]);
set(gca,'YTick', [-pulse pulse])
set(gca,'XTick', 1:length(bitstream))
title('Bipolar - AMI')
%}
%========================================
% Manchester
bitstream = [0 1 0 0 1 0 1 1 0 1]
pulse = 1;
yy = [];
for bit = 1:length(bitstream)
    bt = bit-1:0.01:bit;
    if bitstream(bit) == 1
        y = (bt<bit)*pulse - (bt<bit-0.5)*2*pulse;
        current_level = pulse;
    else
        y = -((bt<bit)*pulse - (bt<bit-0.5)*2*pulse);
        current_level = -pulse;
    end
    try
        if bitstream(bit+1) == bitstream(bit)
            y(end) = -current_level;
        else
            y(end) = current_level;
        end
    catch e
        y(end) = current_level;
    end
    plot(bt, y, 'LineWidth', 2);
    text(bit-0.5,pulse+0.25, num2str(bitstream(bit)), 'FontWeight', 'bold');
    hold on;
end
% draw grid
grid on;
axis([0 length(bitstream) -1 1.5]);
set(gca,'YTick', [-pulse pulse])
set(gca,'XTick', 1:length(bitstream))
title('Manchester')
