%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function allSubPaths = getAllSubPaths(subject, mod)

allSubPaths = {};
for j = 1 : length(subject.sessions)
    if ~isempty(subject.sessions(j).trials)
        allSubPaths = [allSubPaths, {subject.sessions(j).trials.subPath}];
    end
end
allSubPaths = unique(allSubPaths);
switch mod
    case 'onlyMAT'
        ind = [];
        for i = 1 : length(allSubPaths)
            if ~strcmp(allSubPaths{i}(end-3:end),'.mat');
                ind = [ind i];
            end
        end
        allSubPaths(ind) = [];
end
