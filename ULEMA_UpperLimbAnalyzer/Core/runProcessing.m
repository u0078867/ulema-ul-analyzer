%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function trToUseDBNew = runProcessing(enginesInfo, engineIndex, lastUsedDir, recoveryPath, savePath, protDB, sectionsToComp, evConfig, trToUseDB, trDB, export, ageMatch, refFileData, forceDataOverwriting, splitProcDataLevels, procDataSaving)

% Along with this function, some new BM functions had to be created, to
% automatize the GUI. Their name is the same as the original name, but with
% the string '_AUTO' appended). 
% These new functions are included in the same forlder of the 
% 'runProcessing' function.

fprintf('\n\n-------------PROCESSING STARTED---------------\n\n');

% Calculating some parameters for waitbars
[nSub, nSes, nTr] = getTotalSubSesTr(trToUseDB);

% Initialize a flag indicating
someProcDoneBefore = 0;

% Initialize trToUseDBNew, the one containg the new paths
trToUseDBNew = trToUseDB;

% Get further information about all the possible fields for protocols
protOptsDescr = ProtOptsDescr();

if sectionsToComp.rawDataRead
    try                               
        %% RAW DATA READING
        %b = a;
        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        tic
        cb = 0;
        fprintf('\n\nRAW DATA READING: \n\n');
        h = waitbar2(0,'');
        for i = 1 : length(trToUseDB.subjects)  % cycle for every subject
            sub = trToUseDB.subjects(i).name;
            subject = loadStructData(trToUseDB, sub);
            fprintf('\n Su:Processing subject %s ...', trToUseDB.subjects(i).name);
            for j = 1 : length(trToUseDB.subjects(i).sessions) % cycle for every session
                fprintf('\n   Se: Processing session %s ...', trToUseDB.subjects(i).sessions(j).name);
                % Session: create BODY structure
                BodyMechFuncHeader
                InitBodyMech
                fprintf('\n   Se: Initialization done ...');
                for k = 1 : length(trToUseDB.subjects(i).sessions(j).trials) % cycle for every trial
                    waitbarText = [fullfile(trToUseDB.subjects(i).name, trToUseDB.subjects(i).sessions(j).name, strrep(trToUseDB.subjects(i).sessions(j).trials(k).name,'.c3d','')), '...'];
                    cb = cb + 1; 
                    xb = cb / nTr;
                    waitbar2(xb, h, waitbarText);
                    fprintf('\n     Tr: Processing trial %s ...', trToUseDB.subjects(i).sessions(j).trials(k).name);
                    % Trial: pick up the right protocol ID for the trial
                    protInfo = trToUseDB.subjects(i).sessions(j).trials(k).protocolData;
                    fprintf('\n     Tr: Protocol %s loaded ...', protInfo.protName);
                    % Trial: load body model file (markers, clusters, anatomical landmarks, joints definition)
                    eval(protInfo.bodyModel);
                    fprintf('\n     Tr: Body model %s loaded ...', protInfo.bodyModel);
                    % Trial: read necessary data
                    tr = trToUseDB.subjects(i).sessions(j).trials(k).name;
                    datafile = tr;
                    neverProc = ~isfield(subject.sessions(j).trials(k),'data') || isempty(subject.sessions(j).trials(k).data);
                    toProc = neverProc || forceDataOverwriting;
                    if toProc
                        % Read marker data
                        if neverProc
                            [structPath,dummy1,dummy2] = fileparts(subject.sessions(j).trials(k).subPath);
                            datapath = recoverPath(structPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                        elseif forceDataOverwriting
                            datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                        end
                        [dummy, ParameterGroup] = BMimportULC3D_3_AUTO(datafile,datapath);
                        AssignMarkerDataToBody;
                        subject.sessions(j).trials(k).data.points = AggregateAllPoints(struct(),'TechnicalMarkers');
                        fprintf('\n     Tr: Markers data loaded ...');
                        % Read event data
                        eventSide = getparam(ParameterGroup, 'EVENT', 'CONTEXTS');
                        eventType = getShortEventName(getparam(ParameterGroup, 'EVENT', 'LABELS'));
                        eventTime = getparam(ParameterGroup, 'EVENT', 'TIMES');
                        if ~isempty(eventTime)
                            eventTime = eventTime(2,:);
                        else
                            eventTime = {};
                        end
                        kineFreq = getparam(ParameterGroup, 'POINT', 'RATE');
                        startFrame = getparam(ParameterGroup, 'TRIAL', 'ACTUAL_START_FIELD');
                        subject.sessions(j).trials(k).data.stParam.eventsRaw.eventSide = eventSide;
                        subject.sessions(j).trials(k).data.stParam.eventsRaw.eventType = eventType;
                        subject.sessions(j).trials(k).data.stParam.eventsRaw.eventTime = eventTime - (startFrame(1) - 1) / kineFreq;
                        fprintf('\n     Tr: Events data loaded ...');
                        % Read acuisition frequecy from file
                        kineFreq = getparam(ParameterGroup, 'POINT', 'RATE');
                        subject.sessions(j).trials(k).data.kineFreq = kineFreq;
                        fprintf('\n     Tr: Markers acquisition frequency loaded ...');
                        fprintf('\n     Tr: Necessary data for dynamic file %s loaded ...', datafile);
                    else
                        fprintf('\n     Tr: Necessary data for dynamic file already %s loaded ...', datafile);
                    end
                end % end trials cycle
            end % end session cycle
            saveStructData(subject, trToUseDB, trDB, savePath, splitProcDataLevels, procDataSaving);
        end % end subject cycle
        trToUseDBNew = updatePath(trToUseDB,savePath,splitProcDataLevels);
        fprintf('\n\n\nTime elaplsed: %s\n\n\n', secs2hms(toc));
        someProcDoneBefore = 1;
        close(h);
    catch e
        errorHandler(e);
        return
    end
end

if sectionsToComp.kine
    try
        
        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        
        % Get specific info from the engine
        p.markerNamesMap = eExecEngIFunc(enginesInfo, engineIndex, 'IGetMarkerNamesMap');
        p.segmentNamesMap = eExecEngIFunc(enginesInfo, engineIndex, 'IGetSegmentNamesMap');
        p.jointNamesMap = eExecEngIFunc(enginesInfo, engineIndex, 'IGetJointNamesMap');
        p.angleNamesMap = eExecEngIFunc(enginesInfo, engineIndex, 'IGetAngleNamesMap');
        p.angleCorrections = eExecEngIFunc(enginesInfo, engineIndex, 'IGetAngleCorrections');

        % Calculate kinematics
        engineInfo = enginesInfo(engineIndex);
        res = eExecEngIFunc(enginesInfo,  engineIndex, 'IProcKine', ...
                                    engineInfo,...              % general
                                    p,...                       % parameters for current engine           
                                    protDB,...                  % general
                                    lastUsedDir,...             % general
                                    recoveryPath,...            % general
                                    savePath,...                % general
                                    nSub,...                    % general
                                    nSes,...                    % general
                                    nTr,...                     % general
                                    trToUseDB,...               % general
                                    trDB,...                    % general
                                    forceDataOverwriting,...    % general
                                    splitProcDataLevels,...     % general
                                    procDataSaving...           % general
                                    );              
                                

        trToUseDBNew = updatePath(trToUseDB,savePath,splitProcDataLevels);
        someProcDoneBefore = 1;
    catch e
        errorHandler(e);
        return
    end
end


if sectionsToComp.seg
    
    try
        %% SEGMENTATION
        %b = a;
        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        tic
        cb = 0;
        fprintf('\n\nSEGMENTATION: \n\n');
        h = waitbar2(0,'');
        for i = 1 : length(trToUseDB.subjects)  % cycle for every subject
            sub = trToUseDB.subjects(i).name;
            subject = loadStructData(trToUseDB, sub);
            fprintf('\n Su:Processing subject %s ...', trToUseDB.subjects(i).name);
            for j = 1 : length(trToUseDB.subjects(i).sessions) % cycle for every session
                fprintf('\n   Se: Processing session %s ...', trToUseDB.subjects(i).sessions(j).name);
                for k = 1 : length(trToUseDB.subjects(i).sessions(j).trials) % cycle for every trial
                    waitbarText = [fullfile(trToUseDB.subjects(i).name, trToUseDB.subjects(i).sessions(j).name, strrep(trToUseDB.subjects(i).sessions(j).trials(k).name,'.c3d','')), '...'];
                    cb = cb + 1; 
                    xb = cb / nTr;
                    waitbar2(xb, h, waitbarText);
                    ses = trToUseDB.subjects(i).sessions(j).name;
                    tr = trToUseDB.subjects(i).sessions(j).trials(k).name;
                    neverProc = ~isfield(subject.sessions(j).trials(k),'cycles') || isempty(subject.sessions(j).trials(k).cycles);
                    toProc = forceDataOverwriting || ...
                        neverProc || ...
                        compareProtocols(subject.sessions(j).trials(k).protocolData, trToUseDB.subjects(i).sessions(j).trials(k).protocolData, protOptsDescr, {'seg'}, {}) == 0 || ...
                        someProcDoneBefore;
                    fprintf('\n     Tr: Processing trial %s ...', trToUseDB.subjects(i).sessions(j).trials(k).name);
                    if toProc
                        protInfo = trToUseDB.subjects(i).sessions(j).trials(k).protocolData;
                        % Trial: Segmentation
                        contexts = cleanTableFromEmptyLines(protInfo.contexts);
                        subject.sessions(j).trials(k).contextSideTable = contexts;
                        im = findc(contexts(:,1),'Merged');
                        if ~isempty(im)
                            sideForMerge = contexts{im,2};
                            contexts{im,:} = [];
                            mergeContexts = 1;
                        else
                            sideForMerge = '';
                            mergeContexts = 0;
                        end
                        subject.sessions(j).trials(k).cycles = ...
                            startSegmentation(subject.sessions(j).trials(k).data, ...
                            evConfig{protInfo.segMethod},...
                            0,...
                            mergeContexts,...
                            contexts,...
                            sideForMerge,...
                            subject.sessions(j).trials(k).data.kineFreq,...
                            {'angles', 'points'},...
                            [1 1]);
                        % Trial: Spatio-temporal parameters
                        subject.sessions(j).trials(k).cycles = ...
                            calcSTParams(subject.sessions(j).trials(k).cycles,...
                            protInfo.stParPoints,...
                            subject.sessions(j).trials(k).data.kineFreq,...
                            protInfo.anglesMinMaxEv,...
                            protInfo.timing,...
                            protInfo.speed,...
                            protInfo.trajectory,...
                            protInfo.jerk...
                        );
                    else
                        fprintf('\n     Tr: Trial %s already processed...', trToUseDB.subjects(i).sessions(j).trials(k).name);
                    end
                end % end trials cycle
            end % end session cycle
            saveStructData(subject, trToUseDB, trDB, savePath, splitProcDataLevels, procDataSaving);
        end % end subject cycle
        trToUseDBNew = updatePath(trToUseDB,savePath,splitProcDataLevels);
        fprintf('\n\n\nTime elaplsed: %s\n\n\n', secs2hms(toc));
        someProcDoneBefore = 1;
        close(h);
    catch e
        errorHandler(e);
        return
    end
end


if sectionsToComp.bestCy
    
    try
        %% BEST CYCLES SELECTION

        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        tic
        cb = 0;
        h = waitbar2(0,'');
        fprintf('\n\nBEST CYCLES SELECTION: \n\n');
        for i = 1 : length(trToUseDB.subjects)  % cycle for every subject
            sub = trToUseDB.subjects(i).name;
            subject = loadStructData(trToUseDB, sub);
            fprintf('\n Su:Processing subject %s ...', trToUseDB.subjects(i).name);
            for j = 1 : length(trToUseDB.subjects(i).sessions) % cycle for every session
                fprintf('\n   Se: Processing session %s ...', trToUseDB.subjects(i).sessions(j).name);
                bestCyclesN = trToUseDB.subjects(i).sessions(j).trials(1).protocolData.bestCyclesN; % here, I can select the protocolData for any trial
                [taskPrefixList, anglesList] = mergeTaskPrefixLists(trToUseDB.subjects(i).sessions(j).trials);
                for k = 1 : size(taskPrefixList,1)
                    taskPrefix = taskPrefixList{k,1};
                    context = taskPrefixList{k,2};
                    phase = taskPrefixList{k,3};
                    trIndToSearchPrefix = taskPrefixList{k,4};
                    waitbarText = [fullfile(trToUseDB.subjects(i).name, trToUseDB.subjects(i).sessions(j).name), ': ', taskPrefix, '...'];
                    cb = cb + 1; 
                    xb = cb / (nSes * size(taskPrefixList,1));
                    waitbar2(xb, h, waitbarText);
                    neverProc = ~isfield(subject.sessions(j), 'bestCycles') || ~isfield(subject.sessions(j).bestCycles,taskPrefix) || ...
                                                                               ~isfield(subject.sessions(j).bestCycles.(taskPrefix),context) || ...
                                                                               ~isfield(subject.sessions(j).bestCycles.(taskPrefix).(context),phase);
                    toProc = forceDataOverwriting || ...
                        neverProc || ...
                        someProcDoneBefore;
                    if toProc
                        % Session: selecting trials with the same prefix (task prefix)
                        trialsInd = getSubstructIndices(subject.sessions(j).trials(trIndToSearchPrefix), taskPrefix, trIndToSearchPrefix);
                        if ~isempty(trialsInd)
                            % Session: select the best cycles
                            [subject.sessions(j).bestCycles.(taskPrefix).(context).(phase), bestCyclesN] = ...
                                getBestCycles(subject.sessions(j).trials(trialsInd),...
                                context,...
                                phase,...
                                anglesList{k},...
                                bestCyclesN);
                            fprintf('\n   Se: %d best cycles for task %s (context: %s, phase: %s) found ...', bestCyclesN, taskPrefix, context, phase);
                        else
                            fprintf('\n   Se: Trials relative to task %s were not found ...', taskPrefix);
                        end
                    else
                        fprintf('\n   Se: %d best cycles for task %s (context: %s, phase: %s) already found ...', bestCyclesN, taskPrefix, context, phase);
                    end
                end % end task prefix cycle
            end % end sessions cycle
            saveStructData(subject, trToUseDB, trDB, savePath, splitProcDataLevels, procDataSaving);
        end % end subjects cycle
        trToUseDBNew = updatePath(trToUseDB,savePath,splitProcDataLevels);
        fprintf('\n\n\nTime elaplsed: %s\n\n\n', secs2hms(toc));
        someProcDoneBefore = 1;
        close(h);
    catch e
        errorHandler(e);
        return
    end
end

if sectionsToComp.cliPars
    
    try
        %% SCORES AND INDEXES CALCULATION

        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        tic
        cb = 0;
        h = waitbar2(0,'');
        fprintf('\n\nSCORES AND INDEXES CALCULATION: \n\n');
        for i = 1 : length(trToUseDB.subjects)  % cycle for every subject 
            sub = trToUseDB.subjects(i).name;
            subject = loadStructData(trToUseDB, sub);
            fprintf('\n Su:Processing subject %s ...', trToUseDB.subjects(i).name);
            % Getting the name of the reference subject
            r = findCellInTable(ageMatch, trToUseDB.subjects(i).name, 1);
            for j = 1 : length(trToUseDB.subjects(i).sessions) % cycle for every session
                fprintf('\n   Se: Processing session %s ...', trToUseDB.subjects(i).sessions(j).name);
                protInfo = trToUseDB.subjects(i).sessions(j).trials(1).protocolData;
                taskPrefixList = fieldnames(subject.sessions(j).bestCycles);
                ses = trToUseDB.subjects(i).sessions(j).name;
                for k = 1 : length(taskPrefixList) % cycle for every task
                    waitbarText = [fullfile(trToUseDB.subjects(i).name, trToUseDB.subjects(i).sessions(j).name), ': ', taskPrefixList{k}, '...'];
                    cb = cb + 1; 
                    xb = cb / (nSes * length(taskPrefixList));
                    waitbar2(xb, h, waitbarText);
                    % Looking fo available contexts
                    contexts = fieldnames(subject.sessions(j).bestCycles.(taskPrefixList{k}));
                    for c = 1 : length(contexts) % cycle for every context
                        % Looking for available phases
                        phases = fieldnames(subject.sessions(j).bestCycles.(taskPrefixList{k}).(contexts{c}));
                        for p = 1 : length(phases) % cycle for every time phase
                            neverProc = ~isfield(subject.sessions(j).bestCycles.(taskPrefixList{k}).(contexts{c}).(phases{p}).formattedData, 'MAPTable' );
                            toProc = forceDataOverwriting || ...
                                neverProc || ...
                                compareProtocols(subject.sessions(j).trials(k).protocolData, trToUseDB.subjects(i).sessions(j).trials(k).protocolData, protOptsDescr, {'cliPars'}, {}) == 0 || ...
                                someProcDoneBefore;
                            if toProc
                                % Use only the angles used for best cycles selection
                                anglesList = subject.sessions(j).bestCycles.(taskPrefixList{k}).(contexts{c}).(phases{p}).cycles(1).anglesForSelection;
                                % Selecting data for the matched reference subject
                                refDataFormat = refDataFormatRecognizer(refFileData);
                                if ~isempty(r)
                                    refDataSub = ageMatch{r(1),2};
                                    [refDataStruct, existingAnglesList, errMsg] = getRefDataForTask(refFileData, refDataFormat, refDataSub, taskPrefixList{k}, contexts{c}, phases{p}, anglesList);
                                    if isempty(refDataStruct)   % Error picking the correct reference data
                                        fprintf(errMsg);
                                        continue;
                                    end
                                    % Calculating scores
                                    subject.sessions(j).bestCycles.(taskPrefixList{k}).(contexts{c}).(phases{p}) = ...
                                        getScores(...
                                            subject.sessions(j).bestCycles.(taskPrefixList{k}).(contexts{c}).(phases{p}),...
                                            refDataStruct,...
                                            existingAnglesList,...
                                            protInfo.logTransVS,...
                                            'AVS',...
                                            'APS');
                                    fprintf('\n   Se: Scores saved for subject %s, session %s, task %s, context %s, %s ...', ...
                                        trToUseDB.subjects(i).name,...
                                        trToUseDB.subjects(i).sessions(j).name,...
                                        taskPrefixList{k},...
                                        contexts{c},...
                                        phases{p});
                                else
                                    fprintf('\n   Se: No association found for subject %s (session %s, task %s, context %s, %s) ...', ...
                                        trToUseDB.subjects(i).name,...
                                        trToUseDB.subjects(i).sessions(j).name,...
                                        taskPrefixList{k},...
                                        contexts{c},...
                                        phases{p});
                                end
                            else
                            fprintf('\n   Se: Scores already processed for subject %s, session %s, task %s, context %s, %s ...', ...
                                trToUseDB.subjects(i).name,...
                                trToUseDB.subjects(i).sessions(j).name,...
                                taskPrefixList{k},...
                                contexts{c},...
                                phases{p});
                            end
                        end
                    end
                end % end task prefix cycle
            end % end sessions cycle
            saveStructData(subject, trToUseDB, trDB, savePath, splitProcDataLevels, procDataSaving);
        end % end subjects cycle
        trToUseDBNew = updatePath(trToUseDB,savePath,splitProcDataLevels);
        fprintf('\n\n\nTime elaplsed: %s', secs2hms(toc));
        someProcDoneBefore = 1;
        close(h);
    catch e
        errorHandler(e);
        return
    end
end

if sectionsToComp.expC3D
    try
        %% SAVING DATA BACK TO C3D

        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        tic
        cb = 0;
        h = waitbar2(0,'');
        fprintf('\n\nSAVING DATA BACK TO C3D: \n\n');
        for i = 1 : length(trToUseDB.subjects)  % cycle for every subject 
            sub = trToUseDB.subjects(i).name;
            subject = loadStructData(trToUseDB, sub);
            fprintf('\n Su:Processing subject %s ...', trToUseDB.subjects(i).name);
            for j = 1 : length(trToUseDB.subjects(i).sessions) % cycle for every session
                fprintf('\n   Se: Processing session %s ...', trToUseDB.subjects(i).sessions(j).name);
                for k = 1 : length(trToUseDB.subjects(i).sessions(j).trials) % cycle for every trial
                    waitbarText = [fullfile(trToUseDB.subjects(i).name, trToUseDB.subjects(i).sessions(j).name, strrep(trToUseDB.subjects(i).sessions(j).trials(k).name,'.c3d','')), '...'];
                    cb = cb + 1; 
                    xb = cb / nTr;
                    waitbar2(xb, h, waitbarText);
                    fprintf('\n     Tr: Processing trial %s ...', trToUseDB.subjects(i).sessions(j).trials(k).name);
                    ses = trToUseDB.subjects(i).sessions(j).name;
                    tr = trToUseDB.subjects(i).sessions(j).trials(k).name;
                    % Trial: save processed data to C3D
                    sub = trToUseDB.subjects(i).name;
                    ses = trToUseDB.subjects(i).sessions(j).name;
                    tr = trToUseDB.subjects(i).sessions(j).trials(k).name;
                    inpath = recoverPath(recoveryPath, 'c3d', 'tree', 'trial', sub, ses, tr);
                    if isempty(inpath)
                        error('Impossible to recover the path of trial c3d file!');
                    end
                    if export.C3D.saveToNewC3D == 0
                        outpath = inpath;
                    else
                        if k == 1
                            c3dNewDir = fullfile(recoverPath(recoveryPath, 'c3d', 'tree', 'session', sub, ses, []), 'ProcC3D');
                            if exist(c3dNewDir,'dir')
                                while 1
                                    try
                                        rmdir(c3dNewDir,'s');
                                        break;
                                    catch e
                                        errMsg = ['Impossible to remove folder ', c3dNewDir, '! Close all the other applications that might use it and then press "Ok"'];
                                        msgbox(errMsg, 'Folder removing error');
                                    end
                                end
                            end
                            mkdir(c3dNewDir);
                        end
                        outpath = fullfile(c3dNewDir,tr);
                        % copy other useful files in the processed c3d folder (e.g. vsk, vst, mkr,...)
                        % TO DO
                    end
                    saveProcDataToC3D(subject.sessions(j).trials(k), inpath, outpath);
                    fprintf('\n     Tr: Data back-written to C3D for trial %s ...', trToUseDB.subjects(i).sessions(j).trials(k).name);
                end % end trials cycle
            end % end session cycle
        end % end subjects cycle
        trToUseDBNew = trToUseDB;
        fprintf('\n\n\nTime elaplsed: %s', secs2hms(toc));
        someProcDoneBefore = 1;
        close(h);
    catch e
        errorHandler(e);
        return
    end
end

if sectionsToComp.refData
    
    try
        %% CREATING MAT REFERENCE DB
        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        tic
        fprintf('\n\nCREATING MAT REFERENCE DB: \n\n');
        % Creating the file
        MATfilePath = fullfile(export.RefData.refDataPath, [export.RefData.outRefFile, '.mat']);
        CSVfilePath = fullfile(export.RefData.refDataPath, [export.RefData.outRefFile, '.csv']);
        createReferenceFile(MATfilePath,CSVfilePath,'UZP_1.1',trToUseDB,export.RefData.sidesForRefData,export.General.cacheSubData);
        trToUseDBNew = trToUseDB;
        someProcDoneBefore = 1;
        fprintf('\n\n\nTime elaplsed: %s', secs2hms(toc));
    catch e
        errorHandler(e);
        return
    end

end

if sectionsToComp.expCSV
    
    try
        %% CREATING CSV FILES
        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        tic
        fprintf('\n\nCREATING CSV FILES: \n\n');
        % Creating csv files
        createCSVFiles(export.CSV.CSVPath, export.CSV.saveTrCSV, export.CSV.saveSesCSV, export.CSV.expMovSideDataOnly, export.General.cacheSubData, trToUseDB, nTr, nSes);
        trToUseDBNew = trToUseDB;
        fprintf('\n\n\nTime elaplsed: %s', secs2hms(toc));
    catch e
        errorHandler(e);
        return
    end
    
end

if sectionsToComp.expXML
    
    try
        %% CREATING XML FILES
        %--- To ensure that in this processing sections I use the updated paths
        if someProcDoneBefore
            trToUseDB = trToUseDBNew;
        end
        %---
        tic
        fprintf('\n\nCREATING XML FILES: \n\n');
        % Creating xml files
        createXMLFiles(export.XML.XMLPath, export.XML.saveBestCyXML, trToUseDB, nTr, nSes);
        trToUseDBNew = trToUseDB;
        fprintf('\n\n\nTime elaplsed: %s', secs2hms(toc));
    catch e
        errorHandler(e);
        return
    end
    
end

if sectionsToComp.expXMLRefData
    
    try
        %% CREATING XML FILE FOR REFERENCE DATA
        tic
        fprintf('\n\nCREATING XML FILE FOR REFERENCE DATA: \n\n');
        % Creating xml file
        createXMLRefDataFile(export.XMLRefData.inFileFolder, export.XMLRefData.inFileName, export.XMLRefData.outFileFolder, export.XMLRefData.outFileName, export.XMLRefData.keepOnlyMeanStd);
        fprintf('\n\n\nTime elaplsed: %s', secs2hms(toc));
    catch e
        errorHandler(e);
        return
    end
    
end
