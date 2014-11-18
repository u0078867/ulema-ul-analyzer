%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ghV=ghestnew_gert_right_VECT(pc,ac,aa,ts,ai)

ghV = zeros(size(pc));
for i = 1 : size(pc,2)
%% Bony landmarks in global coordinate system (CS) m-->mm
gPC=pc(:,i)*1000;
gAC=ac(:,i)*1000;
gAA=aa(:,i)*1000;
gTS=ts(:,i)*1000;
gAI=ai(:,i)*1000;

%%
% GHESTNEW. Calculates GH from regression equations 
% according to Meskers et al 1997. juli 1996. C. Meskers.
%disp(['Warning in ghestnew: data must be provided in millimeters!!'])

gRs=asscap(gAC,gTS,gAI);% cordinate system (CS) of scapula in global CS
gOs=(gAC);% Origin of scapula in global CS

sRg=gRs';

sPC=sRg*(gPC-gOs);
sAC=sRg*(gAC-gOs);
sAA=sRg*(gAA-gOs);
sTS=sRg*(gTS-gOs);
sAI=sRg*(gAI-gOs);

lacaa=norm(sAC-sAA);
ltspc=norm(sTS-sPC);
laiaa=norm(sAI-sAA);
lacpc=norm(sAC-sPC);

% scx=[1 pc(1) ai(1) laiaa pc(2)]';
% scy=[1 lacpc pc(2) lacaa ai(1) ]';
% scz=[1 pc(2) pc(3) ltspc ]'; 

scx=[1 sPC(1) sAI(1) laiaa sPC(2)]';
scy=[1 lacpc  sPC(2) lacaa sAI(1) ]';
scz=[1 sPC(2) sPC(3) ltspc ]'; 

thx=[18.9743    0.2434    0.2341    0.1590    0.0558];
thy=[-3.8791   -0.1002    0.1732   -0.3940    0.1205];
thz=[-9.2629   -0.2403    1.0255    0.1720];
%previous version: thz=[ 9.2629   -0.2403    1.0255    0.1720];

sGHx = thx*scx;
sGHy = thy*scy;
sGHz = thz*scz;
sGH=[sGHx;sGHy;sGHz]; 

%% rotate to global
gGH=gRs*sGH;

%% sum with origin
gh=gOs+gGH;

%% mm-->m
gh = gh/1000;

ghV(:,i) = gh;
end
