%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function enginesInfo = eGetAllEngines(rootDir)

enginesDir = fullfile(rootDir, 'Engines');
dirContent = dir(enginesDir);
dirContent = dirContent(3:end); % descard '.' and '..' folders
toErase = find(~[dirContent.isdir]);
dirContent(toErase) = [];
toErase = strcmp({dirContent.name},'Common');
dirContent(toErase) = [];
engToErase = [];
for i = 1 : length(dirContent)
    engineIFiles = dir(fullfile(rootDir, 'Engines', dirContent(i).name));
    % Search for the first interface file
    pedex = [];
    for j = 1 : length(engineIFiles)
        if engineIFiles(j).isdir == 0
            [t, r] = strtok(engineIFiles(j).name,'_');
            pedex = strtok(r(2:end),'.');
            break;
        end
    end
    if isempty(pedex)
        fprintf('\nWARNING: no interface files for engine: %s', dirContent(i).name);
        engToErase(end+1) = i;
    else
        fprintf('\nEngine %s detected', dirContent(i).name);
    end
    % Add info for the current engine
    enginesInfo(i).pedex = pedex;
    enginesInfo(i).name = dirContent(i).name;
end
enginesInfo(engToErase) = [];
