%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = TaskTableFiller(varargin)
% TASKTABLEFILLER M-file for TaskTableFiller.fig
%      TASKTABLEFILLER, by itself, creates a new TASKTABLEFILLER or raises the existing
%      singleton*.
%
%      H = TASKTABLEFILLER returns the handle to a new TASKTABLEFILLER or the handle to
%      the existing singleton*.
%
%      TASKTABLEFILLER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TASKTABLEFILLER.M with the given input arguments.
%
%      TASKTABLEFILLER('Property','Value',...) creates a new TASKTABLEFILLER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TaskTableFiller_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TaskTableFiller_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TaskTableFiller

% Last Modified by GUIDE v2.5 05-Mar-2012 10:25:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TaskTableFiller_OpeningFcn, ...
                   'gui_OutputFcn',  @TaskTableFiller_OutputFcn, ...
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


% --- Executes just before TaskTableFiller is made visible.
function TaskTableFiller_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TaskTableFiller (see VARARGIN)

% Get input lists
set(handles.phasePopup, 'String', varargin{1});
set(handles.contextPopup, 'String', varargin{2});
set(handles.angleList, 'String', varargin{3});
if ~isempty(varargin{4})
    set(handles.taskList, 'String', varargin{4});
end

% Choose default command line output for TaskTableFiller
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TaskTableFiller wait for user response (see UIRESUME)
uiwait;


% --- Outputs from this function are returned to the command line.
function varargout = TaskTableFiller_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(handles)
    varargout{1} = handles.out.phaseUsed;
    varargout{2} = handles.out.contextUsed;
    varargout{3} = handles.out.tasksUsed;
    varargout{4} = handles.out.anglesUsed;
    varargout{5} = handles.out.taskList;
else
        varargout{1} = handles.out.phaseUsed;
    varargout{2} = handles.out.contextUsed;
    varargout{3} = handles.out.tasksUsed;
    varargout{4} = handles.out.anglesUsed;
    varargout{5} = handles.out.taskList;
end
close(handles.figure1);


% --- Executes on selection change in angleList.
function angleList_Callback(hObject, eventdata, handles)
% hObject    handle to angleList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns angleList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from angleList


% --- Executes during object creation, after setting all properties.
function angleList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angleList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in phasePopup.
function phasePopup_Callback(hObject, eventdata, handles)
% hObject    handle to phasePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns phasePopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from phasePopup


% --- Executes during object creation, after setting all properties.
function phasePopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to phasePopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in contextPopup.
function contextPopup_Callback(hObject, eventdata, handles)
% hObject    handle to contextPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns contextPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from contextPopup


% --- Executes during object creation, after setting all properties.
function contextPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to contextPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chooseTaskListButt.
function chooseTaskListButt_Callback(hObject, eventdata, handles)
% hObject    handle to chooseTaskListButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile('*.txt', 'Choose the ftask list text file');
taskList = {};
if ~isempty(filename) && filename(1) ~= 0
    % Read task list and put it in the listbox
    fid = fopen(fullfile(pathname,filename));
    while 1
        line = fgetl(fid);
        if ~ischar(line), break, end
        taskList{end+1} = line;
    end
    fclose(fid);
    set(handles.taskList,'String',taskList);
    guidata(hObject, handles);
end

% --- Executes on button press in fillButt.
function fillButt_Callback(hObject, eventdata, handles)
% hObject    handle to fillButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s = get(handles.phasePopup,'String');
l = get(handles.phasePopup,'Value');
handles.out.phaseUsed = s{l};
s = get(handles.contextPopup,'String');
l = get(handles.contextPopup,'Value');
handles.out.contextUsed = s{l};
s = get(handles.taskList,'String');
l = get(handles.taskList,'Value');
if isempty(l) || isempty(s)
    return
end
handles.out.tasksUsed = s(l);
s = get(handles.angleList,'String');
l = get(handles.angleList,'Value');
if isempty(l) || isempty(s)
    return
end
handles.out.anglesUsed = s(l);
handles.out.taskList = get(handles.taskList,'String');
guidata(hObject, handles);
uiresume;


% --- Executes on button press in cancButt.
function cancButt_Callback(hObject, eventdata, handles)
% hObject    handle to cancButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.out.phaseUsed = [];
handles.out.contextUsed = [];
handles.out.tasksUsed = [];
handles.out.anglesUsed = [];
handles.out.taskList = get(handles.taskList,'String'); 
guidata(hObject, handles);
uiresume;


% --- Executes on selection change in taskList.
function taskList_Callback(hObject, eventdata, handles)
% hObject    handle to taskList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns taskList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from taskList


% --- Executes during object creation, after setting all properties.
function taskList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to taskList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(hObject);
