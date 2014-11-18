%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% calibration pen point from 4 collinear markers
%
l1 = 457,5;
l2 = 369;
l3 = 266;
l4 = 147,5;
%l = [500 400 300 200];
P1 = squeeze(Markers(:,3,200:30:N));
P2 = squeeze(Markers(:,2,200:30:N));
P3 = squeeze(Markers(:,1,200:30:N));
P4 = squeeze(Markers(:,4,200:30:N));
[n,m] = size(P4);
E = (P1 - P4);
for i = 1:m;
    nE = norm(E(:,i))
    E(:,i) = E(:,i)/nE;
end;
%
% i = videoframe, specify N in command window
% E = unitvector derived from 2 points most distant from each other
% P = X + l*E, whereby X = coordinates of the pen point, thus
% X = P - l*E
%for i=1:4
    X1 = [P1 - l1*E];
    X2 = [P2 - l2*E];
    X3 = [P3 - l3*E];
    X4 = [P4 - l4*E];
%end;
X5 = (X1+X2+X3+X4)/4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
