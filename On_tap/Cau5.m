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
px=0.1;
%timer = 0.002; %timeout
while(sn<=m)
    pass=pass+1;
    %=============Transmitter
    if (RequestToSend&&canSend)
        pac(sn,:)=MakeFrame(msg(sn,:),div);
        tx(sn,:)= pac(sn,:);
        fprintf('Tx - Truyen frame thu %d \n',sn); %tic
        cn = sn;
        sn =sn+1;
        canSend = false;
        arivalrx=true;
    end
    %================Channel
    msgrx(cn,:)=bsc(tx(cn,:),px);

    %================Receiver
    if (arivalrx)
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
    end
end
