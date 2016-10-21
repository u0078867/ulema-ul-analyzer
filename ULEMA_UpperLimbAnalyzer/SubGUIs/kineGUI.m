%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = kineGUI(varargin)
% KINEGUI M-file for kineGUI.fig
%      KINEGUI, by itself, creates a new KINEGUI or raises the existing
%      singleton*.
%
%      H = KINEGUI returns the handle to a new KINEGUI or the handle to
%      the existing singleton*.
%
%      KINEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KINEGUI.M with the given input arguments.
%
%      KINEGUI('Property','Value',...) creates a new KINEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kineGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kineGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kineGUI

% Last Modified by GUIDE v2.5 19-Oct-2016 13:55:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kineGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @kineGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before kineGUI is made visible.
function kineGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kineGUI (see VARARGIN)

% Set data
handles.kine = varargin{1};
set(handles.bodyModelPopup,'String',handles.kine.bodyModel.String);
set(handles.bodyModelPopup,'Value',handles.kine.bodyModel.Value);
set(handles.staticFileEdit,'String',handles.kine.staticFile.String);
set(handles.calPrefixEdit,'String',handles.kine.calPrefix.String);
set(handles.calFileEdit,'String',handles.kine.calFile.String);
set(handles.useSepCalFilesRadio,'Value',handles.kine.useSepCalFiles.Value);
set(handles.useSingleCalFileRadio,'Value',handles.kine.useSingleCalFile.Value);
set(handles.kinematicsPopup,'String',handles.kine.kinematics.String);
set(handles.kinematicsPopup,'Value',handles.kine.kinematics.Value);
set(handles.pointerPopup,'String',handles.kine.pointer.String);
set(handles.pointerPopup,'Value',handles.kine.pointer.Value);
set(handles.wantedJointsList,'String',handles.kine.wantedJoints.String);
set(handles.wantedJointsList,'Value',handles.kine.wantedJoints.Value);
set(handles.absAngRefPosRadio,'Value',handles.kine.absAngRefPos.Value);
set(handles.absAngRefPosFileEdit,'String',handles.kine.absAngRefPosFile.String);
set(handles.absAngRefLabRadio,'Value',handles.kine.absAngRefLab.Value);
set(handles.G_T_LABEdit,'String',mat2str(handles.kine.G_T_LAB.Value));
set(handles.absAngRefThisRadio,'Value',handles.kine.absAngRefThis.Value);
set(handles.absAngRefThisTimeEdit,'String',handles.kine.absAngRefThisTime.String);
% Set commond data to be returned back
l = handles.kine.bodyModel.String;
i = handles.kine.bodyModel.Value;
bodyModel = l{i};
handles.allJoints = GetAllJoints(bodyModel);
selJointsInd = getListInd(handles.kine.wantedJoints.String, handles.allJoints);
handles.allMarkers = GetAllMarkers(bodyModel, selJointsInd);

% Choose default command line output for kineGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kineGUI wait for user response (see UIRESUME)
uiwait;


% --- Outputs from this function are returned to the command line.
function varargout = kineGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles)
    close(hObject);
    varargout{1} = handles.kine;
    varargout{2} = handles.allJoints;
    varargout{3} = handles.allMarkers;
else
    varargout{1} = [];
    varargout{2} = [];
    varargout{3} = [];
end 


% --- Executes on selection change in bodyModelPopup.
function bodyModelPopup_Callback(hObject, eventdata, handles)
% hObject    handle to bodyModelPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bodyModelPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bodyModelPopup

% Set commond data to be returned back
l = get(handles.bodyModelPopup,'String');
i = get(handles.bodyModelPopup,'Value');
bodyModel = l{i};
handles.allJoints = GetAllJoints(bodyModel);
selJointsInd = getListInd(handles.kine.wantedJoints.String, handles.allJoints);
handles.allMarkers = GetAllMarkers(bodyModel, selJointsInd);
% Show the new list of all joints (unselected)
set(handles.wantedJointsList,'String',handles.allJoints);
set(handles.wantedJointsList,'Value',[]);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bodyModelPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bodyModelPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function staticFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to staticFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of staticFileEdit as text
%        str2double(get(hObject,'String')) returns contents of staticFileEdit as a double


% --- Executes during object creation, after setting all properties.
function staticFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to staticFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openBodyModButt.
function openBodyModButt_Callback(hObject, eventdata, handles)
% hObject    handle to openBodyModButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

l = get(handles.bodyModelPopup,'String');
n = get(handles.bodyModelPopup,'Value');
winopen(which(l{n}));


function calPrefixEdit_Callback(hObject, eventdata, handles)
% hObject    handle to calPrefixEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calPrefixEdit as text
%        str2double(get(hObject,'String')) returns contents of calPrefixEdit as a double


% --- Executes during object creation, after setting all properties.
function calPrefixEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calPrefixEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in kinematicsPopup.
function kinematicsPopup_Callback(hObject, eventdata, handles)
% hObject    handle to kinematicsPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns kinematicsPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from kinematicsPopup


% --- Executes during object creation, after setting all properties.
function kinematicsPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kinematicsPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openKineModelButt.
function openKineModelButt_Callback(hObject, eventdata, handles)
% hObject    handle to openKineModelButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

l = get(handles.kinematicsPopup,'String');
n = get(handles.kinematicsPopup,'Value');
winopen(which(l{n}));

% --- Executes on selection change in pointerPopup.
function pointerPopup_Callback(hObject, eventdata, handles)
% hObject    handle to pointerPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pointerPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pointerPopup


% --- Executes during object creation, after setting all properties.
function pointerPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointerPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in openPointerButt.
function openPointerButt_Callback(hObject, eventdata, handles)
% hObject    handle to openPointerButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

l = get(handles.pointerPopup,'String');
n = get(handles.pointerPopup,'Value');
if iscell(l) % when I have 1 element, Matlab creates 'l' as string 
    val = l{n};
else
    val = l;
end
winopen(which(val));


% --- Executes on selection change in wantedJointsList.
function wantedJointsList_Callback(hObject, eventdata, handles)
% hObject    handle to wantedJointsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns wantedJointsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from wantedJointsList


% --- Executes during object creation, after setting all properties.
function wantedJointsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wantedJointsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DJCOptsButt.
function DJCOptsButt_Callback(hObject, eventdata, handles)
% hObject    handle to DJCOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inStruct.DJCList = handles.kine.DJCList;
l = get(handles.bodyModelPopup,'String');
i = get(handles.bodyModelPopup,'Value');
inStruct.bodyModel = l{i};
inStruct.selJointsInd = get(handles.wantedJointsList,'Value');
DJCList = DJCGUI(inStruct);
if ~isempty(DJCList)
    handles.kine.DJCList = DJCList;
end
guidata(hObject, handles);


% --- Executes on button press in MHAOptsButt.
function MHAOptsButt_Callback(hObject, eventdata, handles)
% hObject    handle to MHAOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

inStruct.MHAList = handles.kine.MHAList;
l = get(handles.bodyModelPopup,'String');
i = get(handles.bodyModelPopup,'Value');
inStruct.bodyModel = l{i};
inStruct.selJointsInd = get(handles.wantedJointsList,'Value');
MHAList = MHAGUI(inStruct);
if ~isempty(MHAList)
    handles.kine.MHAList = MHAList;
end
guidata(hObject, handles);



function absAngRefPosFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to absAngRefPosFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of absAngRefPosFileEdit as text
%        str2double(get(hObject,'String')) returns contents of absAngRefPosFileEdit as a double


% --- Executes during object creation, after setting all properties.
function absAngRefPosFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to absAngRefPosFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close kineGUI.
function kineGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to kineGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in closeWinButt.
function closeWinButt_Callback(hObject, eventdata, handles)
% hObject    handle to closeWinButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.kine.bodyModel.String = get(handles.bodyModelPopup,'String');
handles.kine.bodyModel.Value = get(handles.bodyModelPopup,'Value');
handles.kine.staticFile.String = get(handles.staticFileEdit,'String');
handles.kine.calPrefix.String = get(handles.calPrefixEdit,'String');
handles.kine.calFile.String = get(handles.calFileEdit,'String');
handles.kine.useSepCalFiles.Value = get(handles.useSepCalFilesRadio,'Value');
handles.kine.useSingleCalFile.Value = get(handles.useSingleCalFileRadio,'Value');
handles.kine.kinematics.String = get(handles.kinematicsPopup,'String');
handles.kine.kinematics.Value = get(handles.kinematicsPopup,'Value');
handles.kine.pointer.String = get(handles.pointerPopup,'String');
handles.kine.pointer.Value = get(handles.pointerPopup,'Value');
handles.kine.wantedJoints.String = get(handles.wantedJointsList,'String');
handles.kine.wantedJoints.Value = get(handles.wantedJointsList,'Value');
handles.kine.absAngRefPos.Value = get(handles.absAngRefPosRadio,'Value');
handles.kine.absAngRefPosFile.String = get(handles.absAngRefPosFileEdit,'String');
handles.kine.absAngRefLab.Value = get(handles.absAngRefLabRadio,'Value');
handles.kine.absAngRefThis.Value = get(handles.absAngRefThisRadio,'Value');
handles.kine.absAngRefThisTime.String = get(handles.absAngRefThisTimeEdit,'String');
handles.kine.G_T_LAB.Value = eval(get(handles.G_T_LABEdit,'String'));
guidata(hObject, handles);
uiresume;



function calFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to calFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calFileEdit as text
%        str2double(get(hObject,'String')) returns contents of calFileEdit as a double


% --- Executes during object creation, after setting all properties.
function calFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function G_T_LABEdit_Callback(hObject, eventdata, handles)
% hObject    handle to G_T_LABEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of G_T_LABEdit as text
%        str2double(get(hObject,'String')) returns contents of G_T_LABEdit as a double


% --- Executes during object creation, after setting all properties.
function G_T_LABEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G_T_LABEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function absAngRefThisTimeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to absAngRefThisTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of absAngRefThisTimeEdit as text
%        str2double(get(hObject,'String')) returns contents of absAngRefThisTimeEdit as a double


% --- Executes during object creation, after setting all properties.
function absAngRefThisTimeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to absAngRefThisTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when uipanel1 is resized.
function uipanel1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
