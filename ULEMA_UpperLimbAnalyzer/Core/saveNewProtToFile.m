%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = saveNewProtToFile(handles)

% Updating the selected protocol structure
n = handles.selectedProt;
% Kinematics
l = handles.kine.bodyModel.String;
i = handles.kine.bodyModel.Value;
handles.protDB.protList(n).bodyModel = l{i};
handles.protDB.protList(n).staticFile = handles.kine.staticFile.String;
l = handles.kine.kinematics.String;
i = handles.kine.kinematics.Value;
handles.protDB.protList(n).kinematics = l{i};
handles.protDB.protList(n).DJCList = handles.kine.DJCList;
handles.protDB.protList(n).MHAList = handles.kine.MHAList;
l = handles.kine.wantedJoints.String;
i = handles.kine.wantedJoints.Value;
handles.protDB.protList(n).wantedJoints = l(i);
handles.protDB.protList(n).calPrefix = handles.kine.calPrefix.String;
handles.protDB.protList(n).calFile = handles.kine.calFile.String;
handles.protDB.protList(n).useSingleCalFile = handles.kine.useSingleCalFile.Value;
handles.protDB.protList(n).useSepCalFiles = handles.kine.useSepCalFiles.Value;
l = handles.kine.pointer.String;
i = handles.kine.pointer.Value;
if iscell(l) % when I have 1 element, Matlab creates 'l' as string 
    val = l{i};
else
    val = l;
end
handles.protDB.protList(n).pointer = val;
handles.protDB.protList(n).absAngRefPos = handles.kine.absAngRefPos.Value;
handles.protDB.protList(n).absAngRefPosFile = handles.kine.absAngRefPosFile.String;
handles.protDB.protList(n).absAngRefLab = handles.kine.absAngRefLab.Value;
handles.protDB.protList(n).G_T_LAB = handles.kine.G_T_LAB.Value;
handles.protDB.protList(n).absAngRefThis = handles.kine.absAngRefThis.Value;
handles.protDB.protList(n).absAngRefThisTime = str2double(handles.kine.absAngRefThisTime.String);
% Segmentation
handles.protDB.protList(n).segMethod = handles.seg.segMethod.Value;
handles.protDB.protList(n).anglesMinMaxEv = handles.seg.anglesMinMaxEv.Value;
handles.protDB.protList(n).timing = handles.seg.timing.Value;
handles.protDB.protList(n).speed = handles.seg.speed.Value;
handles.protDB.protList(n).trajectory = handles.seg.trajectory.Value;
handles.protDB.protList(n).jerk = handles.seg.jerk.Value;
handles.protDB.protList(n).contexts = handles.seg.contexts.Data;
handles.protDB.protList(n).stParPoints = handles.seg.stParPoints.Data;
% Best cycles
handles.protDB.protList(n).bestCyclesN = str2double(handles.bestCy.bestCyclesN.String);
handles.protDB.protList(n).taskPrefixList = handles.bestCy.taskPrefix.Data;
handles.protDB.protList(n).anglesList = handles.bestCy.anglesList; 
% Clinical parameters
handles.protDB.protList(n).logTransVS = 1;
% Protocol
handles.protDB.protList(n).protName = get(handles.protNameEdit,'String');
l = get(handles.protocolsList,'String');
i = get(handles.protocolsList,'Value');
l{i} = get(handles.protNameEdit,'String');
set(handles.protocolsList,'String',l);  % updating the current protocol with a new name (if necessary)


% IMPORTANT NOTE: DON'T UPDATE HERE ANY VARIABLE REGARDING WANTED ANGLES

% Saving file
protDB = handles.protDB;
save(handles.protDBpath,'-struct','protDB');

% Erasing '*' after protocol ID number in the list
l = get(handles.protocolsList,'String');
i = get(handles.protocolsList,'Value');
l{i} = strrep(l{i},' *','');
set(handles.protocolsList,'String',l);

% Enable "Create new protocol" and "Delete protocol from list" and up and
% down arrows
set(handles.createProtButt,'Enable','on');
set(handles.deleteProtButt,'Enable','on');
set(handles.copyProtButt,'Enable','on');
set(handles.protUpButt,'Enable','on');
set(handles.protDoButt,'Enable','on');

