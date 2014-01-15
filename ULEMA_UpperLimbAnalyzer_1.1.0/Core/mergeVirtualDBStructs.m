%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [warningsList, trDB] = mergeVirtualDBStructs(trDB1in, trDB2in, duplAction)

% This function will add the non existing sections
% (subjects, sessions, trials) to trDB1, picking them
% from trDB2.

[trDB1, trDB2] = makeDBsCompatible(trDB1in, trDB2in);
trDB = trDB1;
warningsList = {};
subNames1 = getVirtualDBNames(trDB1, '', 'subjects', {});
subNames2 = getVirtualDBNames(trDB2, '', 'subjects', {});
for i = 1 : length(subNames2) % search for duplicates in subjects
    workbar(i / length(subNames2), ['Analysing subject ', trDB2.subjects(i).name, '...'], '');
    subInd = findc(subNames1, trDB2.subjects(i).name); % scalar or []
    if ~isempty(subInd) % if there is a duplicate for subjects
        sesNames1 = getVirtualDBNames(trDB1, {trDB1.subjects(subInd).name}, 'sessions', {});
        sesNames2 = getVirtualDBNames(trDB2, {trDB1.subjects(subInd).name}, 'sessions', {});
        for j = 1 : length(sesNames2) % search for duplicates in sessions
            sesInd = findc(sesNames1, trDB2.subjects(i).sessions(j).name); % scalar or []
            if ~isempty(sesInd) % if there is a duplicate for sessions
                trNames1 = strtokc(getVirtualDBNames(trDB1, {trDB1.subjects(subInd).name, trDB1.subjects(subInd).sessions(sesInd).name}, 'trials', {}),'->');
                trNames2 = strtokc(getVirtualDBNames(trDB2, {trDB1.subjects(subInd).name, trDB1.subjects(subInd).sessions(sesInd).name}, 'trials', {}),'->');
                for k = 1 : length(trNames2) % search for duplicates in trials
                    trInd = findc(trNames1, trDB2.subjects(i).sessions(j).trials(k).name); % scalar or []
                    if ~isempty(trInd) % if there is a duplicate for trials
                        % Overwriting the existing trial
                        if strcmp(duplAction, 'useNew')
                            trDB.subjects(subInd).sessions(sesInd).trials(trInd) = trDB2.subjects(i).sessions(j).trials(k); % need structure compatibility
                        end
                        if strcmp(duplAction, 'useOld')
                            trDB.subjects(subInd).sessions(sesInd).trials(trInd) = trDB1.subjects(i).sessions(j).trials(k); % need structure compatibility
                        end
                        warningsList{end+1,1} = [trDB2.subjects(i).name, '\', trDB2.subjects(i).sessions(j).name, '\', trDB2.subjects(i).sessions(j).trials(k).name];
                    else
                        trDB.subjects(subInd).sessions(sesInd).trials(end+1) = trDB2.subjects(i).sessions(j).trials(k);% need structure compatibility
                    end
                end
                % Merge best cycles
                bestCyclesCache = {};
                if isfield(trDB1in.subjects(subInd).sessions(sesInd),'bestCycles') && ~isempty(trDB1in.subjects(subInd).sessions(sesInd).bestCycles)
                    bestCyclesCache{1} = trDB1in.subjects(subInd).sessions(sesInd).bestCycles;
                else
                    bestCyclesCache{1} = [];
                end
                if isfield(trDB2in.subjects(i).sessions(j),'bestCycles') && ~isempty(trDB2in.subjects(i).sessions(j).bestCycles)
                    bestCyclesCache{2} = trDB2in.subjects(i).sessions(j).bestCycles;
                else
                    bestCyclesCache{2} = [];
                end
                if ~isempty(bestCyclesCache{1}) && ~isempty(bestCyclesCache{2}) 
                    if strcmp(duplAction, 'useOld')
                        bestCyclesCache([1,2]) = bestCyclesCache([2,1]);
                    end
                    trDB.subjects(subInd).sessions(sesInd).bestCycles = mergeBestCycles(bestCyclesCache);
                elseif isempty(bestCyclesCache{1}) && ~isempty(bestCyclesCache{2}) 
                    trDB.subjects(subInd).sessions(sesInd).bestCycles = bestCyclesCache{2};
                elseif ~isempty(bestCyclesCache{1}) && isempty(bestCyclesCache{2}) 
                    trDB.subjects(subInd).sessions(sesInd).bestCycles = bestCyclesCache{1};
                end
            else % if there is not a duplicate for sessions
                trDB.subjects(subInd).sessions(end+1) = trDB2.subjects(i).sessions(j);
            end
        end
    else % if there is not a duplicate for subjects
        trDB.subjects(end+1) = trDB2.subjects(i);
    end
end
disp('')


