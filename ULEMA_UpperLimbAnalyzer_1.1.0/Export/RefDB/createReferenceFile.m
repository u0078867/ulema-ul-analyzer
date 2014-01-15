%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function createReferenceFile(MATfilePath, CSVfilePath, refDataFormat, trToUseDB, refFileType, cacheSubData)

switch refFileType
    case 1 % only right side
        sides = {'Right'};
        prefixesToKeep = {'R'};
    case 2 % only left side
        sides = {'Left'};
        prefixesToKeep = {'L'};
    case {3,4} % bilateral, mix right and left sides
        sides = {'Right', 'Left'};
        prefixesToKeep = {'R', 'L'};
end

% Getting task prefixes, phases, angles
taskPrefixes = {};
contexts = {};
phases = {};
angles = {};
cachedSubs = cell(length(trToUseDB.subjects),1);
h = waitbar2(0,'');
for i = 1 : length(trToUseDB.subjects)  % cycle for every subject
    sub = trToUseDB.subjects(i).name;
    subject = loadStructData(trToUseDB, sub);
    if cacheSubData
        cachedSubs{i} = subject;
    end
    %waitbarText = ['Reading data for subject ', trToUseDB.subjects(i).name, '...'];
    waitbarText = ['Collecting task prefixes, contexts, phases and angle names...'];
    waitbar2(i / length(trToUseDB.subjects), h, waitbarText);
    for j = 1 : length(trToUseDB.subjects(i).sessions) % cycle for every session
        newTaskPrefixes = fieldnames(subject.sessions(j).bestCycles);
        taskPrefixes = [taskPrefixes, newTaskPrefixes];
        for t = 1 : length(newTaskPrefixes) % cycle for every task prefix
            newContexts = fieldnames(subject.sessions(j).bestCycles.(newTaskPrefixes{t}));
            contexts = [contexts, newContexts];
            for co = 1 : length(newContexts) % cycle for every context
                newPhases = fieldnames(subject.sessions(j).bestCycles.(newTaskPrefixes{t}).(newContexts{co}));
                phases = [phases, newPhases];
                for p = 1 : length(newPhases)   % cycle for every phases
                    ncy = length(subject.sessions(j).bestCycles.(newTaskPrefixes{t}).(newContexts{co}).(newPhases{p}).cycles);
                    for cy = 1 : ncy    % cycle for every motion cycle
                        newAngles = fieldnames(subject.sessions(j).bestCycles.(newTaskPrefixes{t}).(newContexts{co}).(newPhases{p}).cycles(cy).data.anglesNorm);
                        for a = 1 : length(newAngles)
                            for pr = 1 : length(prefixesToKeep)
                                if strcmp(newAngles{a}(1:length(prefixesToKeep{pr})),prefixesToKeep{pr})
                                    angles = [angles, newAngles{a}];
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    clear subject
end
close(h);
taskPrefixes = unique(taskPrefixes);
contexts = unique(contexts);
phases = unique(phases);
angles = unique(angles);

% Now the variables contain:
% - taskPrefixes: the list of all the task found among subjects
% - contexts: the list of all contexts found among subjects
% - phases: the list of all phases found among subjects
% - angles: the list of the only angles to keep (R*, L* or both)

% From here on, if subject cached data was produced, it will be used. 

% Grouping all the info from current DB
h = waitbar2(0,'');
for t = 1 : length(taskPrefixes) % cycle for every task
    waitbarText = ['Grouping data for task ', taskPrefixes{t}, '...'];
    waitbar2(t / length(taskPrefixes), h, waitbarText);
    for p = 1 : length(phases) % cycle for every phase
        countCy = 0;
        for i = 1 : length(trToUseDB.subjects) % cycle for every subject
            sub = trToUseDB.subjects(i).name;
            if cacheSubData
                subject = cachedSubs{i};
            else
                subject = loadStructData(trToUseDB, sub);
            end
            for j = 1 : length(trToUseDB.subjects(i).sessions)  % cycle for every session
                if isfield(subject.sessions(j).bestCycles, taskPrefixes{t}) 
                    for co = 1 : length(contexts) % cycle for every context
                        if isfield(subject.sessions(j).bestCycles.(taskPrefixes{t}), contexts{co}) && ...
                           isfield(subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}), phases{p})   
                            for cy = 1 : length(subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles) % cycle for every movement cycle
                                if ~isempty(findc(sides,subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).movingSide))
                                    countCy = countCy + 1;
                                    % Add angles
                                    for a = 1 : length(angles) % cycle for every angle
                                        if isfield(subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).data.anglesNorm, angles{a}) && ...
                                           subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).movingSide(1) == angles{a}(1)
                                            [rN,cN] = size(subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).data.anglesNorm.(angles{a}));                   
                                            if rN > cN
                                                subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).data.anglesNorm.(angles{a}) = subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).data.anglesNorm.(angles{a})';
                                            end
                                            RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.rawData.(['Cycle', num2str(countCy)]).(angles{a}) = ...
                                                subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).data.anglesNorm.(angles{a});                   
                                        end 
                                    end
                                    % Add spatio-temporal parameters
                                    RefData.tasks.(taskPrefixes{t}).(phases{p}).stParam.rawData.(['Cycle', num2str(countCy)]) = ...
                                                subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).data.stParam;
                                    % Add source names
                                    RefData.tasks.(taskPrefixes{t}).(phases{p}).sources.(['Cycle', num2str(countCy)]).subject = subject.name;
                                    RefData.tasks.(taskPrefixes{t}).(phases{p}).sources.(['Cycle', num2str(countCy)]).session = subject.sessions(j).name;
                                    RefData.tasks.(taskPrefixes{t}).(phases{p}).sources.(['Cycle', num2str(countCy)]).trial = ...
                                        subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).trial;
                                    RefData.tasks.(taskPrefixes{t}).(phases{p}).sources.(['Cycle', num2str(countCy)]).cycle = ...
                                        subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).name;
                                    RefData.tasks.(taskPrefixes{t}).(phases{p}).sources.(['Cycle', num2str(countCy)]).movingSide = ...
                                        subject.sessions(j).bestCycles.(taskPrefixes{t}).(contexts{co}).(phases{p}).cycles(cy).movingSide;
                                end
                            end
                        end
                    end
                end
            end
            clear subject
        end
    end
end
close(h)

% Only if I want to mix right and left side
postfixesToKeep = {};
if refFileType == 4
    fprintf('\n\nMixing right and left...\n\n');
    for a = 1 : length(angles)
        prInd = [];
        for pr = 1 : length(prefixesToKeep)
            ind = strfind(angles{a}, prefixesToKeep{pr});
            if ~isempty(ind) && ind(1) == 1
                prInd = pr;
            end
        end
        if ~isempty(prInd)
            % postfixesToKeep{end+1} = strrep(angles{a},prefixesToKeep{prInd},'');
            postfixesToKeep{end+1} = angles{a}(length(prefixesToKeep{prInd})+1:end);
        end
    end
    postfixesToKeep = unique(postfixesToKeep);
else
    postfixesToKeep = angles;
end

% Calculating statistic parameters (mean, std.dev)
h = waitbar2(0,'');
taskPrefixes = fieldnames(RefData.tasks);
fid = fopen(CSVfilePath, 'w');
for t = 1 : length(taskPrefixes) % cycle for every task
    waitbarText = ['Calculating mean and std.dev. data for task ', taskPrefixes{t}, '...'];
    waitbar2(t / length(taskPrefixes), h, waitbarText);
    phases = fieldnames(RefData.tasks.(taskPrefixes{t}));
    for p = 1 : length(phases) % cycle for every phase
        cycles = fieldnames(RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.rawData);
        fprintf(fid, '\nTask: %s, %s:\n\n', taskPrefixes{t}, phases{p});
        for po = 1 : length(postfixesToKeep)  % cycle for every angle postfix
            angleMatrix = [];
            for c = 1 : length(cycles)  % cycle for every movement cycle
                angles = fieldnames(RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.rawData.(cycles{c}));
                anInd = fne(strfind(angles,postfixesToKeep{po})); 
                if ~isempty(anInd) && isfield(RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.rawData.(cycles{c}), angles{anInd})
                    fprintf('\nReading data from: %s, %s, %s, %s', taskPrefixes{t}, phases{p}, cycles{c}, postfixesToKeep{po});
                    angleMatrix = [angleMatrix; RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.rawData.(cycles{c}).(angles{anInd})];
                end 
            end
            RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.mean.(postfixesToKeep{po}) = mean(angleMatrix,1);
            RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.std.(postfixesToKeep{po}) = std(angleMatrix,0,1);
            % Write angle to CSV
            writeNumVector(fid, RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.mean.(postfixesToKeep{po}), [postfixesToKeep{po}, '(mean)'],0);
            writeNumVector(fid, RefData.tasks.(taskPrefixes{t}).(phases{p}).angles.std.(postfixesToKeep{po}), [postfixesToKeep{po}, '(std. dev.)'],0);
        end
    end
end
close(h);
fclose(fid);

% Inserting the data format
RefData.formatType = refDataFormat;

% Saving 
save(MATfilePath,'RefData');



%% Subfunctions

function ind = fne(list)
% returns the first non empty element of a cell-array. If all the cells are
% empty, it returns [].
ind = [];
for i = 1 : length(list)
    if ~isempty(list{i})
        ind = i;
        return
    end
end
    
    
    
    
    
