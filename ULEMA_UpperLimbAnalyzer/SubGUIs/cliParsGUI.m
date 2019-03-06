%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = cliParsGUI(varargin)
% CLIPARSGUI M-file for cliParsGUI.fig
%      CLIPARSGUI, by itself, creates a new CLIPARSGUI or raises the existing
%      singleton*.
%
%      H = CLIPARSGUI returns the handle to a new CLIPARSGUI or the handle to
%      the existing singleton*.
%
%      CLIPARSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLIPARSGUI.M with the given input arguments.
%
%      CLIPARSGUI('Property','Value',...) creates a new CLIPARSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cliParsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cliParsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cliParsGUI

% Last Modified by GUIDE v2.5 26-Jul-2012 15:06:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cliParsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @cliParsGUI_OutputFcn, ...
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


% --- Executes just before cliParsGUI is made visible.
function cliParsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cliParsGUI (see VARARGIN)

% Set data
handles.cliPars = varargin{1};
handles.subNames = [{' '}, varargin{2}'];
data = handles.cliPars.subMatch.Data;
handles.defaultSubMatchN = varargin{3};
for i = size(data,1)+1 : handles.defaultSubMatchN - size(data,1)
    data{i,1} = ' ';
    data{i,2} = '';
end
handles.cliPars.subMatch.Data = data;
set(handles.subMatchTable,'ColumnName',{'Subject name:','Ref. subject name:'});
if ~isempty(handles.cliPars.refFileSubNames)
    set(handles.subMatchTable,'ColumnFormat',{handles.subNames,handles.cliPars.refFileSubNames});
else
    set(handles.subMatchTable,'ColumnFormat',{handles.subNames,'char'});
end
set(handles.subMatchTable,'RowName',[]);
set(handles.subMatchTable,'ColumnEditable',[true, true]);
if ~isempty(handles.cliPars.subMatch.Data)
    set(handles.subMatchTable,'Data',handles.cliPars.subMatch.Data);
end
if ~isempty(handles.cliPars.refFile.String)
    set(handles.refFileString,'String',handles.cliPars.refFile.String);
end

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.cliParsGUI,'WindowStyle','modal')

% UIWAIT makes untitled wait for user response (see UIRESUME)
uiwait(handles.cliParsGUI);


% --- Outputs from this function are returned to the command line.
function varargout = cliParsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles)
    close(hObject);
    varargout{1} = handles.cliPars;
else
    varargout{1} = [];
end 

% The figure can be deleted now
delete(handles.cliParsGUI);


% --- Executes on button press in refFileButt.
function refFileButt_Callback(hObject, eventdata, handles)
% hObject    handle to refFileButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.subNames) || isequal(handles.subNames,{' '})
    msg{1} = 'Load subject first!';
    msg{2} = '(File -> Load)';
    errordlg(msg,'');
    return
end
[filename, pathname] = uigetfile('*.mat', 'Choose the reference data MAT file',pwd);
if ~isempty(filename) && filename(1) ~= 0
    % Load ref data
    refFile = [pathname, filename];
    refFileData = load(refFile);
    % Get list of all subjects names
    refDataFormat = refDataFormatRecognizer(refFileData);
    if refDataFormat == -1
        msg{1} = 'The loaded is not a valid reference file!';
        errordlg(msg,'');
        return        
    end
    handles.cliPars.refFile.String = filename;
    handles.cliPars.refFileData = refFileData;
    fprintf('\n\nFormat of the ref file: %s\n\n', refDataFormat);
    handles.cliPars.refFileSubNames = refDataSubList(handles.cliPars.refFileData, refDataFormat);
    handles.cliPars.refFileSubNames = [handles.cliPars.refFileSubNames, {' '}];
    % Put that list of names in the age match table
    set(handles.subMatchTable,'ColumnFormat',{handles.subNames,handles.cliPars.refFileSubNames});
    % Show file name
    set(handles.refFileString,'String',filename);
end
guidata(hObject, handles);


% --- Executes on button press in loadSubMatchButt.
function loadSubMatchButt_Callback(hObject, eventdata, handles)
% hObject    handle to loadSubMatchButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.subNames) || isequal(handles.subNames,{' '})
    msg{1} = 'Load subject first!';
    msg{2} = '(File -> Load)';
    errordlg(msg,'');
    return
end
% Get file location
[fileName, pathName] = uigetfile('*.txt', 'Choose the .txt file');
if ~isempty(fileName) && fileName(1) ~= 0
    subMatchFile = fopen([pathName, fileName]);
    subMatch = {};
    while ~feof(subMatchFile)
        line = fgetl(subMatchFile);
        if ~isempty(line)
            [t,r] = strtok(line,',');
            subMatch{end+1,1} = t;
            subMatch{end,2} = r(2:end);
        end
    end
    % Show age match
    format = get(handles.subMatchTable,'ColumnFormat');
    if iscell(format{2})
        set(handles.subMatchTable,'ColumnFormat',{handles.subNames,handles.cliPars.refFileSubNames});
    else
        set(handles.subMatchTable,'ColumnFormat',{handles.subNames,'char'});
    end
    for i = size(subMatch,1) + 1 : handles.defaultSubMatchN
        subMatch{i,1} = ' ';
        subMatch{i,2} = ' ';          
    end
    set(handles.subMatchTable,'Data',subMatch);
    % Close file
    fclose(subMatchFile);
    guidata(hObject, handles);
end


% --- Executes on button press in saveSubMatchButt.
function saveSubMatchButt_Callback(hObject, eventdata, handles)
% hObject    handle to saveSubMatchButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.subNames) || isequal(handles.subNames,{' '})
    msg{1} = 'Load subject first!';
    msg{2} = '(File -> Load)';
    errordlg(msg,'');
    return
end
[fileName, pathName] = uiputfile('SubMatch.txt', 'Save File as');
if ~isempty(fileName) && fileName(1) ~= 0
    subMatchFile = fopen([pathName, fileName],'w');
    subMatch = get(handles.subMatchTable,'Data');
    tempSubMatch = cleanTableFromEmptyLines(subMatch);
    for i = 1 : size(tempSubMatch)
        fprintf(subMatchFile,'%s,%s\n',tempSubMatch{i,1},tempSubMatch{i,2});
    end
    fclose(subMatchFile);
end
guidata(hObject, handles);

% --- Executes on button press in closeWinButt.
function closeWinButt_Callback(hObject, eventdata, handles)
% hObject    handle to closeWinButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.cliPars.subMatch.Data = get(handles.subMatchTable,'Data');
guidata(hObject, handles);
uiresume(handles.cliParsGUI);


% --- Executes when user attempts to close cliParsGUI.
function cliParsGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to cliParsGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
