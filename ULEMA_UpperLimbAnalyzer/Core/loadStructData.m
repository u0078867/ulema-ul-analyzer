%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function data = loadStructData(trToUseDB, name)

% Create a cache table
subInd = strcmp({trToUseDB.subjects.name},name);
allSubPaths = getAllSubPaths(trToUseDB.subjects(subInd), 'all');
for c = 1 : length(allSubPaths)
    cache{c,1} = allSubPaths{c};
    [dummy1,dummy2,ext] = fileparts(allSubPaths{c});
    neverProc = isempty(ext);
    if neverProc
        % Load a c3d structure
        [fullPath,dummy1,dummy2] = fileparts(allSubPaths{c}); % go up of one level with respect to the subject path
        cache{c,2} = importVirtualDBStruct(fullPath, 'c3d', 'tree', 1, name);
    else
        % Load data from the mat file
        cache{c,2} = load(allSubPaths{c});
    end
end

% Scan every trial of the current subject
sessions = trToUseDB.subjects(subInd).sessions;
data.name = name;
for j = 1 : length(sessions)
    bestCyclesCache = {};
    bestCyclesFound = 0;
    data.sessions(j).name = sessions(j).name;
    for k = 1: length(sessions(j).trials)
        % Load db
        subPath = sessions(j).trials(k).subPath;
        cacheInd = strcmp(cache(:,1),subPath);
        tempDB = cache{cacheInd,2};
        % Get indices for the current trial in the loaded db
        subInd = strcmp({tempDB.subjects.name},name);
        sesInd = strcmp({tempDB.subjects(subInd).sessions.name},sessions(j).name);
        trInd = strcmp({tempDB.subjects(subInd).sessions(sesInd).trials.name},sessions(j).trials(k).name);
        % Copy the data 
        [dummy1,dummy2,ext] = fileparts(subPath);
        neverProc = isempty(ext);
        if ~neverProc
            % Search for best cycles field and check if it's the same for all the trials
            if bestCyclesFound == 1
                if isfield(tempDB.subjects(subInd).sessions(sesInd), 'bestCycles') && ~isempty(tempDB.subjects(subInd).sessions(sesInd).bestCycles)
                    bestCyclesCache{end+1} = tempDB.subjects(subInd).sessions(sesInd).bestCycles;
                end
            else
                if isfield(tempDB.subjects(subInd).sessions(sesInd), 'bestCycles') && ~isempty(tempDB.subjects(subInd).sessions(sesInd).bestCycles)
                    bestCycles = tempDB.subjects(subInd).sessions(sesInd).bestCycles;
                    bestCyclesCache{1} = bestCycles;
                    bestCyclesFound = 1;
                end
            end
        end
        if neverProc
            tempDB.subjects(subInd).sessions(sesInd).trials(trInd).data = [];
        end
        % Note: do not copy directly tempDB.subjects(subInd).sessions(sesInd).trials(trInd) because structure could be incompatible
        data.sessions(j).trials(k).name = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).name;
        data.sessions(j).trials(k).protocolID = sessions(j).trials(k).protocolID;
        data.sessions(j).trials(k).protocolData = sessions(j).trials(k).protocolData;
        data.sessions(j).trials(k).data = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).data;
        data.sessions(j).trials(k).path = sessions(j).trials(k).path;
        data.sessions(j).trials(k).subPath = sessions(j).trials(k).subPath;
        if isfield(tempDB.subjects(subInd).sessions(sesInd).trials(trInd), 'cycles')
            data.sessions(j).trials(k).cycles = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).cycles;
        end   
        if isfield(tempDB.subjects(subInd).sessions(sesInd).trials(trInd), 'contextSideTable')
            data.sessions(j).trials(k).contextSideTable = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).contextSideTable;
        end
        data.sessions(j).trials(k).static = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).static;
        data.sessions(j).trials(k).staticRef = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).staticRef;
        data.sessions(j).trials(k).DJC = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).DJC;
        data.sessions(j).trials(k).MHA = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).MHA;
        data.sessions(j).trials(k).version = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).version;
        if isfield(tempDB.subjects(subInd).sessions(sesInd).trials(trInd), 'calib')
            data.sessions(j).trials(k).calib = tempDB.subjects(subInd).sessions(sesInd).trials(trInd).calib;
        end
    end
    % If there are different bestCycles, and in case merge them 
    if bestCyclesFound == 1
        if length(bestCyclesCache) == 1
            data.sessions(j).bestCycles = bestCyclesCache{1};
        else
            data.sessions(j).bestCycles = mergeBestCycles(bestCyclesCache);
        end
    else
        data.sessions(j).bestCycles = [];
    end
end








