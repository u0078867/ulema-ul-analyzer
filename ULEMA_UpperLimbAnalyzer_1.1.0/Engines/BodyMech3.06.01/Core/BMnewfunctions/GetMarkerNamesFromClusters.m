%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function MarkerLabels = GetMarkerNamesFromClusters

% This function is not used at the moment!

BodyMechFuncHeader

MarkerLabels = {};
for i = 1 : length(BODY.SEGMENT)
    MarkerLabels = [MarkerLabels, BODY.SEGMENT(i).Cluster.MarkerLabels];
end
MarkerLabels = unique(MarkerLabels);    % delete repeated names (ex. more clusters with a shared marker)
