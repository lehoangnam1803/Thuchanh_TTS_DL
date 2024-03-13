clear;clc
%stop n wait protocol
pass=0; % The total number of transmitted frames
m=10; % The number of frames
n=7; % The frame length
tx=zeros(m,m);
RequestToSend = true;
Arrivaltx = false;
arivalrx=false;
canSend = true;
sn=1;
rn = 1;

div=[1 0 0 1];
msg=randi([0,1],m,n);
pac=[];
msgrx=[];
tx = [];
px = 0;
prx = 1;
timer = 0.002; %timeout
while(sn<=m)
    pass=pass+1;
    %=============Transmitter
    if (RequestToSend&&canSend)
        pac(sn,:)=MakeFrame(msg(sn,:),div);
        tx(sn,:)= [pac(sn,1:8) mod(sn,2) pac(sn,9:18)]; % Add 1 bit
        fprintf('Tx - Truyen frame thu %d \n',sn); tic
        cn = sn;
        sn =sn+1;
        canSend = false;
        arivalrx=true;
    end

    %================Channel
    msgrx(cn,:)=bsc(tx(cn,:),px);

    %================Set timeout
    if (toc > timer)
        canSend = true;
        px=0;
        sn = sn-1;
    end
    %================Receiver
    if (arivalrx)
        if (msgrx(cn,1:8)==[0 1 1 1 1 1 1 0])
            if (msgrx(cn,9)==mod(rn,2)) % Check ACK
                fprintf('Rx - Nhan duoc frame %d \n',rn);
                %====CRC
                [q2,r2]=deconv(msgrx(cn,10:19),div);
                r2(1,:)=mod(r2(1,:),2);
                arivalrx=false;
                canSend = true;
                canSend = bsc(canSend,prx); % ACK loss
                prx = 0;
                if r2==0
                    rn=rn+1;
                    fprintf('Rx - San sang nhan frame thu %d \n',rn);
                else
                    rn=rn+1;
                    fprintf('Rx - Sai khong truyen lai %d\n',rn);
                end
            else
                fprintf('Rx - Trung bo frame thu %d \n',cn);
                canSend = true;
            end
        else
            fprintf('Rx - Khong nhan duoc frame %d \n',rn);
        end
    end
end