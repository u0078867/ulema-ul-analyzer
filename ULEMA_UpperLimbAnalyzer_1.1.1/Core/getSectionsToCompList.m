%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function sections = getSectionsToCompList(sectionsToComp)

sections = {};
sectionsNames = fieldnames(sectionsToComp);
for s = 1 : length(sectionsNames)
    if sectionsToComp.(sectionsNames{s}) == 1
        sections{end+1} = sectionsNames{s};
    end
end


