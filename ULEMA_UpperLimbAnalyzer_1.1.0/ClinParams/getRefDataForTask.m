%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [refDataStruct, existingAnglesList, errMsg] = getRefDataForTask(refFileData, dataFormat, refDataSub, task, context, phase, anglesList)

% refDataStruct contains two fields:
% - cycles: cell-array where every cell is a matrix (n x 101), where n is the number of angles
% - anglesList: cell-array of strings indicating the name of the angles in 'cycles'

refDataStruct = [];
errMsg = '';
existingAnglesList = anglesList;

if ~isempty(refFileData) && ~isempty(dataFormat)

    switch dataFormat

        case 'UZP_1.0'  % data collected until October 2011 (format produced by Ellen)

            % For the moment, only data from start to PTA
            if ~strcmp(context,'General') || ~strcmp(phase,'Phase1')
                refDataStruct = [];
                return
            end
            % Finding subject
            DBType = fieldnames(refFileData);
            for i = 1 : length(refFileData.(DBType{1}).PP)
                if strcmp(refFileData.(DBType{1}).PP(i).Name, refDataSub)
                    iSub = i;
                    break;
                end
            end
            % Finding task
            for i = 1 : length(refFileData.(DBType{1}).PP(iSub).Sessie(1).Taak)
                if strcmp(refFileData.(DBType{1}).PP(iSub).Sessie(1).Taak(i).Name, task)
                    iTask = i;
                    break;
                end
            end
            % Remove 'R' or 'L' at the beginnig of angle names (in the BodyModel file)
            for i = 1 : length(anglesList)
                if anglesList{i}(1) == 'R' || anglesList{i}(1) == 'L'
                    anglesList{i} = anglesList{i}(2:end);
                end
            end
            % Get data from cycles (usually 6)
            refDataStruct.anglesList = anglesList;
            cycleCont = 0;
            for i = 1 : length(refFileData.(DBType{1}).PP(iSub).Sessie(1).Taak(iTask).Trial)
                for j = 1 : length(refFileData.(DBType{1}).PP(iSub).Sessie(1).Taak(iTask).Trial(i))
                    cycleCont = cycleCont + 1;
                    for a = 1 : length(anglesList)
                        refDataStruct.cycles{cycleCont}(a,:) = refFileData.(DBType{1}).PP(iSub).Sessie(1).Taak(iTask).Trial(i).Cyclus(j).(anglesList{a});
                    end
                end
            end
            
        case 'UZP_1.1' % data collected after October 2011 (format produced by Davide). Only one mean normal subject is created
                    
            contAngles = 0;
            anglesToDelete = [];
            for a = 1 : length(anglesList)
                if isfield(refFileData.RefData.tasks,task)
                    if isfield(refFileData.RefData.tasks.(task),phase)
                        if isfield(refFileData.RefData.tasks.(task).(phase).angles.mean, anglesList{a})
                            % a mixed right and left normal db was created. In this case, the angles in the DB don't have the prefix (e.g. R or L)
                            contAngles = contAngles + 1;
                            refDataStruct.cycles{1}(contAngles,:) = refFileData.RefData.tasks.(task).(phase).angles.mean.(anglesList{a})';
                        elseif isfield(refFileData.RefData.tasks.(task).(phase).angles.mean, anglesList{a}(2:end))
                            % the normal db refers to a specific side
                            contAngles = contAngles + 1;
                            refDataStruct.cycles{1}(contAngles,:) = refFileData.RefData.tasks.(task).(phase).angles.mean.(anglesList{a}(2:end))';
                        else
                            anglesToDelete(end+1) = a;
                            fprintf('\n   Se: Angle %s not found for task %s and phase %s in the reference file...', anglesList{a}, task, phase);
                        end
                    else
                        errMsg = sprintf('\n   Se: Phase %s not found for task %s in the reference file...', phase, task);
                        refDataStruct = [];
                        return;
                    end
                else
                    errMsg = sprintf('\n   Se: Task %s not found in the reference file...', task);
                    refDataStruct = [];
                    return;
                end
            end
            % Delete the angles that were not found in the reference db
            existingAnglesList(anglesToDelete) = [];
            % Replicate all the cycles used to create the mean curves for a specific task and phase
            refDataStruct.rawData = refFileData.RefData.tasks.(task).(phase).angles.rawData;
            
    end

else
    
    errMsg = sprintf('\n   Se: Cannot find reference data for task %s, context %s and phase %s...', task, context, phase);
    
end

disp('')



