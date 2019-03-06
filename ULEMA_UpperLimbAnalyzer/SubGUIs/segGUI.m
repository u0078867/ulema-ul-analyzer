%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = segGUI(varargin)
% SEGGUI M-file for segGUI.fig
%      SEGGUI, by itself, creates a new SEGGUI or raises the existing
%      singleton*.
%
%      H = SEGGUI returns the handle to a new SEGGUI or the handle to
%      the existing singleton*.
%
%      SEGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGGUI.M with the given input arguments.
%
%      SEGGUI('Property','Value',...) creates a new SEGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segGUI

% Last Modified by GUIDE v2.5 26-Jul-2012 08:55:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @segGUI_OutputFcn, ...
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


% --- Executes just before segGUI is made visible.
function segGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segGUI (see VARARGIN)

% Set data
handles.seg = varargin{1};
handles.evConfig = varargin{2};
handles.allMarkers = varargin{3};
handles.defaultContextsN = varargin{4};
handles.defaultStpPointsN = varargin{5};
handles.defaultPhasesN = varargin{6};
metList = {};
for i = 1 : length(handles.evConfig)
    metList{i} = num2str(handles.evConfig{i}.method);
end
set(handles.segMethodsList,'String',metList);
selectedMethod = handles.seg.segMethod.Value;
set(handles.segMethodsList,'Value',selectedMethod);
set(handles.startEvString,'String',handles.evConfig{selectedMethod}.evStart);
set(handles.intEvList,'String',handles.evConfig{selectedMethod}.evSync);
set(handles.stopEvString,'String',handles.evConfig{selectedMethod}.evStop);
set(handles.descrString,'String',handles.evConfig{selectedMethod}.segName);
set(handles.contextsTable,'ColumnName',{'Context:','Side:'});
set(handles.contextsTable,'ColumnFormat',{{'Right','Left','General',' '},{'Right','Left',' '}});
set(handles.contextsTable,'RowName',[]);
set(handles.contextsTable,'ColumnEditable',[true, true]);
set(handles.contextsTable,'Data',handles.seg.contexts.Data);
set(handles.anglesMinMaxEvCheck,'Value',handles.seg.anglesMinMaxEv.Value);
set(handles.timingCheck,'Value',handles.seg.timing.Value);
set(handles.speedCheck,'Value',handles.seg.speed.Value);
set(handles.trajectoryCheck,'Value',handles.seg.trajectory.Value);
set(handles.jerkCheck,'Value',handles.seg.jerk.Value);
set(handles.stParPointsTable,'ColumnName',{'Marker:','Phase:'});
for i = 1 : handles.defaultPhasesN
    phaseList{1,i} = ['Phase',num2str(i)];
end
phaseList{end} = 'EntireCycle';
phaseList = [' ', phaseList];
set(handles.stParPointsTable,'ColumnFormat',{[' ',handles.allMarkers],phaseList});
set(handles.stParPointsTable,'Data',handles.seg.stParPoints.Data,'RowName',[]);
set(handles.stParPointsTable,'ColumnEditable',[true, true]);
% Choose default command line output for segGUI
handles.output = handles.seg;

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.segGUI,'WindowStyle','modal')

% UIWAIT makes untitled wait for user response (see UIRESUME)
uiwait(handles.segGUI);


% --- Outputs from this function are returned to the command line.
function varargout = segGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles)
    close(hObject);
    varargout{1} = handles.seg;
else
    varargout{1} = [];
end 

% The figure can be deleted now
delete(handles.segGUI);


% --- Executes on selection change in segMethodsList.
function segMethodsList_Callback(hObject, eventdata, handles)
% hObject    handle to segMethodsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns segMethodsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from segMethodsList

selectedMethod = get(handles.segMethodsList,'Value');
set(handles.startEvString,'String',handles.evConfig{selectedMethod}.evStart);
set(handles.intEvList,'String',handles.evConfig{selectedMethod}.evSync);
set(handles.stopEvString,'String',handles.evConfig{selectedMethod}.evStop);
set(handles.descrString,'String',handles.evConfig{selectedMethod}.segName);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function segMethodsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segMethodsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in intEvList.
function intEvList_Callback(hObject, eventdata, handles)
% hObject    handle to intEvList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns intEvList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from intEvList


% --- Executes during object creation, after setting all properties.
function intEvList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intEvList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in trajectoryCheck.
function trajectoryCheck_Callback(hObject, eventdata, handles)
% hObject    handle to trajectoryCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of trajectoryCheck


% --- Executes on button press in speedCheck.
function speedCheck_Callback(hObject, eventdata, handles)
% hObject    handle to speedCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of speedCheck


% --- Executes on button press in timingCheck.
function timingCheck_Callback(hObject, eventdata, handles)
% hObject    handle to timingCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timingCheck


% --- Executes on button press in jerkCheck.
function jerkCheck_Callback(hObject, eventdata, handles)
% hObject    handle to jerkCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of jerkCheck


% --- Executes on button press in anglesMinMaxEvCheck.
function anglesMinMaxEvCheck_Callback(hObject, eventdata, handles)
% hObject    handle to anglesMinMaxEvCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of anglesMinMaxEvCheck


% --- Executes on button press in closeWinButt.
function closeWinButt_Callback(hObject, eventdata, handles)
% hObject    handle to closeWinButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.seg.segMethod.Value = get(handles.segMethodsList,'Value');
handles.seg.contexts.Data = get(handles.contextsTable,'Data');
handles.seg.anglesMinMaxEv.Value = get(handles.anglesMinMaxEvCheck,'Value');
handles.seg.timing.Value = get(handles.timingCheck,'Value');
handles.seg.speed.Value = get(handles.speedCheck,'Value');
handles.seg.trajectory.Value = get(handles.trajectoryCheck,'Value');
handles.seg.jerk.Value = get(handles.jerkCheck,'Value');
handles.seg.stParPoints.Data = get(handles.stParPointsTable,'Data');
guidata(hObject, handles);
uiresume(handles.segGUI);

% --- Executes when user attempts to close segGUI.
function segGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to segGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
