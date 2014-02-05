%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function writeCellVector(fid, cellVect, name, tabN)
for i = 1 : tabN
    fprintf(fid, '\t');
end
fprintf(fid, '%s:\t', name);
for c = 1 : length(cellVect)
    fprintf(fid, '%s\t', cellVect{c});
end
fprintf(fid, '\n');

