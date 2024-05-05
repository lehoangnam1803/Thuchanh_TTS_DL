clear all;clc
pulseCenter=10; 
alpha=0.25;
Nspsym = 4;% Number of sample per symbol
N=10; % Number of bit
power_of_noise = 5;

%% ============Transmit
data=randi([0 1],1,N) % Generate data

% PAM modulation
data2 = pammod(data,2);

% Raised cosine
data_up= upsample(data2,4);
pulseTx = srrc(-pulseCenter:pulseCenter, alpha, 3);
s=conv(data_up,pulseTx,'full');

% Channel
ynoisy = awgn(s,power_of_noise,'measured');

%% =============Receive
r=ynoisy((pulseCenter+1):Nspsym:(end-pulseCenter))
r_de=pamdemod(r,2)
y_mf=conv(ynoisy,pulseTx,'full');
r_mf=y_mf((2*pulseCenter+1):Nspsym:(end-2*pulseCenter))
r_de_mf=pamdemod(r_mf,2)

%% =====Power
r_power = mean(abs(r).^2)
r_mf_power = mean(abs(r_mf).^2)

%% =======Plot
figure(1);
plot(ynoisy)
figure(2);
plot(y_mf)

%% Raised Cosine
t = -10:10
x = srrc(t, 0.5, 3)
plot(t,x);