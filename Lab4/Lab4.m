clear;clc
%% Câu 2: Viet chuong trinh ma hoa CRC 4 bit
data=[1 0 0 1];
addbit = [0 0 0];
bit_data = [data addbit];
div=[1 0 1 1];
[q,r]=deconv(bit_data,div);
r = mod(r,2);
tx_data = bitxor(bit_data,r);

%% Cau 3: Ma hoa qua kenh truyen nhi phan co xac suat loi = 0.2
rx_data = bsc(tx_data,0.2);
% Check
[qcheck, rcheck] = deconv(rx_data,div);
rcheck = mod(rcheck,2);
check = sum(rcheck);
if check ~= 0
    disp("Retransmission Required");
else
    disp("TRANSMISSION SUCCESSFUL");
end
