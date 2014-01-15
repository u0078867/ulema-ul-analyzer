%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function saveStructData(subject, trToUseDB, trDB, savePath, splitProcDataLevels, procDataSaving)

%version = currFileVersion();

if ~isempty(trToUseDB)
    % Merge loaded data for subject with the new computed data for the same subject
    if strcmp(procDataSaving, 'overwrite')
        subInd = strcmp({trToUseDB.subjects.name},subject.name);
        oldSubDB.subjects(1) = loadStructData(trToUseDB, trToUseDB.subjects(subInd).name);
    elseif strcmp(procDataSaving, 'safe_merge')
        [warningsList, newTrToUseDB] = mergeVirtualDBStructs(trDB, trToUseDB, 'useNew');
        subInd = strcmp({newTrToUseDB.subjects.name},subject.name);
        oldSubDB.subjects(1) = loadStructData(newTrToUseDB, newTrToUseDB.subjects(subInd).name);        
    end
    newSubDB.subjects(1) = subject;
    [warningsList, newSubDBTemp] = mergeVirtualDBStructs(oldSubDB, newSubDB, 'useNew');
    subjectsToSave(1) = newSubDBTemp.subjects;
    clear newSubDBTemp % free some RAM
    % This operation is necessary because the mergeVirtualDBStructs only creates compatible copy into the "trials" branch
%     for j = 1 : length(subjectsToSave(1).sessions)
%         for k = 1 : length(newSubDB.subjects(1).sessions)
%             if isfield(newSubDB.subjects(1).sessions(k),'bestCycles')
%                 if strcmp(subjectsToSave(1).sessions(j).name, newSubDB.subjects(1).sessions(k).name)
% %                     subjectsToSave(1).sessions(j).static = newSubDB.subjects(1).sessions(j).static;
% %                     subjectsToSave(1).sessions(j).staticRef = newSubDB.subjects(1).sessions(j).staticRef;
% %                     bestCyclesCache{1} = subjectsToSave(1).sessions(j).bestCycles;
% %                     bestCyclesCache{2} = newSubDB.subjects(1).sessions(k).bestCycles;
% %                     subjectsToSave(1).sessions(j).bestCycles = mergeBestCycles(bestCyclesCache);
%                 end
%             end
%         end
%     end
else
    subjectsToSave(1) = subject;
end

% Removing "path" and "subPath" fields from trials 
for j = 1 : length(subjectsToSave.sessions)
    if isfield(subjectsToSave.sessions(j).trials,'path')
        subjectsToSave.sessions(j).trials = rmfield(subjectsToSave.sessions(j).trials,'path');
    end
    if isfield(subjectsToSave.sessions(j).trials,'subPath')
        subjectsToSave.sessions(j).trials = rmfield(subjectsToSave.sessions(j).trials,'subPath');
    end
end

% Split the data for the subject into levels defined by the user
if sum(strcmp(splitProcDataLevels,'subject'))
    filePath = fullfile(savePath, [subjectsToSave(1).name, '.mat']);
    subjects = subjectsToSave;
    h = waitbar(0,'Saving .mat file. Please wait...');
    save(filePath,'subjects');
    waitbar(1,h);
    close(h);
    clear subjects;
end
if sum(strcmp(splitProcDataLevels,'session'))
    subjects(1).name = subjectsToSave(1).name;
    for j = 1 : length(subjectsToSave(1).sessions)
        dirPath = fullfile(savePath, subjectsToSave(1).name);
        mkdir(dirPath);
        subjects(1).sessions(1) = subjectsToSave.sessions(j);
        if isfield(subjectsToSave.sessions(j), 'bestCycles')
            subjects(1).sessions(1).bestCycles = subjectsToSave(1).sessions(j).bestCycles;
        end
%         subjects(1).sessions(1).static = subjectsToSave(1).sessions(j).static;
%         subjects(1).sessions(1).staticRef = subjectsToSave(1).sessions(j).staticRef;
        filePath = fullfile(dirPath, [subjects(1).sessions(1).name, '.mat']);
        h = waitbar(0,'Saving .mat file. Please wait...');
        save(filePath,'subjects');
        waitbar(1,h);
        close(h);
    end
    clear subjects;
end
if sum(strcmp(splitProcDataLevels,'trial'))
    subjects(1).name = subjectsToSave(1).name;
    dirPath = fullfile(savePath, subjectsToSave(1).name);
    mkdir(dirPath);
    for j = 1 : length(subjectsToSave(1).sessions)
        dirPath = fullfile(savePath, subjectsToSave(1).name, subjectsToSave(1).sessions(j).name);
        mkdir(dirPath);
        subjects(1).sessions(1).name = subjectsToSave(1).sessions(j).name;
        for k = 1 : length(subjectsToSave(1).sessions(j).trials)
            subjects(1).sessions(1).trials(1) = subjectsToSave.sessions(j).trials(k);
            % --- It is chosen to save also the session-related data (bestCycles)
            if isfield(subjectsToSave.sessions(j), 'bestCycles')
                subjects(1).sessions(1).bestCycles = subjectsToSave(1).sessions(j).bestCycles;
            end
%             subjects(1).sessions(1).static = subjectsToSave(1).sessions(j).static;
%             subjects(1).sessions(1).staticRef = subjectsToSave(1).sessions(j).staticRef;
            % ---
            filePath = fullfile(dirPath, [subjects(1).sessions(1).trials(1).name(1:end-4), '.mat']);
            h = waitbar(0,'Saving .mat file. Please wait...');
            save(filePath,'subjects');
            waitbar(1,h);
            close(h);
        end
    end
    clear subjects;
end





