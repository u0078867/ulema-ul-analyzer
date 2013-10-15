%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function res = GetMapNames(namesMap, names, sourceCol, destCol)

% This function searches into the cell-array "namesMap", for all names in
% cell-array "names" using column "sourceCol", and then retrieves the same
% corresponding names in column destCol.
% This function is used to map names in a cell-array database.

for i = 1 : length(names)
    ind = strcmp(names{i}, namesMap(:,sourceCol));
    if sum(ind) > 1 % if more copies are found, set to []
        res{i} = [];
    elseif sum(ind) == 0 % if no copies are found, set to source name
        res{i} = names{i};
    else
        res{i} = namesMap(ind,destCol);
    end
end




