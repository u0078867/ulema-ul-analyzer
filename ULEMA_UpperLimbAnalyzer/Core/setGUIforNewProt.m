%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = setGUIforNewProt(handles)

% Creating new protocol ID number
newProtName = 'Untitled';
protIDsStr = get(handles.protocolsList,'String');
newID = length(protIDsStr)+1;
set(handles.protocolsList, 'String', [protIDsStr; {newProtName}]);
set(handles.protocolsList, 'Value', newID);
set(handles.protNameEdit, 'String', newProtName);

% Setting default GUI parameters
set(handles.protIDString,'String',num2str(newID));
% Kinematics
handles.kine.bodyModel.String = getFilesInFolder(handles.bodyModelsFolder, 'm');
handles.kine.bodyModel.Value = 1;
handles.kine.staticFile.String = 'Static.c3d';
handles.kine.kinematics.String = getFilesInFolder(handles.kineCalcFolder, 'm');
handles.kine.kinematics.Value = 1;
handles.kine.wantedJoints.Value = 1;
handles.kine.calPrefix.String = 'cal';
handles.kine.calFile.String = 'calMARKERS.c3d';
handles.kine.useSepCalFiles.Value = 1;
handles.kine.useSingleCalFile.Value = 0;
handles.kine.pointer.String = getFilesInFolder(handles.pointersFolder, 'm');
handles.kine.pointer.Value = 1;
handles.kine.absAngRefPos.Value = 1;
handles.kine.absAngRefPosFile.String = 'Static.c3d';
handles.kine.absAngRefLab.Value = 0;
handles.kine.G_T_LAB.String = eye(4);
handles.kine.absAngRefThis.Value = 0;
handles.kine.absAngRefThisTime.String = '5';
% Segmentation
handles.seg.segMethod.Value = 1;
handles.seg.timing.Value = 1;
handles.seg.speed.Value = 1;
handles.seg.trajectory.Value = 1;
handles.seg.jerk.Value = 1;
for i = 1 : handles.defaultContextsN
    initData{i,1} = ' ';
    initData{i,2} = ' ';
end
handles.seg.contexts.Data = initData;
for i = 1 : handles.defaultStpPointsN
    initData{i,1} = '';
    initData{i,2} = '';
end
handles.seg.stParPoints.Data = initData;
% Best cycles
handles.bestCy.bestCyclesN.String = '3';
for i = 1 : handles.defaultTaskPrefixN
    c{i,1} = '';
    c{i,2} = '';
    c{i,3} = '';
    c{i,4} = 'Click here...';
end
handles.bestCy.taskPrefix.Data = c;
for i = 1 : handles.defaultTaskPrefixN
    for j = 1 : defaultAnglesListN
        handles.bestCy.anglesList{i}{j,1} = '';
    end
end
% Clinical parameters







