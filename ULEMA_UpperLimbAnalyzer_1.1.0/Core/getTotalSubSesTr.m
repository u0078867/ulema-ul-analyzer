%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [nSub, nSes, nTr] = getTotalSubSesTr(trToUseDB)

nSub = length(trToUseDB.subjects);
nSes = 0;
nTr = 0;
for i = 1 : nSub  % cycle for every subject 
    nSes = nSes + length(trToUseDB.subjects(i).sessions);
    for j = 1 : length(trToUseDB.subjects(i).sessions) % cycle for every session
        nTr = nTr + length(trToUseDB.subjects(i).sessions(j).trials);
    end
end


