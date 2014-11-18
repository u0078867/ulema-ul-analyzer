%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function trDBReduced = loadStruct(fullPath, fileExt, structType, groupType)

switch fileExt
    case 'c3d'
        trDBReduced = importVirtualDBStruct(fullPath, fileExt, structType, 0, [], groupType);
    case 'mat'
        % load data
        trDB = load(fullPath);
        % keep only protocol ID and name and add the path
        for i = 1 : length(trDB)
            trDBReduced.subjects(i).name = trDB.subjects(i).name;
            for j = 1 : length(trDB.subjects(i).sessions)
                trDBReduced.subjects(i).sessions(j).name = trDB.subjects(i).sessions(j).name;
                for k = 1 : length(trDB.subjects(i).sessions(j).trials)
                    trDBReduced.subjects(i).sessions(j).trials(k).name = trDB.subjects(i).sessions(j).trials(k).name;
                    trDBReduced.subjects(i).sessions(j).trials(k).protocolID = trDB.subjects(i).sessions(j).trials(k).protocolID;
                    trDBReduced.subjects(i).sessions(j).trials(k).protocolData = trDB.subjects(i).sessions(j).trials(k).protocolData;
                    trDBReduced.subjects(i).sessions(j).trials(k).version = trDB.subjects(i).sessions(j).trials(k).version;
                    trDBReduced.subjects(i).sessions(j).trials(k).subPath = fullPath;
                    trDBReduced.subjects(i).sessions(j).trials(k).path = fullPath;
                end
            end
        end
        % free the RAM with the data. It will recovered later by the full path field
        clear trDB
end

