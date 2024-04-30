clear;clc

t = -10:10;
alpha = 0.25;
Ts = 3;

X = srrc(t,alpha,Ts);
plot(X)