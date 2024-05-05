clear;clc
data=randi([0 1],1, 10);
addbit = [0 0 0];
bit_data = [data addbit];
div=[1 0 1 1];
[q,r]=deconv(bit_data,div);
r = mod(r,2);
tx_data = bitxor(bit_data,r)
p_error = 0.1; %xac suat loi
rx_data = bsc(tx_data,p_error);
[qcheck, rcheck] = deconv(rx_data,div);
rcheck = mod(rcheck,2);
check = sum(rcheck);
if check ~= 0
    disp("Retransmission Required");
else
    disp("TRANSMISSION SUCCESSFUL");
end