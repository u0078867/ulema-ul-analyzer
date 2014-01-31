%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function newPath = rmTreeFromPath(oldPath, folder)

t = cell(1,1000);   % preallocate for speed
[t{1},r] = strtok(oldPath,';');
t{1} = [t{1},';'];
cont = 1;
while ~isempty(r)
    [temp, r] = strtok(r, ';');
    r = r(2:end);
    if isempty(strfind(temp,folder))
        cont = cont + 1;
        t{cont} = [temp, ';'];
    end
end
t(cellfun('isempty', t)) = []; % erase preallocated empty cells
newPath = cell2mat(t);
newPath = newPath(1:end-1); % descard last ';'

