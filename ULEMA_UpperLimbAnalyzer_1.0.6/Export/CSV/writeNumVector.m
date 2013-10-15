%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function writeNumVector(fid, numVect, name, tabN)
for i = 1 : tabN
    fprintf(fid, '\t');
end
fprintf(fid, '%s:\t', name);
[nRow, nCol] = size(numVect);
if nRow > nCol
    numVect2 = numVect';
else
    numVect2 = numVect;
end
for r = 1 : size(numVect2,1)
    for c = 1 : size(numVect2,2)
        fprintf(fid, '%f\t', numVect2(r,c));
    end
    if r < size(numVect2,1)
        fprintf(fid, '\n');
        for i = 1 : tabN
            fprintf(fid, '\t');
        end
        fprintf(fid, '\t');
    end
end
fprintf(fid, '\n');

