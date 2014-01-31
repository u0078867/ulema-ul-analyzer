%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function trialsInd = getSubstructIndices(dataStruct, prefix, indices)

trialsInd = [];
for i = 1 : length(dataStruct)
    ind = strfind(dataStruct(i).name, prefix);
    if ~isempty(ind) && ind(1) == 1
        trialsInd(end+1) = indices(i);
    end
end

