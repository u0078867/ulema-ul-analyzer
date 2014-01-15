function[odata]=afgnew(idata,v);
% function AFGNEW; 
% calculates numerical derivative for position- and velocity data
% constants chosen for best frequency response around 50-100Hz sample frequency
% v = sample frequency (Hz)
% c (in program) = differentiation constants
% DirkJan, april 1991
[m,n]=size(idata);

c=[-1.5 -4 4 1.5]/14*v;
c=diag(c);

for i=1:n,
    tussen(:,1)=[0;0;idata(1:m-2,i)];
    tussen(:,2)=[0;idata(1:m-1,i)];
    tussen(:,3)=[idata(2:m,i);0];
    tussen(:,4)=[idata(3:m,i);0;0];

    tussen=tussen*c;
    odata(:,i)=sum(tussen')';
end

odata(1:2,:)=zeros(2,n);
odata(m-1:m,:)=zeros(2,n);

