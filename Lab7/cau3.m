clear all;
clear;clc
pulseCenter=10;
alpha=0.25;
n=4;
N=10;
data=randi([0 1],1,N)
data2 = pammod(data,2);
data_up= upsample(data2,4);
pulseTx = srrc(-pulseCenter:pulseCenter, alpha, 3);
s=conv(data_up,pulseTx,'full');
ynoisy = awgn(s,5,'measured');
figure(1);
plot(ynoisy)

r=ynoisy((pulseCenter+1):n:(end-pulseCenter));
r_de=pamdemod(r,2)
y_mf=conv(ynoisy,pulseTx,'full');
r_mf=y_mf((2*pulseCenter+1):n:(end-2*pulseCenter))
r_de1=pamdemod(r_mf,2)
figure(2);
plot(y_mf)

var(r)
var(r_mf)