clear;clc
m=10; % The number of frames
n=7; % The frame length
div=[1 0 0 1];
msg=randi([0,1],m,n);
sn=1;
tx=[];
pac=[];
msgrx=[];
px=0.1; 
while(sn<=m)
    pac(sn,:)=MakeFrame(msg(sn,:),div);
    tx(sn,:) = pac(sn,:);
    cn=sn;
    sn=sn+1;

    msgrx(cn,:)=bsc(tx(cn,:),px);
end


