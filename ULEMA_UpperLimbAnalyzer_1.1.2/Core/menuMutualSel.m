%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = menuMutualSel(handles, list, selected)

for i = 1 : length(list)
    currItem = list{i};
    if strcmp(currItem, selected)
        set(handles.(list{i}), 'Checked', 'on')
    else
        set(handles.(list{i}), 'Checked', 'off')
    end
end

