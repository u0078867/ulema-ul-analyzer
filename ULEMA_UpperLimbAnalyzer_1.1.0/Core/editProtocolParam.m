%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = editProtocolParam(handles, section)

n = get(handles.protocolsList,'Value');
d = ProtOptsDescr();

somethingChanged = false;
switch section
    
    case 'protocol'
        % protName
        test = strcmp(handles.protName, handles.protDB.protList(n).protName);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nProtocol ID changed\n\n');
        end
    
    case 'kine'
        
        % bodyModel
        ind = strcmp(d(:,1),'bodyModel');
        l = handles.kine.bodyModel.String;
        i = handles.kine.bodyModel.Value;
        test = feval(d{ind,3}, l{i}, handles.protDB.protList(n).bodyModel);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nbodyModel changed\n\n');
        end
        % staticFile
        ind = strcmp(d(:,1),'staticFile');
        test = feval(d{ind,3}, handles.kine.staticFile.String, handles.protDB.protList(n).staticFile);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nstaticFile changed\n\n');
        end
        % kinematics
        ind = strcmp(d(:,1),'kinematics');
        l = handles.kine.kinematics.String;
        i = handles.kine.kinematics.Value;
        test = feval(d{ind,3}, l{i}, handles.protDB.protList(n).kinematics);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nkinematics changed\n\n');
        end
        % DJCList
        ind = strcmp(d(:,1),'DJCList');
        test = feval(d{ind,3}, handles.kine.DJCList, handles.protDB.protList(n).DJCList, 1:5);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nDJCList changed\n\n');
        end    
        % MHAList
        ind = strcmp(d(:,1),'MHAList');
        test = feval(d{ind,3}, handles.kine.MHAList, handles.protDB.protList(n).MHAList, 1:5);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nMHAList changed\n\n');
        end       
        % wantedJoints
        ind = strcmp(d(:,1),'wantedJoints');
        l = handles.kine.wantedJoints.String;
        i = handles.kine.wantedJoints.Value;
        test = feval(d{ind,3}, l(i), handles.protDB.protList(n).wantedJoints);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nwantedJoints changed\n\n');
        end
        % calPrefix
        ind = strcmp(d(:,1),'calPrefix');
        test = feval(d{ind,3}, handles.kine.calPrefix.String, handles.protDB.protList(n).calPrefix);
        if test == 0
            somethingChanged = true;
            fprintf('\n\ncalPrefix changed\n\n');
        end 
        % calFile
        ind = strcmp(d(:,1),'calFile');
        test = feval(d{ind,3}, handles.kine.calFile.String, handles.protDB.protList(n).calFile);
        if test == 0
            somethingChanged = true;
            fprintf('\n\ncalFile changed\n\n');
        end 
        % useSepCalFiles
        ind = strcmp(d(:,1),'useSepCalFiles');
        test = feval(d{ind,3}, handles.kine.useSepCalFiles.Value, handles.protDB.protList(n).useSepCalFiles);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nuseSepCalFiles changed\n\n');
        end
        % useSingleCalFile
        ind = strcmp(d(:,1),'useSingleCalFile');
        test = feval(d{ind,3}, handles.kine.useSingleCalFile.Value, handles.protDB.protList(n).useSingleCalFile);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nuseSingleCalFile changed\n\n');
        end
        % pointer
        ind = strcmp(d(:,1),'pointer');
        l = handles.kine.pointer.String;
        i = handles.kine.pointer.Value;
        test = feval(d{ind,3}, l{i}, handles.protDB.protList(n).pointer);
        if test == 0
            somethingChanged = true;
            fprintf('\n\npointer changed\n\n');
        end 
        % absAngRefPos
        ind = strcmp(d(:,1),'absAngRefPos');
        test = feval(d{ind,3}, handles.kine.absAngRefPos.Value, handles.protDB.protList(n).absAngRefPos);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nabsAngRefPos changed\n\n');
        end
        % absAngRefPosFile
        ind = strcmp(d(:,1),'absAngRefPosFile');
        test = feval(d{ind,3}, handles.kine.absAngRefPosFile.String, handles.protDB.protList(n).absAngRefPosFile);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nabsAngRefPosFile changed\n\n');
        end 
        % absAngRefLab
        ind = strcmp(d(:,1),'absAngRefLab');
        test = feval(d{ind,3}, handles.kine.absAngRefLab.Value, handles.protDB.protList(n).absAngRefLab);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nabsAngRefLab changed\n\n');
        end 
        % G_T_LAB
        ind = strcmp(d(:,1),'G_T_LAB');
        test = feval(d{ind,3}, handles.kine.G_T_LAB.Value, handles.protDB.protList(n).G_T_LAB);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nG_T_LAB changed\n\n');
        end 
        
    case 'seg'
        
        % segMethod
        ind = strcmp(d(:,1),'segMethod');
        test = feval(d{ind,3}, handles.seg.segMethod.Value, handles.protDB.protList(n).segMethod);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nsegMethod changed\n\n');
        end 
        % anglesMinMaxEv
        ind = strcmp(d(:,1),'anglesMinMaxEv');
        test = feval(d{ind,3}, handles.seg.anglesMinMaxEv.Value, handles.protDB.protList(n).anglesMinMaxEv);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nanglesMinMaxEv changed\n\n');
        end      
        % timing
        ind = strcmp(d(:,1),'timing');
        test = feval(d{ind,3}, handles.seg.timing.Value, handles.protDB.protList(n).timing);
        if test == 0
            somethingChanged = true;
            fprintf('\n\ntiming changed\n\n');
        end   
        % speed
        ind = strcmp(d(:,1),'speed');
        test = feval(d{ind,3}, handles.seg.speed.Value, handles.protDB.protList(n).speed);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nspeed changed\n\n');
        end   
        % trajectory
        ind = strcmp(d(:,1),'trajectory');
        test = feval(d{ind,3}, handles.seg.trajectory.Value, handles.protDB.protList(n).trajectory);
        if test == 0
            somethingChanged = true;
            fprintf('\n\ntrajectory changed\n\n');
        end  
        % jerk
        ind = strcmp(d(:,1),'jerk');
        test = feval(d{ind,3}, handles.seg.jerk.Value, handles.protDB.protList(n).jerk);
        if test == 0
            somethingChanged = true;
            fprintf('\n\njerk changed\n\n');
        end 
        % contexts
        ind = strcmp(d(:,1),'contexts');
        test = feval(d{ind,3}, handles.seg.contexts.Data, handles.protDB.protList(n).contexts, 1:2);
        if test == 0
            somethingChanged = true;
            fprintf('\n\ncontexts changed\n\n');
        end   
        % stParPoints
        ind = strcmp(d(:,1),'stParPoints');
        test = feval(d{ind,3}, handles.seg.stParPoints.Data, handles.protDB.protList(n).stParPoints, 1:2);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nstParPoints changed\n\n');
        end        
    
    case 'bestCy'
        
        % taskPrefixList
        ind = strcmp(d(:,1),'taskPrefixList');
        test = feval(d{ind,3}, handles.bestCy.taskPrefix.Data, handles.protDB.protList(n).taskPrefixList, 1:3);
        if test == 0
            somethingChanged = true;
            fprintf('\n\ntaskPrefixList changed\n\n');
        end    
        % anglesList
        ind = strcmp(d(:,1),'anglesList');
        test = feval(d{ind,3}, handles.bestCy.anglesList, handles.protDB.protList(n).anglesList);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nanglesList changed\n\n');
        end   
        % bestCyclesN
        ind = strcmp(d(:,1),'bestCyclesN');
        test = feval(d{ind,3}, str2double(handles.bestCy.bestCyclesN.String), handles.protDB.protList(n).bestCyclesN);
        if test == 0
            somethingChanged = true;
            fprintf('\n\nbestCyclesN changed\n\n');
        end  
    
    case 'cliPars'
        
end

if somethingChanged == true
    % Put a '*' at the end of the protocol ID
    handles.protocolsList = putStarInEnd(handles.protocolsList, n);
    % Temporary disable buttons
    set(handles.createProtButt,'Enable','off');
    set(handles.copyProtButt,'Enable','off');
    set(handles.deleteProtButt,'Enable','off');
    set(handles.protUpButt,'Enable','off');
    set(handles.protDoButt,'Enable','off');    
end

% Subfunctions

function hProtocolsList = putStarInEnd(hProtocolsList, n)

l = get(hProtocolsList,'String');
if l{n}(end) ~= '*'
    l{n} = [l{n}, ' *'];
end
set(hProtocolsList,'String',l);

