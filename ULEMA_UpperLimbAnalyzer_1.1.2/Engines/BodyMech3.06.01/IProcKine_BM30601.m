%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function res = IProcKine_BM30601( engineInfo,...        % general
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
                            procDataSaving)             % general
                                    

%% KINEMATICS:
res = [];
tic
cb = 0;
fprintf('\n\nKINEMATICS (Engine: %s): \n\n', engineInfo.name);
h = waitbar2(0,'');
for i = 1 : length(trToUseDB.subjects)  % cycle for every subject 
    sub = trToUseDB.subjects(i).name;
    fprintf('\n Su:Processing subject %s ...', trToUseDB.subjects(i).name);
    subject = loadStructData(trToUseDB, sub);   % this is overwritten every time, so the RAM is not stuck when I load a big number of subjects
    for j = 1 : length(trToUseDB.subjects(i).sessions) % cycle for every session
        ses = trToUseDB.subjects(i).sessions(j).name;
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
            beg = tic; 
            % Trial: pick up the right protocol ID for the trial
            protInfo = trToUseDB.subjects(i).sessions(j).trials(k).protocolData;
            fprintf('\n     Tr: Protocol %s loaded ...', protInfo.protName);
            % Trial: load body model file (markers, clusters, anatomical landmarks, joints definition)
            eval(protInfo.bodyModel);
            fprintf('\n     Tr: Body model %s loaded ...', protInfo.bodyModel);
            % Trial: load pointer definition file
            eval(protInfo.pointer);
            fprintf('\n     Tr: Pointer definition %s loaded ...', protInfo.pointer);
            % Trial: delete unused segments and joints
            DeleteUnusedSegments(protInfo.wantedJoints);
            fprintf('\n     Tr: Unused joints, segments and markers from body model deleted...');
            % Trial: processing static trial
            neverProc = ~isfield(subject.sessions(j).trials(k),'static') || isempty(subject.sessions(j).trials(k).static);
            sta = tic;
            if ~forceDataOverwriting
                if ~neverProc
                    if ~strcmp(protInfo.staticFile,subject.sessions(j).trials(k).protocolData.staticFile)
                        datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                        datafile = protInfo.staticFile;
                        [dummy,ParameterGroup,CollDate,CollTime] = BMimportULC3D_3_AUTO(datafile,datapath);
                        freq = getparam(ParameterGroup, 'TRIAL', 'CAMERA_RATE');
                        fprintf('\n     Tr: Static data for file %s loaded (from file) for clusters definition (recovery path used)...', datafile);
                    else
                        MARKER_DATA = getMarkersDataFromStruct(subject.sessions(j).trials(k).static.data.points,BODY.CONTEXT.MarkerLabels);
                        MARKER_TIME_OFFSET = 0.;
                        MARKER_TIME_GAIN = 1. / subject.sessions(j).trials(k).static.data.freq;
                        freq = subject.sessions(j).trials(k).static.data.freq;
                        datafile = protInfo.staticFile;
                        fprintf('\n     Tr: Static data for file %s for clusters definition internally recovered...', datafile);
                    end
                else
                    datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                    datafile = protInfo.staticFile;
                    [dummy,ParameterGroup,CollDate,CollTime] = BMimportULC3D_3_AUTO(datafile,datapath);
                    freq = getparam(ParameterGroup, 'TRIAL', 'CAMERA_RATE');  
                    fprintf('\n     Tr: Static data for file %s loaded (from file) for clusters definition...', datafile);
                end
            else
                datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                datafile = protInfo.staticFile;
                [dummy,ParameterGroup,CollDate,CollTime] = BMimportULC3D_3_AUTO(datafile,datapath);
                freq = getparam(ParameterGroup, 'TRIAL', 'CAMERA_RATE');
                fprintf('\n     Tr: Static data for file %s loaded (from file) for clusters definition (recovery path used)...', datafile);
            end
            subject.sessions(j).trials(k).static.name = datafile;
            subject.sessions(j).trials(k).static.data.freq = freq;
            AssignMarkerDataToBody;
            subject.sessions(j).trials(k).static.data.points = AggregateAllPoints(struct(),'TechnicalMarkers'); % Session: choose instant for all visible markers (clusters def)
            ClustersDefFrameIndex = DefineLocalClusterFrames_AUTO('automatic');
            subject.sessions(j).trials(k).static.usedFrames = ClustersDefFrameIndex;
            fprintf('\n     Tr: Static frame (%s) for cluster definition calculated ...', num2str(ClustersDefFrameIndex));
            % Trial: probe every anatomical landmark with the stick
            neverProc = ~isfield(subject.sessions(j).trials(k),'calib') || isempty(subject.sessions(j).trials(k).calib);
            sta = tic;
            if ~forceDataOverwriting
                if ~neverProc            
                    if (...
                        protInfo.useSepCalFiles ~= subject.sessions(j).trials(k).protocolData.useSepCalFiles || ...
                        (protInfo.useSepCalFiles == subject.sessions(j).trials(k).protocolData.useSepCalFiles && ~strcmp(protInfo.calPrefix,subject.sessions(j).trials(k).protocolData.calPrefix)) || ...
                        protInfo.useSingleCalFile ~= subject.sessions(j).trials(k).protocolData.useSingleCalFile || ...
                        (protInfo.useSingleCalFile == subject.sessions(j).trials(k).protocolData.useSingleCalFile && ~strcmp(protInfo.calFile,subject.sessions(j).trials(k).protocolData.calFile)) ...
                       )
                        datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                        calib = ProbeAnatomy_AUTO(datapath, protInfo.calPrefix, protInfo.calFile, protInfo.useSepCalFiles, protInfo.useSingleCalFile);
                        sto = toc(sta);
                        if protInfo.useSepCalFiles
                            fprintf('\n     Tr: Anatomy completely probed (separate calibration files) using recovery path (%s sec)...', num2str(sto));
                        elseif protInfo.useSingleCalFile
                            fprintf('\n     Tr: Anatomy completely probed (single calibration file) using recovery path (%s sec)...', num2str(sto));
                        end
                    else
                        if subject.sessions(j).trials(k).version > 1
                            fprintf('\n     Tr: Marker data for anatomy probing internally recovered...');
                            calibFilesData = subject.sessions(j).trials(k).calib;
                            calib = ProbeAnatomy_AUTO(calibFilesData, protInfo.calPrefix, protInfo.calFile, protInfo.useSepCalFiles, protInfo.useSingleCalFile);
                            sto = toc(sta);
                            if protInfo.useSepCalFiles
                                fprintf('\n     Tr: Anatomy completely probed (separate calibration files, %s sec)...', num2str(sto));
                            elseif protInfo.useSingleCalFile
                                fprintf('\n     Tr: Anatomy completely probed (single calibration file, %s sec)...', num2str(sto));
                            end
                        else
                            fprintf('\n     Tr: Warning: trial version = 1 => recovery path will be used for anatomy probing...');
                            datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                            calib = ProbeAnatomy_AUTO(datapath, protInfo.calPrefix, protInfo.calFile, protInfo.useSepCalFiles, protInfo.useSingleCalFile);
                            sto = toc(sta);
                            if protInfo.useSepCalFiles
                                fprintf('\n     Tr: Anatomy completely probed (separate calibration files) using recovery path (%s sec)...', num2str(sto));
                            elseif protInfo.useSingleCalFile
                                fprintf('\n     Tr: Anatomy completely probed (single calibration file) using recovery path (%s sec)...', num2str(sto));
                            end
                        end
                    end
                else
                    datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                    calib = ProbeAnatomy_AUTO(datapath, protInfo.calPrefix, protInfo.calFile, protInfo.useSepCalFiles, protInfo.useSingleCalFile);
                    sto = toc(sta);
                    if protInfo.useSepCalFiles
                        fprintf('\n     Tr: Anatomy completely probed (separate calibration files, %s sec)...', num2str(sto));
                    elseif protInfo.useSingleCalFile
                        fprintf('\n     Tr: Anatomy completely probed (single calibration file, %s sec)...', num2str(sto));
                    end
                end
            else
                datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                calib = ProbeAnatomy_AUTO(datapath, protInfo.calPrefix, protInfo.calFile, protInfo.useSepCalFiles, protInfo.useSingleCalFile);
                sto = toc(sta);
                if protInfo.useSepCalFiles
                    fprintf('\n     Tr: Anatomy completely probed (separate calibration files) using recovery path (%s sec)...', num2str(sto));
                elseif protInfo.useSingleCalFile
                    fprintf('\n     Tr: Anatomy completely probed (single calibration file) using recovery path (%s sec)...', num2str(sto));
                end
            end
            subject.sessions(j).trials(k).calib = calib;
            ClearKinematics('markers');
            % Trial: process staticRef trial
            if protInfo.absAngRefPos == 1
                sta = tic;
                neverProc = ~isfield(subject.sessions(j).trials(k),'staticRef') || isempty(subject.sessions(j).trials(k).staticRef);
                if ~forceDataOverwriting
                    if ~neverProc
                        if ~strcmp(protInfo.absAngRefPosFile,subject.sessions(j).trials(k).protocolData.absAngRefPosFile)
                            datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                            datafile = protInfo.absAngRefPosFile;
                            [dummy,ParameterGroup,CollDate,CollTime] = BMimportULC3D_3_AUTO(datafile,datapath);
                            freq = getparam(ParameterGroup, 'TRIAL', 'CAMERA_RATE');
                            fprintf('\n     Tr: Static data for file %s loaded (from file) for reference posture (recovery path used)...', datafile);
                        else
                            MARKER_DATA = getMarkersDataFromStruct(subject.sessions(j).trials(k).staticRef.data.points,BODY.CONTEXT.MarkerLabels);
                            MARKER_TIME_OFFSET = 0.;
                            MARKER_TIME_GAIN = 1. / subject.sessions(j).trials(k).staticRef.data.freq;
                            freq = subject.sessions(j).trials(k).staticRef.data.freq;
                            datafile = protInfo.absAngRefPosFile;
                            fprintf('\n     Tr: Static data for file %s for reference posture internally recovered...', datafile);
                        end
                    else
                        %[structPath,dummy1,dummy2] = fileparts(subject.sessions(j).trials(k).subPath);
                        datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                        datafile = protInfo.absAngRefPosFile;
                        [dummy,ParameterGroup,CollDate,CollTime] = BMimportULC3D_3_AUTO(datafile,datapath);
                        freq = getparam(ParameterGroup, 'TRIAL', 'CAMERA_RATE');  
                        fprintf('\n     Tr: Static data for file %s loaded (from file) for reference posture...', datafile);
                    end
                else
                    datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                    datafile = protInfo.absAngRefPosFile;
                    [dummy,ParameterGroup,CollDate,CollTime] = BMimportULC3D_3_AUTO(datafile,datapath);
                    freq = getparam(ParameterGroup, 'TRIAL', 'CAMERA_RATE');
                    fprintf('\n     Tr: Static data for file %s loaded (from file) for reference posture...', datafile);
                end
                subject.sessions(j).trials(k).staticRef.name = datafile;
                subject.sessions(j).trials(k).staticRef.data.freq = freq;
                AssignMarkerDataToBody;
                subject.sessions(j).trials(k).staticRef.data.points = AggregateAllPoints(struct(),'TechnicalMarkers'); % Session: choose instant for all visible markers (clusters def)
                PostureFrameIndex = RecordReferencePose_AUTO(1, 'automatic');
                subject.sessions(j).trials(k).staticRef.usedFrames = PostureFrameIndex;
                ClearKinematics('markers');
                sto = toc(sta);
                fprintf('\n     Tr: Static frame (%s) for reference posture calculated (%s sec) ...', num2str(PostureFrameIndex), num2str(sto));
            else
                subject.sessions(j).trials(k).staticRef = 'Not needed';
                fprintf('\n     Tr: No static frame data for reference posture needed ...');
            end
            % Trial: calculate dynamic joint centers (DJC)
            DJCList = cleanTableFromEmptyLines(protInfo.DJCList, 5);
            if ~isempty(DJCList)
                sta = tic;
                neverProc = ~isfield(subject.sessions(j).trials(k),'DJC') || isempty(subject.sessions(j).trials(k).DJC); 
                if ~forceDataOverwriting
                    if ~neverProc
                        [ok, dummy1, dummy2] = testDJCFilesList(subject.sessions(j).trials(k).protocolData, protInfo);
                        if ok == 0
                            datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                            DJC = CalculateFunctionalJointCenters(DJCList, datapath);
                            sto = toc(sta);
                            fprintf('\n     Tr: Functional joint centers calculated using recovery path (%s sec)...', num2str(sto));
                        else
                            % Adjust DJCList so that:
                            % - column 3 has file data (and file name) instead of file name only
                            % - column 4 has only the name of the marker instead of name and coordinates in proximal segment
                            oldDJC = subject.sessions(j).trials(k).DJC;
                            for fi = 1 : size(DJCList)
                                if fi == 1
                                    % Get all the names of c3d files in oldDJC
                                    allOldDynamicFiles = cell(1,size(oldDJC,1));
                                    for ofi = 1 : length(allOldDynamicFiles)
                                        allOldDynamicFiles{ofi} = oldDJC{ofi,3}.name;
                                    end
                                end
                                ind = strcmp(DJCList{fi,3}, allOldDynamicFiles);
                                DJCList{fi,3} = oldDJC{ind,3};
                                DJCList{fi,4} = oldDJC{ind,4}.name;
                            end
                            fprintf('\n     Tr: Dynamic data for functional joint centers calculation internally recovered...');
                            DJC = CalculateFunctionalJointCenters(DJCList, []);
                            sto = toc(sta);
                            fprintf('\n     Tr: Functional joint centers calculated (%s sec)...', num2str(sto));
                        end
                    else
                        datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                        DJC = CalculateFunctionalJointCenters(DJCList, datapath);
                        sto = toc(sta);
                        fprintf('\n     Tr: Functional joint centers calculated (%s sec)...', num2str(sto));
                    end
                else
                    datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                    DJC = CalculateFunctionalJointCenters(DJCList, datapath);
                    sto = toc(sta);
                    fprintf('\n     Tr: Functional joint centers calculated using recovery path (%s sec)...', num2str(sto));
                end 
                subject.sessions(j).trials(k).DJC = DJC;
            else
                fprintf('\n     Tr: No requested functional joint center calculation ...');
                subject.sessions(j).trials(k).DJC = 'Not needed';
            end
            % Trial: calculate functional axis (MHA)
            MHAList = cleanTableFromEmptyLines(protInfo.MHAList, 5);
            if ~isempty(MHAList)
                sta = tic;
                neverProc = ~isfield(subject.sessions(j).trials(k),'MHA') || isempty(subject.sessions(j).trials(k).MHA); 
                if ~forceDataOverwriting
                    if ~neverProc
                        [ok, dummy1, dummy2] = testMHAFilesList(subject.sessions(j).trials(k).protocolData, protInfo);
                        if ok == 0
                            datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                            MHA = CalculateFunctionalAxis(MHAList, datapath);
                            sto = toc(sta);
                            fprintf('\n     Tr: Functional axis calculated using recovery path (%s sec)...', num2str(sto));
                        else
                            % Adjust MHAList so that:
                            % - column 3 has file data (and file name) instead of file name only
                            % - column 4 has only the name of the marker instead of name and coordinates in proximal segment
                            oldMHA = subject.sessions(j).trials(k).MHA;
                            for fi = 1 : size(MHAList)
                                if fi == 1
                                    % Get all the names of c3d files in oldMHA
                                    allOldDynamicFiles = cell(1,size(oldMHA,1));
                                    for ofi = 1 : length(allOldDynamicFiles)
                                        allOldDynamicFiles{ofi} = oldMHA{ofi,3}.name;
                                    end
                                end
                                ind = strcmp(MHAList{fi,3}, allOldDynamicFiles);
                                MHAList{fi,3} = oldMHA{ind,3};
                                MHAList{fi,4} = oldMHA{ind,4}.name;
                            end
                            fprintf('\n     Tr: Dynamic data for functional axis calculation internally recovered...');
                            MHA = CalculateFunctionalAxis(MHAList, []);
                            sto = toc(sta);
                            fprintf('\n     Tr: Functional axis calculated (%s sec)...', num2str(sto));
                        end
                    else
                        datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                        MHA = CalculateFunctionalAxis(MHAList, datapath);
                        sto = toc(sta);
                        fprintf('\n     Tr: Functional axis calculated (%s sec)...', num2str(sto));
                    end
                else
                    datapath = recoverPath(recoveryPath, 'c3d', 'tree', 'session', subject.name, subject.sessions(j).name, []);
                    MHA = CalculateFunctionalAxis(MHAList, datapath);
                    sto = toc(sta);
                    fprintf('\n     Tr: Functional axis calculated using recovery path (%s sec)...', num2str(sto));
                end 
                subject.sessions(j).trials(k).MHA = MHA;
            else
                fprintf('\n     Tr: No requested functional axis calculation ...');
                subject.sessions(j).trials(k).MHA = 'Not needed';
            end
            % Trial: process dynamic trial
            neverProc = ~isfield(subject.sessions(j).trials(k),'angles') || isempty(subject.sessions(j).trials(k).angles); 
            toProc = forceDataOverwriting || ...
            neverProc || ...
            someProcDoneBefore;
            if toProc
                tr = trToUseDB.subjects(i).sessions(j).trials(k).name;
                datafile = tr;
                % Retrieve raw data
                MARKER_DATA = getMarkersDataFromStruct(subject.sessions(j).trials(k).data.points,BODY.CONTEXT.MarkerLabels);
                MARKER_TIME_OFFSET = 0.;
                MARKER_TIME_GAIN = 1. / subject.sessions(j).trials(k).data.kineFreq;
                fprintf('\n     Tr: Marker data for dynamic file %s recovered ...', datafile);            
                % Trial: put marker coordinates in the BODY structure
                ClearKinematics('markers');
                AssignMarkerDataToBody;
                BODY.HEADER.Trial.MarkerDataFile = datafile;
                sto = toc(sta);
                fprintf('\n     Tr: Marker coordinates assigned to model (%s sec)...', num2str(sto));
                % Trial: interpolate marker gaps (Woltring routine)
                sta = tic;
                InterpolateMarkerKinematics_ADV('Cubic');
                sto = toc(sta);
                fprintf('\n     Tr: Marker gaps filled (%s sec)... ', num2str(sto));
                % Trial: calculate trasformation matrix of each cluster of markers
                sta = tic;
                CalculateClusterKinematics_NO_WB_OPT2(1:length(BODY.SEGMENT));
                sto = toc(sta);
                fprintf('\n     Tr: Cluster kinematics calculated (%s sec)...', num2str(sto));
                % Trial: calculate anatomical landmarks coordinates in the global reference frame
                CalculatePostureRefKinematics_NO_WB;
                sta = tic;
                CalculateVirtualMarkers_NO_WB;
                sto = toc(sta);
                fprintf('\n     Tr: Anatomical landmarks recostructed in the laboratory frame (%s sec) ...', num2str(sto));
                % Trial: Calculate faked markers lying on the MHA(s), for dynamic trial
                CalculateFunctionalAxisMarkers();
                fprintf('\n     Tr: Virtual functional axis markers (lying along the functional axis) created ...');
                % Trial Add MHA markers 
                subject.sessions(j).trials(k).data.points = AggregateAllPoints(subject.sessions(j).trials(k).data.points, 'MHAMarkers');
                fprintf('\n     Tr: Virtual functional axis markers aggregated ...');
                % Trial: calculate kinematics of all anatomical segments
                sta = tic;
                eval(protInfo.kinematics);
                sto = toc(sta);
                fprintf('\n     Tr: Position in space of bony segments calculated  (%s sec)...', num2str(sto));
                % Trial: calculate joint kinematics
                sta = tic;
                if protInfo.absAngRefLab
                    G_T_LAB = protInfo.G_T_LAB;
                else
                    G_T_LAB = eye(4);
                end
                CalculateJointKinematics_OPT3_ADV('AnatomyBased', [], G_T_LAB);
                iJointsAbs = [];
                if protInfo.absAngRefPos == 1
                    proxSegNames = {BODY.JOINT.ProximalSegmentName};
                    ind = strcmp(proxSegNames, 'Global');
                    iJointsAbs = find(ind); % indeces of the joints in which the proximal segment was indicated as 'Global'
                    if ~isempty(iJointsAbs)
                        CalculateJointKinematics_OPT3_ADV('ReferenceBased', iJointsAbs, G_T_LAB);
                    end
                end
                sto = toc(sta);
                fprintf('\n     Tr: Joint kinematics calculated  (%s sec)...', num2str(sto));
                % Trial: correct for gimbal lock, if necessary
                CorrectAnglesForGimbalLock();
                fprintf('\n     Tr: Gimbal lock correction performed ...');
                % Trial: Get relevant angles
                subject.sessions(j).trials(k).data.angles = GetRelevantAngles(iJointsAbs, protInfo.absAngRefPos);
                fprintf('\n     Tr: Wanted angles aggregated ...');
                % Trial: Aggregate points data (add anatomical points)
                subject.sessions(j).trials(k).data.points = AggregateAllPoints(subject.sessions(j).trials(k).data.points, 'AnatomicalLandmarks');
                fprintf('\n     Tr: Anatomical landmarks data aggregated ...');
                % Trial: Save the list of anatomical landmarks
                ALsList = {};
                for s = 1 : length(BODY.SEGMENT)
                    ALsList = [ALsList, {BODY.SEGMENT(s).AnatomicalLandmark.Name}];
                end
                fprintf('\n     Tr: Names of anatomical landmarks saved ...');
                subject.sessions(j).trials(k).data.ALsList = ALsList;
%                 % Trial: Calculate faked markers lying on the MHA(s), for dynamic trial
%                 CalculateFunctionalAxisMarkers();
%                 fprintf('\n     Tr: Virtual functional axis markers (lying along the functional axis) created ...');
%                 % Trial Add MHA markers 
%                 subject.sessions(j).trials(k).data.points = AggregateAllPoints(subject.sessions(j).trials(k).data.points, 'MHAMarkers');
%                 fprintf('\n     Tr: Virtual functional axis markers aggregated ...');
            else
                
            end
            fprintf('\n     Tr: Total time to compute trial kinematics: %s ...', num2str(toc(beg)));
        end % end trials cycle
    end % end sessions cycle
    % save subject data
    %procDataSaving
    saveStructData(subject, trToUseDB, trDB, savePath, splitProcDataLevels, procDataSaving);
end % end subjects cycle
close(h);

fprintf('\n\n\nTime elaplsed: %s\n\n\n', secs2hms(toc));


