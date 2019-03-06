%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = MHAGUI(varargin)
% MHAGUI M-file for MHAGUI.fig
%      MHAGUI, by itself, creates a new MHAGUI or raises the existing
%      singleton*.
%
%      H = MHAGUI returns the handle to a new MHAGUI or the handle to
%      the existing singleton*.
%
%      MHAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MHAGUI.M with the given input arguments.
%
%      MHAGUI('Property','Value',...) creates a new MHAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MHAGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MHAGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MHAGUI

% Last Modified by GUIDE v2.5 12-Dec-2013 11:27:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MHAGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MHAGUI_OutputFcn, ...
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


% --- Executes just before MHAGUI is made visible.
function MHAGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MHAGUI (see VARARGIN)

% Set table properties and data
MHAList = varargin{1}.MHAList;
bodyModel = varargin{1}.bodyModel;
selJointsInd = varargin{1}.selJointsInd;
allSegments = GetAllSegments(bodyModel, selJointsInd); 
set(handles.MHATable,'ColumnName',{'Segment 1:','Segment 2:','Dynamic trial:','Assign to (*):','Method:'});
set(handles.MHATable,'ColumnFormat',{[allSegments, {' '}],[allSegments, {' '}],'char','char',{'MHA', ' '}});
set(handles.MHATable,'Data',MHAList); 
set(handles.MHATable,'ColumnEditable',[true, true, true, true, true]);

% Choose default command line output for MHAGUI
handles.output = MHAList;

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes untitled wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MHAGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles)
    close(hObject);
    varargout{1} = handles.output;
else
    varargout{1} = [];
end    

% The figure can be deleted now
delete(handles.figure1);


% --- Executes on button press in closeWinButt.
function closeWinButt_Callback(hObject, eventdata, handles)
% hObject    handle to closeWinButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output = get(handles.MHATable,'Data');
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
