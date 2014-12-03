%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = bestCyGUI(varargin)
% BESTCYGUI M-file for bestCyGUI.fig
%      BESTCYGUI, by itself, creates a new BESTCYGUI or raises the existing
%      singleton*.
%
%      H = BESTCYGUI returns the handle to a new BESTCYGUI or the handle to
%      the existing singleton*.
%
%      BESTCYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BESTCYGUI.M with the given input arguments.
%
%      BESTCYGUI('Property','Value',...) creates a new BESTCYGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bestCyGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bestCyGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bestCyGUI

% Last Modified by GUIDE v2.5 26-Jul-2012 11:06:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bestCyGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @bestCyGUI_OutputFcn, ...
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


% --- Executes just before bestCyGUI is made visible.
function bestCyGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bestCyGUI (see VARARGIN)

% Set data
handles.bestCy = varargin{1};
handles.allAngles = varargin{2};
handles.defaultTaskPrefixN = varargin{3};
handles.defaultAnglesListN = varargin{4};
handles.defaultPhasesN = varargin{5};
set(handles.bestCyclesNEdit,'String',handles.bestCy.bestCyclesN.String);
for i = 1 : handles.defaultPhasesN
    phaseList{1,i} = ['Phase',num2str(i)];
end
phaseList{end} = 'EntireCycle';
phaseList = [' ', phaseList];
handles.phaseList = phaseList;
set(handles.taskPrefixTable,'ColumnName',{'Task prefix:','Context:','Phase:','Edit angles:'});
set(handles.taskPrefixTable,'ColumnFormat',{'char',{'Right','Left','General',' '},phaseList,'char'});
set(handles.taskPrefixTable,'Data',handles.bestCy.taskPrefix.Data,'RowName',[]);
set(handles.taskPrefixTable,'ColumnEditable',[true, true, true, false]);
handles.taskListCache = {};
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bestCyGUI wait for user response (see UIRESUME)
uiwait;


% --- Outputs from this function are returned to the command line.
function varargout = bestCyGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles)
    close(hObject);
    varargout{1} = handles.bestCy;
else
    varargout{1} = [];
end 



function bestCyclesNEdit_Callback(hObject, eventdata, handles)
% hObject    handle to bestCyclesNEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bestCyclesNEdit as text
%        str2double(get(hObject,'String')) returns contents of bestCyclesNEdit as a double


% --- Executes during object creation, after setting all properties.
function bestCyclesNEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bestCyclesNEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function anglesListEdit_Callback(hObject, eventdata, handles)
% hObject    handle to anglesListEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anglesListEdit as text
%        str2double(get(hObject,'String')) returns contents of anglesListEdit as a double

newList = get(handles.anglesListEdit,'String');
i1 = 1;
i2 = length(newList);
handles.bestCy.anglesList{handles.row}(i1:i2,1) = newList;
handles.bestCy.anglesList{handles.row} = handles.bestCy.anglesList{handles.row}(:,1);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function anglesListEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anglesListEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in closeWinButt.
function closeWinButt_Callback(hObject, eventdata, handles)
% hObject    handle to closeWinButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.bestCy.bestCyclesN.String = get(handles.bestCyclesNEdit,'String');
handles.bestCy.taskPrefix.Data = get(handles.taskPrefixTable,'Data');
guidata(hObject, handles);
uiresume;

% --- Executes on button press in closeSaveButt.
function closeSaveButt_Callback(hObject, eventdata, handles)
% hObject    handle to closeSaveButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fastFillTaskTableButt.
function fastFillTaskTableButt_Callback(hObject, eventdata, handles)
% hObject    handle to fastFillTaskTableButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contextList = {'Right','Left','General'};
[phaseUsed, contextUsed, tasksUsed, anglesUsed, handles.taskListCache] = TaskTableFiller(handles.phaseList(2:end), contextList, handles.allAngles, handles.taskListCache);
if ~isempty(phaseUsed) 
    % Add new row to the table
    tabData = get(handles.taskPrefixTable,'Data');
    tabDataNoEmpties = cleanTableFromEmptyLines(tabData(:,1:3)); % empty rows are removed
    for i = 1 : length(tasksUsed)
        taskUsed = tasksUsed{i};
        ind = [];
        for r = 1 : size(tabDataNoEmpties,1)
            if strcmp(tabDataNoEmpties{r,1},taskUsed) && strcmp(tabDataNoEmpties{r,2},contextUsed) && strcmp(tabDataNoEmpties{r,3},phaseUsed)
                ind = r;
            end
        end
        if isempty(ind)
            ind = size(tabDataNoEmpties,1) + 1;
        end
        tabData{ind,1} = taskUsed;
        tabData{ind,2} = contextUsed;
        tabData{ind,3} = phaseUsed;
        handles.bestCy.anglesList{ind} = anglesUsed;
    end
    set(handles.taskPrefixTable,'Data',tabData);
    guidata(hObject, handles);
end


% --- Executes when user attempts to close bestCyGUI.
function bestCyGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to bestCyGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on key press with focus on taskPrefixTable and none of its controls.
function taskPrefixTable_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to taskPrefixTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key,'delete')
    choice = questdlg('Do you want to delete the content of this table?','','Yes','No','No');
    switch choice
        case 'Yes'
            % Reinitialize table
            set(handles.taskPrefixTable,'ColumnName',{'Task prefix:','Context:','Phase:','Edit angles:'});
            set(handles.taskPrefixTable,'ColumnFormat',{'char',{'Right','Left','General',' '},handles.phaseList,'char'});
            for i = 1 : handles.defaultTaskPrefixN
                c{i,1} = '';
                c{i,2} = ' ';
                c{i,3} = ' ';
                c{i,4} = 'Click here...';
            end
            set(handles.taskPrefixTable,'Data',c,'RowName',[]);
            set(handles.taskPrefixTable,'ColumnEditable',[true, true, true, false]);
            for i = 1 : handles.defaultTaskPrefixN
                for j = 1 : defaultAnglesListN
                    handles.bestCy.anglesList{i}{j,1} = '';
                end
            end
    end
end
guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in taskPrefixTable.
function taskPrefixTable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to taskPrefixTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

handles.row = eventdata.Indices(1);
set(handles.anglesListEdit,'String',handles.bestCy.anglesList{handles.row}(:,1));
guidata(hObject, handles);
