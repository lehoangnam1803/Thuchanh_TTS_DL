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
px=1; 
timer = 3;
resent = 0;
while(sn<=m)
    pass=pass+1;
    %=============Transmitter
    if (RequestToSend&&canSend)
        pac(sn,:)=MakeFrame(msg(sn,:),div);
        tx(sn,:)= pac(sn,:);
        if (resent)
            fprintf('Tx - Truyen lai frame thu %d \n',sn-1);
            resent = 0;
        else
            fprintf('Tx - Truyen frame thu %d \n',sn);
            cn = sn;
            sn =sn+1;
        end
        canSend = false;
        arivalrx=true;
    end

    %================Channel
    msgrx(cn,:)=bsc(tx(cn,:),px);
    
    %================Receiver
    if (arivalrx)
        if (msgrx(cn,1:8)==[0 1 1 1 1 1 1 0])
            fprintf('Rx - Nhan duoc frame %d \n',rn);
            [q2,r2]=deconv(msgrx(cn,:),div);
            r2(1,:)=mod(r2(1,:),2);
            arivalrx=false;
            canSend = true;
            if r2==0
                rn=rn+1;
                fprintf('Rx - San sang nhan frame thu %d \n',rn);
            else
                rn=rn+1;
                fprintf('Rx - Sai khong truyen lai %d\n',rn);
            end
        else
            fprintf('Rx - Khong nhan duoc frame %d \n',rn);
            timer = timer - 1;
            if timer == 0
                px = 0;
                resent = 1;
                canSend=true;
            end
        end
    end
end