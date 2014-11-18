%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = appDelProtToTrial(handles, type, addOrDel)

% Getting the current protocol
protID = get(handles.protocolsList,'Value');
protNames = get(handles.protocolsList,'String');

% Appending the protocol ID to the selected trials
switch type
    case 'trial'    % Link protocol to the selected trial(s)
        l = get(handles.subjectsList,'String');
        n = get(handles.subjectsList,'Value');
        currSub = l{n};
        l = get(handles.sessionsList,'String');
        n = get(handles.sessionsList,'Value');
        currSes = l{n};
        [l, r] = strtokc(get(handles.trialsList,'String'),'->');
        n = get(handles.trialsList,'Value');
        [subDB_ID, sesDB_ID, trDB_ID] = getVirtualDBIndexes(handles.trDB, {currSub, currSes, l(n)});
        % Cycling for every selected trial
        for i = 1 : length(trDB_ID)
            if addOrDel
                handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{i}).protocolID = protNames{protID};
            else
                handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{i}).protocolID = [];
            end
        end
    case 'trialsAllSes'    % Link protocol to the selected trial(s) for all sessions of the selected subject
        l = get(handles.subjectsList,'String');
        n = get(handles.subjectsList,'Value');
        currSub = l{n};
        allSessions = getVirtualDBNames(handles.trDB, {currSub}, 'sessions', {});
        [l, r] = strtokc(get(handles.trialsList,'String'),'->');
        n = get(handles.trialsList,'Value');
        for i = 1 : length(allSessions)
            [subDB_ID, sesDB_ID, trDB_ID] = getVirtualDBIndexes(handles.trDB, {currSub, allSessions{i}, l(n)});
            % Cycling for every selected trial
            for j = 1 : length(trDB_ID)
                if ~isempty(trDB_ID{j})
                    if addOrDel
                        handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{j}).protocolID = protNames{protID};
                    else
                        handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{j}).protocolID = [];
                    end
                end
            end
        end
    case 'trialsAllSub'    % Link protocol to the selected trial(s) for all the sessions of all the subjects
        % Getting all the subjects
        allSubjects = get(handles.subjectsList,'String');
        for i = 1 : length(allSubjects)
            % Getting all the sessions of the subject
            allSessions = getVirtualDBNames(handles.trDB, {allSubjects{i}}, 'sessions', {});
            % Getting trials to use
            [l, r] = strtokc(get(handles.trialsList,'String'),'->');
            n = get(handles.trialsList,'Value');
            for j = 1 : length(allSessions)
                [subDB_ID, sesDB_ID, trDB_ID] = getVirtualDBIndexes(handles.trDB, {allSubjects{i}, allSessions{j}, l(n)});
                % Cycling for every selected trial
                for k = 1 : length(trDB_ID)
                    if ~isempty(trDB_ID{k})
                        if addOrDel
                            handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{k}).protocolID = protNames{protID};
                        else
                            handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{k}).protocolID = [];
                        end
                    end
                end
            end
        end
    case 'session'  % Link protocol to all the trials of the selected session
        l = get(handles.subjectsList,'String');
        n = get(handles.subjectsList,'Value');
        currSub = l{n};
        l = get(handles.sessionsList,'String');
        n = get(handles.sessionsList,'Value');
        currSes = l{n};
        % Getting all the trials in the session
        [allTrials, dummy] = strtokc(getVirtualDBNames(handles.trDB, {currSub, currSes}, 'trials', {}), '->');
        [subDB_ID, sesDB_ID, trDB_ID] = getVirtualDBIndexes(handles.trDB, {currSub, currSes, allTrials});
        % Cycling for every trial of the session
        for i = 1 : length(trDB_ID)
            if addOrDel
                handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{i}).protocolID = protNames{protID};
            else
                handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{i}).protocolID = [];
            end
        end
    case 'subject'  % Link protocol to all the trials of all the sessions of the selected subject
        l = get(handles.subjectsList,'String');
        n = get(handles.subjectsList,'Value');
        currSub = l{n};
        % Getting all the sessions of the subject
        allSessions = getVirtualDBNames(handles.trDB, {currSub}, 'sessions', {});
        for j = 1 : length(allSessions)  % Cycling for every session of the selected subject
            % Getting all the trials in the session
            [allTrials, dummy] = strtokc(getVirtualDBNames(handles.trDB, {currSub, allSessions{j}}, 'trials', {}), '->');
            [subDB_ID, sesDB_ID, trDB_ID] = getVirtualDBIndexes(handles.trDB, {currSub, allSessions{j}, allTrials});
            % Cycling for every trial of the session
            for i = 1 : length(trDB_ID)
                if addOrDel
                    handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{i}).protocolID = protNames{protID};
                else
                    handles.trDB.subjects(subDB_ID).sessions(sesDB_ID).trials(trDB_ID{i}).protocolID = [];
                end
            end
        end
end

temp = handles.trDB;
% save('temp_trDB','-struct','temp');
















