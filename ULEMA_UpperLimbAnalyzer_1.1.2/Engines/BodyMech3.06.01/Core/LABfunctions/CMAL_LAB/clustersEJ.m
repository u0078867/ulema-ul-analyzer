%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% upperarmcluster 
UA1=squeeze(MyMarkers(:,1,:));
UA2=squeeze(MyMarkers(:,2,:));
UA3=squeeze(MyMarkers(:,3,:));
UA4=squeeze(MyMarkers(:,4,:));
%
UA = {UA1, UA2, UA3, UA4};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% forearmcluster 
%
LA1=squeeze(MyMarkers(:,5,:));
LA2=squeeze(MyMarkers(:,6,:));
LA3=squeeze(MyMarkers(:,7,:));
LA4=squeeze(MyMarkers(:,8,:));
%
LA = {LA1, LA2, LA3, LA4};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% handcluster 
%
H1=squeeze(MyMarkers(:,9,:));
H2=squeeze(MyMarkers(:,10,:));
H3=squeeze(MyMarkers(:,11,:));
%
H = {H1, H2, H3};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% acromionarmcluster 
%
ACR1=squeeze(MyMarkers(:,12,:));
ACR2=squeeze(MyMarkers(:,13,:));
ACR3=squeeze(MyMarkers(:,14,:));
%
ACR = {ACR1, ACR2, ACR3};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sternumcluster 
%
ST1=squeeze(MyMarkers(:,15,:));
ST2=squeeze(MyMarkers(:,16,:));
ST3=squeeze(MyMarkers(:,17,:));
%
ST = {ST1, ST2, ST3};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scapulacluster 
%
SCAP1=squeeze(MyMarkers(:,18,:));
SCAP2=squeeze(MyMarkers(:,19,:));
SCAP3=squeeze(MyMarkers(:,20,:));
%
SCAP = {SCAP1, SCAP2, SCAP3};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
