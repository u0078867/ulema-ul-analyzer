%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [R,O] = CreateFrameFromCluster(markersData)

nF = size(markersData,3);
R = zeros(3,3,nF);
O = zeros(3,nF);
for i = 1 : nF
    %[dummy1, T] = LocalReferenceFrame(squeeze(markersData(:,1:3,i)));
    [dummy1, T] = LocalReferenceFrame(squeeze(markersData(:,:,i)));
    R(:,:,i) = T(1:3,1:3);
    O(:,i) = T(1:3,4);
end

