%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function writeCurvesGroup(fid, curvesStruct, name)
fprintf(fid, '%s\n', name);
fn = fieldnames(curvesStruct);
N = max(size(curvesStruct.(fn{1})));
for c = 1 : length(fn)
    fprintf(fid, '%s\t', fn{c});
    for t = 1 : N
        vect = curvesStruct.(fn{c});
        fprintf(fid, '%f\t', vect(t));
    end
    fprintf(fid, '\n');
end

