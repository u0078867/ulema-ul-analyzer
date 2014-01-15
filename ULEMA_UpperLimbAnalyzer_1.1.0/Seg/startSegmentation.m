%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function cycles = startSegmentation(data, evConfig, firstLastOverlapped, mergeContexts, contexts, sideForMerge, freq, toCutAndNorm, f)

%% Reading raw events
rawEventTime = data.stParam.eventsRaw.eventTime;
rawEventType = data.stParam.eventsRaw.eventType;
rawEventSide = data.stParam.eventsRaw.eventSide;
if length(rawEventTime) == 1
    msgbox('File: only one event found, impossible to segment trial', 'application error', 'error');
    return;
end
[rawEventTime, I] = sort(rawEventTime);
rawEventType = rawEventType(I);
rawEventSide = rawEventSide(I);

%% Automatically detecting events to be kept
sidesToUse =  contexts(:,1);
strCreated = 0;
  
for i = 1 : length(rawEventSide) % Cycle for every event
    for s = 1 : length(sidesToUse) % Cycle for every wanted side
        if strcmp(rawEventSide{i}, sidesToUse{s})
            if strCreated == 0 || ~isfield(newEventTime,sidesToUse{s})
                newEventTime.(sidesToUse{s})(1) = rawEventTime(i);
                newEventType.(sidesToUse{s}){1} = rawEventType{i};
                newEventSide.(sidesToUse{s}){1} = rawEventSide{i};
                strCreated = 1;
            else
                newEventTime.(sidesToUse{s})(end+1) = rawEventTime(i);
                newEventType.(sidesToUse{s}){end+1} = rawEventType{i};
                newEventSide.(sidesToUse{s}){end+1} = rawEventSide{i};
            end
            break;            
        end
    end
end
foundSides = fieldnames(newEventTime);
    
if mergeContexts == 1
    
    % All the wanted context are merged in only one context called "Merged" 

    c = 0;
    for s = 1 : length(foundSides) % Cycle for every event
        for i = 1 : length(newEventTime.(foundSides{s}))
            c = c + 1;
            newEventTime.Merged(c) = newEventTime.(foundSides{s})(i);
            newEventType.Merged{c} = newEventType.(foundSides{s}){i};
            newEventSide.Merged{c} = newEventSide.(foundSides{s}){i};
        end
    end
   foundSides = [foundSides, {'Merged'}];
    
end

%% Cycle for every found side

for s = 1 : length(foundSides)

    eventTime = newEventTime.(foundSides{s});
    eventType = newEventType.(foundSides{s});
    eventSide = newEventSide.(foundSides{s});
    
    if length(eventTime) == 1
        msg = sprintf('File: only one event found for context %s, impossible to segment trial', foundSides{s});
        msgbox(msg, 'application error', 'error');
        return;
    end
    
    %% Calculating event parameters
    
    data.firstFrame = 1;    
    switch evConfig.type

        case 'manual'

            contCycle = 1;
            contEvSync = 1;
            fStart = [];
            fSync = [];
            fStop = [];
            evStartFound = false;
            if isempty(evConfig.evSync) == 0
                evSyncFound = false;
            else
                evSyncFound = true;
            end
            evStopFound = false;
            for ev = 1 : length(eventTime)
                % evName = [eventSide{ev}(1), eventType{ev}];
                evName = eventType{ev};
                % finding evStart
                if isFoundStr(evConfig.evStart, evName) && evStartFound == false
                    stParamCell{contCycle}.events.(eventSide{ev}).(evConfig.evStart) = ceil( eventTime( ev )*freq ) - data.firstFrame + 1;
                    fStart(contCycle) = stParamCell{contCycle}.events.(eventSide{ev}).(evConfig.evStart);
                    stParamCell{contCycle}.events.evStart = evConfig.evStart;
                    evStartFound = true;
                    continue;
                end
                if isempty(evConfig.evSync) == 0
                    % finding evSync
                    if isFoundStr(evConfig.evSync{contEvSync}, evName) && evStartFound == true && evSyncFound == false
                        stParamCell{contCycle}.events.(eventSide{ev}).(evConfig.evSync{contEvSync}) = ceil( eventTime( ev )*freq ) - data.firstFrame + 1;
                        stParamCell{contCycle}.events.evSync{contEvSync} = evConfig.evSync{contEvSync};
                        fSync(contCycle,contEvSync) = stParamCell{contCycle}.events.(eventSide{ev}).(evConfig.evSync{contEvSync});
                        contEvSync = contEvSync + 1;
                        if contEvSync > length(evConfig.evSync)
                            evSyncFound = true;
                            contEvSync = 1;
                        end
                        continue;
                    end
                else
                    fSync = [];
                    stParamCell{contCycle}.events.evSync = {};
                end
                % finding evStop
                if isFoundStr(evConfig.evStop, evName) && evStartFound == true && evSyncFound == true && evStopFound == false
                    stParamCell{contCycle}.events.(eventSide{ev}).(evConfig.evStop) = ceil( eventTime( ev )*freq ) - data.firstFrame + 1;
                    fStop(contCycle) = stParamCell{contCycle}.events.(eventSide{ev}).(evConfig.evStop);
                    stParamCell{contCycle}.events.evStop = evConfig.evStop;
                    evStopFound = true;
                    if firstLastOverlapped == 1
                        if isempty(evConfig.evSync) == 0    % sync events wanted
                            if (ev+1) <= length(eventSide) && isFoundStr(evConfig.evSync{1}, eventType{ev+1})

                                % set the next evStart equal to the current evStop
                                stParamCell{contCycle+1}.events.(eventSide{ev}).(evConfig.evStart) = ceil( eventTime( ev )*freq ) - data.firstFrame + 1;
                                fStart(contCycle+1) = stParamCell{contCycle+1}.events.(eventSide{ev}).(evConfig.evStart);
                                stParamCell{contCycle+1}.events.evStart = evConfig.evStart;

                                % skip the next "finding evStart"
                                evStartFound = true;
                            else
                                % reset evStart flag
                                evStartFound = false;
                            end
                        else % no sync events wanted
                            if evConfig.evStart == evConfig.evStop
                                if isFoundStr(evConfig.evStop, evName)
                                    stParamCell{contCycle+1}.events.(eventSide{ev}).(evConfig.evStart) = ceil( eventTime( ev )*freq ) - data.firstFrame + 1;
                                    fStart(contCycle+1) = stParamCell{contCycle+1}.events.(eventSide{ev}).(evConfig.evStart);
                                    stParamCell{contCycle+1}.events.evStart = evConfig.evStart;
                                    % skip the next "finding evStart"
                                    evStartFound = true;
                                else
                                    % reset evStart flag
                                    evStartFound = false;
                                end
                            end
                        end
                    else
                        evStartFound = false;
                    end % end if firstLastOverlapped == 1
                    % reset the ramaining flags
                    evStopFound = false;
                    if isempty(evConfig.evSync) == 0
                        evSyncFound = false;
                    else
                        evSyncFound = true;
                    end
                    % consider the next cycle
                    contCycle = contCycle + 1;
                    continue;

                end 
            end
            contCycle = contCycle - 1;

        case 'auto'

            % For further use...

    end
    if contCycle == 0
        msgbox('File: no cycles found', 'application error', 'error');
        return;
    end

    %% Subtracting offset (if requested) from the angles (Garofalo 2009)
    if isfield(data,'angles')

        for i = 1 : length(evConfig.fieldsToShift)
            data.angles.([evConfig.fieldsToShift{i},'_withOffset']) = data.angles.(evConfig.fieldsToShift{i});
            evConfig.fieldsColToShift
            for j = evConfig.fieldsColToShift{i}
                offVect = [];
                for c = 1 : length(contCycle)
                    offInd = stParamCell{c}.events.( sideName(evConfig.evForOffset(1)) ).(evConfig.evForOffset);
                    offVect = [offVect data.angles.(evConfig.fieldsToShift{i})(offInd,j)];
                end
                offMean = mean(offVect);
                data.angles.(evConfig.fieldsToShift{i})(:,j) = data.angles.(evConfig.fieldsToShift{i})(:,j) - offMean;
            end
        end

    end

    %% Copying and Cutting data
    for i = 1 : contCycle % cycle for every trial
        for k = 1 : length(toCutAndNorm)
            % <signal>Cut and <signal>Norm structure creation
            fn = fieldnames(data.(toCutAndNorm{k}));
            for j = 1 : length(fn)
                % Data cut and normalization in time window (101 time
                % points)
                xNew = [0:1:100];
                if ~isempty(fSync)  % If I have at least a sync event, the phases are 2
                    % Phase 1
                    f1 = fStart(i)*f(k);
                    f2 = fSync(i,1)*f(k);
                    xOld = [0:100/(f2-f1):100];
                    dataToUse = data.(toCutAndNorm{k}).(fn{j})(f1:f2,:);
                    cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Cut']).Phase1.(fn{j}) = dataToUse;
                    if size(dataToUse,2) ~= 1
                        cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Norm']).Phase1.(fn{j}) = interp1(xOld,dataToUse,xNew);
                    else
                        cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Norm']).Phase1.(fn{j}) = interp1(xOld,dataToUse,xNew)';
                    end
                    % Phase 2 to N-1
                    for ev = 1 : size(fSync,2)-1
                        f1 = fSync(i,ev)*f(k);
                        f2 = fSync(i,ev+1)*f(k);
                        xOld = [0:100/(f2-f1):100];
                        dataToUse = data.(toCutAndNorm{k}).(fn{j})(f1:f2,:);
                        cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Cut']).(['Phase',num2str(ev+1)]).(fn{j}) = dataToUse;
                        if size(dataToUse,2) ~= 1
                            cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Norm']).(['Phase',num2str(ev+1)]).(fn{j}) = interp1(xOld,dataToUse,xNew);
                        else
                            cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Norm']).(['Phase',num2str(ev+1)]).(fn{j}) = interp1(xOld,dataToUse,xNew)';
                        end
                    end
                    % Phase N
                    f1 = fSync(i,end)*f(k);
                    f2 = fStop(i)*f(k);
                    xOld = [0:100/(f2-f1):100];
                    dataToUse = data.(toCutAndNorm{k}).(fn{j})(f1:f2,:);
                    cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Cut']).(['Phase',num2str(size(fSync,2)+1)]).(fn{j}) = dataToUse;
                    if size(dataToUse,2) ~= 1
                        cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Norm']).(['Phase',num2str(size(fSync,2)+1)]).(fn{j}) = interp1(xOld,dataToUse,xNew);
                    else
                        cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Norm']).(['Phase',num2str(size(fSync,2)+1)]).(fn{j}) = interp1(xOld,dataToUse,xNew)';
                    end
                end
                % Overall cycle
                f1 = fStart(i)*f(k);
                f2 = fStop(i)*f(k);
                xOld = [0:100/(f2-f1):100];
                dataToUse = data.(toCutAndNorm{k}).(fn{j})(f1:f2,:);
                cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Cut']).EntireCycle.(fn{j}) = dataToUse;
                cycles.(foundSides{s})(i).data.([toCutAndNorm{k},'Norm']).EntireCycle.(fn{j}) = interp1(xOld,dataToUse,xNew);
            end
        end
        % stParam creation
        cycles.(foundSides{s})(i).data.stParam = stParamCell{i};
        cycles.(foundSides{s})(i).data.stParam.events.evSyncTimePerc = evConfig.evSyncTimePerc;
        cycles.(foundSides{s})(i).data.stParam.events.evSyncPlotName = evConfig.evSyncPlotName;
        cycles.(foundSides{s})(i).data.stParam.events.evStartPlotName = evConfig.evStartPlotName;
        cycles.(foundSides{s})(i).data.stParam.events.evStopPlotName = evConfig.evStopPlotName;
        % Creation of other info
        cycles.(foundSides{s})(i).name = ['Cycle', num2str(i)];
        cycles.(foundSides{s})(i).context = foundSides{s};
        if strcmp(foundSides{s},'Merged')
            cycles.(foundSides{s})(i).movingSide = sideForMerge;
        else
            key = findCellInTable(contexts,foundSides{s},1);
            cycles.(foundSides{s})(i).movingSide = contexts{key(1),2};
        end
    end
    
end % end of cycles on foundSides 

end % end of function

%% Subfunctions 

function found = isFoundStr(str,pattern)
    
    res = strfind(str,pattern);
    if isempty(res)
        found = 0;
    else
        found = 1;
    end
    
end


function side = sideName(RorL)
    
    switch RorL
        case 'R'
            side = 'Right';
        case 'L'
            side = 'Left';
    end
    
end







