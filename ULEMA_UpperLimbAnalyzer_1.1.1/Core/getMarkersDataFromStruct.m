%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function MARKER_DATA = getMarkersDataFromStruct(points, MarkerLabels)

pn = MarkerLabels;
nf = size(points.(pn{1}),1);
MARKER_DATA = zeros(3, length(MarkerLabels), nf);
for i = 1 : length(pn)
    if isfield(points,pn{i}) && ~isempty(points.(pn{i}))
        MARKER_DATA(:,i,:) = reshape(points.(pn{i})', 3, 1, nf);
    else
        MARKER_DATA(:,i,:) = NaN(3,1,nf);
    end
end
