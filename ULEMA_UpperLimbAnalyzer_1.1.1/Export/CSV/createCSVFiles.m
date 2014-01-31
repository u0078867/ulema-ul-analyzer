%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function createCSVFiles(CSVPath, saveTrCSV, saveSesCSV, expMovSideDataOnly, cacheSubData, trToUseDB, nTr, nSes)

if saveTrCSV
    h = waitbar2(0,'');
    cb = 0;
    cachedSubs = cell(length(trToUseDB.subjects),1);
    for i = 1 : length(trToUseDB.subjects);
        % Load the subject
        sub = trToUseDB.subjects(i).name;
        fprintf('Subject %s loaded...\n', sub);
        subject = loadStructData(trToUseDB, sub);
        if cacheSubData
            cachedSubs{i} = subject;
        end
        % Create the folder for the subject
        subPath = fullfile(CSVPath,sub);
        mkdir(subPath);
        % Loop for every session
        for j = 1 : length(subject.sessions)
            ses = subject.sessions(j).name;
            % Create the folder for the session
            sesPath = fullfile(subPath,ses);
            mkdir(sesPath);
            for k = 1 : length(subject.sessions(j).trials)
                tr = subject.sessions(j).trials(k).name;
                tr = strrep(tr,'.c3d','.csv');
                trPath = fullfile(sesPath,tr);
                cb = cb + 1;
                waitbarText = [fullfile(trToUseDB.subjects(i).name, trToUseDB.subjects(i).sessions(j).name, tr), '...'];
                waitbar2(cb/nTr,h,waitbarText);
                % Create the CSV file for the trial
                trFid = fopen(trPath,'w');
                % Put raw angles data
                writeCurvesGroup(trFid, subject.sessions(j).trials(k).data.angles, 'Raw angles (�)');
                fprintf(trFid,'\n');
                % Put events data
                writeCellVector(trFid, subject.sessions(j).trials(k).data.stParam.eventsRaw.eventSide, 'Side',0);
                writeCellVector(trFid, subject.sessions(j).trials(k).data.stParam.eventsRaw.eventType, 'Type',0);
                writeNumVector(trFid, subject.sessions(j).trials(k).data.stParam.eventsRaw.eventTime, 'Time (s)',0);
                fprintf(trFid, '\n');
                % Put frequency
                writeNumVector(trFid, subject.sessions(j).trials(k).data.kineFreq, 'Camera freq (Hz)',0);
                fprintf(trFid, '\n');
                if isfield(subject.sessions(j).trials(k), 'cycles')
                    % Cycle for every motion cycle
                    contexts = fieldnames(subject.sessions(j).trials(k).cycles);
                    for co = 1 : length(contexts)
                        for cy = 1 : length(subject.sessions(j).trials(k).cycles.(contexts{co}))
                            cycleData = subject.sessions(j).trials(k).cycles.(contexts{co})(cy);
                            fprintf(trFid, '%s (Context: %s, Moving side: %s)\n\n', cycleData.name, cycleData.context, cycleData.movingSide);
                            phases = fieldnames(cycleData.data.anglesNorm);
                            % Cycle for every phase
                            for ph = 1 : length(phases)
                                % Write angle data
                                if expMovSideDataOnly == 1
                                    anglesNormData = filterStruct(cycleData.data.anglesNorm.(phases{ph}), 'firstLetterInFieldName', cycleData.movingSide(1));
                                else
                                    anglesNormData = cycleData.data.anglesNorm.(phases{ph});
                                end
                                writeCurvesGroup(trFid, anglesNormData, ['Resampled angles (�) (', phases{ph}, ')']);
                                fprintf(trFid,'\n');
                            end
                            fprintf(trFid, '\n');
                            % Write spatio-temporal parameters
                            parGrNames = fieldnames(cycleData.data.stParam);
                            parGrNames(strcmp(parGrNames,'events')) = [];
                            for pag = 1 : length(parGrNames)
                                % fprintf(trFid,'Parameter group: %s\n', parGrNames{pag});
                                parameterGroupNameWritten = 0;
                                points = fieldnames(cycleData.data.stParam.(parGrNames{pag}));
                                for po = 1 : length(points)
                                    pointStParams = cycleData.data.stParam.(parGrNames{pag}).(points{po});
                                    phases = fieldnames(pointStParams);
                                    for ph = 1 : length(phases)
                                        % fprintf(trFid, '%s (%s)\n',points{po}, phases{ph});
                                        if ~isempty(pointStParams.(phases{ph})) % if spatio-temporal parameters are present
                                            if parameterGroupNameWritten == 0
                                                fprintf(trFid,'Parameter group: %s\n', parGrNames{pag});
                                                parameterGroupNameWritten = 1;
                                            end
                                            fprintf(trFid, '%s (%s)\n', points{po}, phases{ph});
                                            parNames = fieldnames(pointStParams.(phases{ph}));
                                            for pa = 1 : length(parNames)
                                                writeNumVector(trFid, pointStParams.(phases{ph}).(parNames{pa}), parNames{pa}, 1);
                                            end
                                        end
                                    end
                                end
                            end % end cycle param groups
                            fprintf(trFid, '\n');
                        end   
                    end
                end
                % Close the file
                fclose(trFid);
            end
        end
    end
    close(h);
else
    cacheSubData = 0;
end

% From here on, if subject cached data was produced, it will be used. 

if saveSesCSV
    h = waitbar2(0,'');
    cb = 0;
    for i = 1 : length(trToUseDB.subjects);
        % Load the subject
        sub = trToUseDB.subjects(i).name;
        fprintf('Subject %s loaded...\n', sub);
        if cacheSubData
            subject = cachedSubs{i};
        else
            subject = loadStructData(trToUseDB, sub);
        end
        % Create the folder for the subject
        subPath = fullfile(CSVPath,sub);
        mkdir(subPath);
        % Loop for every session
        for j = 1 : length(subject.sessions)
            cb = cb + 1;
            waitbarText = [fullfile(trToUseDB.subjects(i).name, [trToUseDB.subjects(i).sessions(j).name, ' --> csv/pdf']), '...'];
            waitbar2(cb/nSes,h,waitbarText);
            ses = subject.sessions(j).name;
            % Create the folder for the session
            sesPath = fullfile(subPath,ses);
            mkdir(sesPath);
            % Create the CSV file for the session
            sesFid = fopen([sesPath,'.csv'],'w');
            % Cycle for every task
            if isfield(subject.sessions(j), 'bestCycles')
                tasks = fieldnames(subject.sessions(j).bestCycles);
                for ta = 1 : length(tasks)
                    taskData = subject.sessions(j).bestCycles.(tasks{ta});
                    contexts = fieldnames(taskData);
                    % Cycle for every context
                    for co = 1 : length(contexts)
                        phases = fieldnames(taskData.(contexts{co}));
                        for ph = 1 : length(phases)
                            formattedData = taskData.(contexts{co}).(phases{ph}).formattedData;
                            fprintf(sesFid, '\nTask: %s, Context: %s, %s\n\n', tasks{ta}, contexts{co}, phases{ph});
                            if isfield(formattedData, 'RMSETableForBestCycles')
                                writeCellMatrix(sesFid, formattedData.RMSETableForBestCycles, 'RMSE table for best cycles selection', 0);
                                fprintf(sesFid, '\n');
                            end
                            if isfield(formattedData, 'RMSETableVSPerCycle')
                                for tab = 1 : length(formattedData.RMSETableVSPerCycle)
                                    writeCellMatrix(sesFid, formattedData.RMSETableVSPerCycle{tab}, ['RMSE table VS, best cycle ',num2str(tab)], 0);
                                    fprintf(sesFid, '\n');
                                end
                                fprintf(sesFid, '\n');
                            end
                            if isfield(formattedData, 'RMSETableVSandPSPerAngle')
                                writeCellMatrix(sesFid, formattedData.RMSETableVSandPSPerAngle, 'RMSE table VS and PS per angle', 0);
                                fprintf(sesFid, '\n');
                            end
                            if isfield(formattedData, 'MAPTable')
                                writeCellMatrix(sesFid, formattedData.MAPTable, 'MAP table:', 0);
                                fprintf(sesFid, '\n');
                            end
                            if isfield(formattedData, 'lnMAPTable')
                                writeCellMatrix(sesFid, formattedData.lnMAPTable, 'MAP table (log-transformed):', 0);
                                fprintf(sesFid, '\n');
                                % Create pdf file of the MAP (per task, context and phase)
                                fileName = [ses,'_', tasks{ta}, '_', contexts{co}, '_', phases{ph}];
                                titleName{1} = ['Subject: ', sub, '; Session: ', ses, ';'];
                                titleName{2} = ['Task: ', tasks{ta}, '; Context: ', contexts{co}, '; Phase: ', phases{ph}];
                                fig = plotMAP(formattedData.lnMAPTable, 'off', 90, titleName);
                                print(fig,'-dpdf',fullfile(subPath,[fileName,'.pdf']));
                            end
                        end
                    end
                end
            end
            % Close the file
            fclose(sesFid);
        end
    end
    close(h);
end


