function [pac] = MakeFrame(data,div)    
    bit_data = [data, zeros(1,3)];
    [q,r]=deconv(bit_data,div);
    r = mod(r,2);
    pac = bitxor(bit_data,r);
    pac=[0 1 1 1 1 1 1 0 pac];
end