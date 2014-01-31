%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function res = isequalTable(cellTable1, cellTable2, cols)

% Compares to "cols" columns of 2 tables in a form of 2-dim cell-array
% and check if they contain the same data. Order of the rows is not
% important.

res = 1;
if xor(isempty(cellTable1), isempty(cellTable2))   % 1 if one is empty and the other one no
    res = 0;
    return
end
if isempty(cellTable1) && isempty(cellTable2) % 1 if they are both empty
    return;
end
cellTable1 = cleanTableFromEmptyLines(cellTable1(:,cols));
cellTable2 = cleanTableFromEmptyLines(cellTable2(:,cols));
if size(cellTable1, 1) ~= size(cellTable2, 1)
    res = 0;
    return
end
N = size(cellTable1, 1);
for r1 = 1 : N
    matchFound = 0;
    for r2 = 1 : N
        matchFound = isequal(cellTable1(r1,:),cellTable2(r2,:));
        if matchFound == 1
            break;
        end
    end
    if matchFound == 0
        res = 0;
        return
    end
end

