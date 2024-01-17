%Lab_1
%% Part 1
clear;clc
fs = 1000; % sample frequency (Hz)
ts=1/fs;
t = 0:1/fs:2-1/fs;
x = (1.5)*sin(2*pi*2*t); %+ sin(2*pi*50*t) + 0.5*sin(2*pi*150*t);
n = length(x); % number of samples
noise=0.106*randn([1,n]); %10dB = 0.3354; 20dB = 0.106
x=x+noise;
subplot(2,1,1)
stem(t,x)
subplot(2,1,2)
plot(t,x)
%xlim([0 0.5])

%% Part 2
y = fft(x); %
f = (0:n-1)*(fs/n); % frequency range
power = abs(y).^2/n; % power of the DFT
figure (2)
subplot(2,1,1)
plot(f,power)
xlabel('Frequency')
ylabel('Power')
y0 = fftshift(y); % shift y values
f0 = (-n/2:n/2-1)*(fs/n); % 0-centered frequency range
power0 = abs(y0).^2/n; % 0-centered power

subplot(2,1,2)
plot(f0,power0)
xlabel('Frequency')
ylabel('Power')

%% Part3 
data = randi([0 1],1,10);
data_re=reshape(data,2,[]);
data_map= bi2de(data_re','left-msb')';
s=pammod(data_map,4);
stem(real(s))
fb=10000;
t=0:1/fb:0.05-1/fb;
M=4;
fbaud=fb/log2(M);
data = randi([0 1],1,length(t));

figure (1)
subplot(2,1,1)
stem(t,data)
data_re=reshape(data,2,[]);
data_map= bi2de(data_re','left-msb')';
s=pammod(data_map,M);

subplot(2,1,2)
tsym=0:1/fbaud:0.05-1/fbaud;
stem(tsym,real(s))

%% Part 4
fid = fopen('Test.txt');
x=fread(fid,'*char');
binvecc = logical(dec2bin(x, 8) - '0');
bit_steam=reshape(binvecc',1,[]);

%% Part 5
A = imread('Tu.jpg');
B=rgb2gray(A);
imshow(B)
