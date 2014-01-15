%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = updateProtocolInfo(handles)

n = handles.selectedProt;
set(handles.protIDString,'String',num2str(n));
set(handles.protNameEdit,'String',handles.protDB.protList(n).protName);
% Common information
bodyModel = handles.protDB.protList(n).bodyModel;
handles.allJoints = GetAllJoints(bodyModel);
selJointsInd = getListInd(handles.protDB.protList(n).wantedJoints, handles.allJoints);
handles.allMarkers = GetAllMarkers(bodyModel, selJointsInd);
handles.allAngles = GetAllAngleNames(bodyModel, selJointsInd);
% Kinematics
l = getFilesInFolder(handles.bodyModelsFolder, 'm');
% l = {'BodyModel_UL_6Segm_Left','BodyModel_UL_6Segm_Right','BodyModel_UL_12Segm_Bilat'};
i = searchIndexOfStringCell(l,handles.protDB.protList(n).bodyModel);
if isempty(i)
    msgbox('Impossible to find the stored body model in the Kinematics window!','Warning','warn');
    i = 1;
end
handles.kine.bodyModel.String = l;
handles.kine.bodyModel.Value = i;
handles.kine.staticFile.String = handles.protDB.protList(n).staticFile;
l = getFilesInFolder(handles.kineCalcFolder, 'm');
% l = {'AnatCalc_UL_6Segm_Left','AnatCalc_UL_6Segm_Right','AnatCalc_UL_12Segm_Bilat'};
i = searchIndexOfStringCell(l,handles.protDB.protList(n).kinematics);
if isempty(i)
    msgbox('Impossible to find the stored kinematic model in the Kinematics window!','Warning','warn');
    i = 1;
end
handles.kine.kinematics.String = l;
handles.kine.kinematics.Value = i;
handles.kine.calPrefix.String = handles.protDB.protList(n).calPrefix;
handles.kine.calFile.String = handles.protDB.protList(n).calFile;
handles.kine.useSepCalFiles.Value = handles.protDB.protList(n).useSepCalFiles;
handles.kine.useSingleCalFile.Value = handles.protDB.protList(n).useSingleCalFile;
l = getFilesInFolder(handles.pointersFolder, 'm');
if iscell(l) % when I have 1 element, Matlab creates 'l' as string 
    i = searchIndexOfStringCell(l,handles.protDB.protList(n).pointer);
    if isempty(i)
        msgbox('Impossible to find the stored pointer in the Kinematics window!','Warning','warn');
        i = 1;
    end
else
    i = 1;
end
handles.kine.pointer.String = l;
handles.kine.pointer.Value = i;
handles.kine.protName.String = handles.protDB.protList(n).protName;
handles.kine.absAngRefPos.Value = handles.protDB.protList(n).absAngRefPos;
handles.kine.absAngRefLab.Value = handles.protDB.protList(n).absAngRefLab;
handles.kine.absAngRefPosFile.String = handles.protDB.protList(n).absAngRefPosFile;
handles.kine.DJCList = handles.protDB.protList(n).DJCList;
handles.kine.MHAList = handles.protDB.protList(n).MHAList;
handles.kine.wantedJoints.String = handles.allJoints;
handles.kine.wantedJoints.Value = getListInd(handles.protDB.protList(n).wantedJoints, handles.kine.wantedJoints.String);
handles.kine.G_T_LAB.Value = handles.protDB.protList(n).G_T_LAB;
% Segmentation
handles.seg.segMethod.Value = handles.protDB.protList(n).segMethod;
selectedMethod = handles.seg.segMethod.Value;
handles.seg.startEv.String = handles.evConfig{selectedMethod}.evStart;
handles.seg.intEv.String = handles.evConfig{selectedMethod}.evSync;
handles.seg.stopEv.String = handles.evConfig{selectedMethod}.evStop;
handles.seg.anglesMinMaxEv.Value = handles.protDB.protList(n).anglesMinMaxEv;
handles.seg.timing.Value = handles.protDB.protList(n).timing;
handles.seg.speed.Value = handles.protDB.protList(n).speed;
handles.seg.trajectory.Value = handles.protDB.protList(n).trajectory;
handles.seg.jerk.Value = handles.protDB.protList(n).jerk;
handles.protDB.protList(n).stParPoints = extendTable(handles.protDB.protList(n).stParPoints,handles.defaultStpPointsN, []);
handles.seg.stParPoints.Data = handles.protDB.protList(n).stParPoints;
handles.protDB.protList(n).contexts = extendTable(handles.protDB.protList(n).contexts,handles.defaultContextsN, []);
handles.seg.contexts.Data = handles.protDB.protList(n).contexts;
% Best cycles 
handles.bestCy.bestCyclesN.String = num2str(handles.protDB.protList(n).bestCyclesN);
handles.protDB.protList(n).taskPrefixList = extendTable(handles.protDB.protList(n).taskPrefixList,handles.defaultTaskPrefixN, 4);
handles.bestCy.taskPrefix.Data = handles.protDB.protList(n).taskPrefixList;
handles.bestCy.anglesList = handles.protDB.protList(n).anglesList;
% Clinical parameters



%% Subfunctions

function index = searchIndexOfStringCell(stringsCell, string)
index = [];
for i = 1 : length(stringsCell)
    if strcmp(stringsCell{i},string)
        index = i;
        break;
    end
end

function extTable = extendTable(inTable, newN, colsToRepeat)
N = size(inTable,1);
nCols = size(inTable,2);
row = cell(1,nCols);
for j = 1 : nCols
    row{1,j} = '';
end
if ~isempty(colsToRepeat)
    row{1,colsToRepeat} = inTable{1,colsToRepeat};
end
if newN > N
    for i = N+1 : newN
        for j = 1 : nCols
            inTable(i,:) = row;   
        end
    end
end
extTable = inTable;

