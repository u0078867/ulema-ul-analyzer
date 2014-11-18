%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [ok] = checkRecoveryPathNeed(trToUseDB, trToUseDBOrig, sectionsToComp, recoveryPath, forceDataOverwriting)

ok = 1;

if sectionsToComp.rawDataRead
    if isempty(recoveryPath) && forceDataOverwriting == 1
        cellMsg = {};
            cellMsg{end+1} = 'Raw data reading: when "force data overwriting" is set';
            cellMsg{end+1} = 'you need to specify a recovery path';
            cellMsg{end+1} = '(Processing -> Options -> Set recovery path)';
        uiwait(errordlg(cellMsg, ''));
        ok = 0;
        return
    end
end

if sectionsToComp.kine
    if isempty(recoveryPath)
        if forceDataOverwriting == 0
            for i = 1 : length(trToUseDB.subjects)
                subject = loadStructData(trToUseDB, trToUseDB.subjects(i).name);
                for j = 1 : length(trToUseDB.subjects(i).sessions)
                    for k = 1 : length(trToUseDB.subjects(i).sessions(j).trials)
                        %if isAlreadyProcessed(trToUseDB.subjects(i).sessions(j).trials(k)) % only for data loaded from .mat
                            test = [];
                            % Check for the critical sessions
                            test(end+1) = isfield(subject.sessions(j).trials(k).data,'angles') && ~isempty(subject.sessions(j).trials(k).data.angles);
                            if test(end) == 0
                                cellMsg = {};
                                cellMsg{end+1} = sprintf('Kine (%s):', trToUseDB.subjects(i).sessions(j).trials(k).name);
                                cellMsg{end+1} = 'Kinematics will be calculated for the first time. To perform this,';
                                cellMsg{end+1} = 'set the recovery path to the folder containing the subject subfolders.';
                                cellMsg{end+1} = '(Processing -> Options -> Set recovery path)';
                                uiwait(errordlg(cellMsg, ''));                                
                                ok = 0;
                                return
                            end
                            oldProtocolData = trToUseDBOrig.subjects(i).sessions(j).trials(k).protocolData;
                            currProtocolData = trToUseDB.subjects(i).sessions(j).trials(k).protocolData;
                            % test: check if the static file name is the same
                            test(end+1) = strcmp(oldProtocolData.staticFile,currProtocolData.staticFile);
                            % test: check if the static file name for reference
                            % position is the same, if needed
                            if currProtocolData.absAngRefPos == 0
                                test(end+1) = 1;
                            else
                                test(end+1) = strcmp(oldProtocolData.absAngRefPosFile,currProtocolData.absAngRefPosFile);
                            end
                            % test: check the calibration name prefix for calibration files
                            test(end+1) = strcmp(oldProtocolData.calPrefix,currProtocolData.calPrefix);
                            % test: check if the version is greater than 1
                            test(end+1) = trToUseDB.subjects(i).sessions(j).trials(k).version > 1;
                            % test: check that, in the dynamic joint centers list, if the
                            % columns related to the dynamic trial file names for
                            % old and current protocol content are the same or not
                            [ok, oldFilesList, currFilesList] = testDJCFilesList(oldProtocolData, currProtocolData);
                            if isempty(currFilesList)
                                test(end+1) = 1;    % since no file for JC calculation is needed, the test is autmatically passed
                            else
                                test(end+1) = ok;
                            end
                            % test: check that, in the functional axis list, if the
                            % columns related to the dynamic trial file names for
                            % old and current protocol content are the same or not
                            [ok, oldFilesList, currFilesList] = testMHAFilesList(oldProtocolData, currProtocolData);
                            if isempty(currFilesList)
                                test(end+1) = 1;    % since no file for MHA calculation is needed, the test is autmatically passed
                            else
                                test(end+1) = ok;
                            end
                            if length(test) > sum(test) % if not all the tests are passed
                                cellMsg = {};
                                cellMsg{end+1} = sprintf('Kine (%s):', trToUseDB.subjects(i).sessions(j).trials(k).name);
                                cellMsg{end+1} = 'impossible to get some of the following data:';
                                cellMsg{end+1} = '- marker data for static file';
                                cellMsg{end+1} = '- marker data for static file for reference position';
                                cellMsg{end+1} = '- calibration prefix';
                                cellMsg{end+1} = '- marker data for AL calibration files (version 1 ?)';
                                cellMsg{end+1} = '- data for dynamic file(s) for JC calculation';
                                cellMsg{end+1} = 'by only looking into the loaded .mat files.';
                                cellMsg{end+1} = 'You need to specify a recovery path';
                                cellMsg{end+1} = '(Processing -> Options -> Set recovery path)';
                                uiwait(errordlg(cellMsg, ''));
                                ok = 0;
                                return
                            end
                        %end
                    end
                end
            end
        else
            cellMsg = {};
            cellMsg{end+1} = 'Kine: when "force data overwriting" is set';
            cellMsg{end+1} = 'you need to specify a recovery path';
            cellMsg{end+1} = '(Processing -> Options -> Set recovery path)';
            uiwait(errordlg(cellMsg, ''));
            ok = 0;
            return 
        end
    end
end

if sectionsToComp.expC3D
    if isempty(recoveryPath)
        cellMsg = {};
        cellMsg{end+1} = 'Export to C3D: you must always specify a recovery path';
        cellMsg{end+1} = '(Processing -> Options -> Set recovery path)';
        uiwait(errordlg(cellMsg, ''));
        ok = 0;
        return
    end
end


