%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function writeCellMatrix(fid, cellMatrix, name, tabN)
for i = 1 : tabN
    fprintf(fid, '\t');
end
fprintf(fid, '%s:\n', name);
for r = 1 : size(cellMatrix,1)
    for i = 1 : tabN
        fprintf(fid, '\t');
    end
    for c = 1 : size(cellMatrix,2)
        cel = cellMatrix{r,c};
        if ischar(cel)
            esc = '%s';
        elseif isnumeric(cel)
            esc = '%f';
        else
            esc = '%s';
        end
        fprintf(fid,[esc,'\t'], cel);
    end
    fprintf(fid,'\n');
end

