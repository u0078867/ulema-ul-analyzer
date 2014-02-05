%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function res = isequalTablesList(cellTableList1, cellTableList2)

% Compare a list (1-dim cell array) or cell tables. Order of the list is
% important

res = 1;

if xor(isempty(cellTableList1), isempty(cellTableList2))   % 1 if one is empty and the other one no
    res = 0;
    return
end
N = max(length(cellTableList1), length(cellTableList2));
for i = 1 : N
    if xor(isempty(cellTableList1{i}), isempty(cellTableList2{i}))   % 1 if one is empty and the other one no
        res = 0;
        return
    end
    if isequalTable(cellTableList1{i}, cellTableList2{i}, 1) == 0
        res = 0;
        return
    end
end



