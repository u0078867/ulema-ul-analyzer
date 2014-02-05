%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = DJCGUI(varargin)
% DJCGUI M-file for DJCGUI.fig
%      DJCGUI, by itself, creates a new DJCGUI or raises the existing
%      singleton*.
%
%      H = DJCGUI returns the handle to a new DJCGUI or the handle to
%      the existing singleton*.
%
%      DJCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DJCGUI.M with the given input arguments.
%
%      DJCGUI('Property','Value',...) creates a new DJCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DJCGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DJCGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DJCGUI

% Last Modified by GUIDE v2.5 07-May-2012 16:47:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DJCGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DJCGUI_OutputFcn, ...
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


% --- Executes just before DJCGUI is made visible.
function DJCGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DJCGUI (see VARARGIN)

% Set table properties and data
DJCList = varargin{1}.DJCList;
bodyModel = varargin{1}.bodyModel;
selJointsInd = varargin{1}.selJointsInd;
allSegments = GetAllSegments(bodyModel, selJointsInd); 
set(handles.DJCTable,'ColumnName',{'Segment 1:','Segment 2:','Dynamic trial:','Assign to (*):','Method:'});
set(handles.DJCTable,'ColumnFormat',{[allSegments, {' '}],[allSegments, {' '}],'char','char',{'Gamage', ' '}});
set(handles.DJCTable,'Data',DJCList); 
set(handles.DJCTable,'ColumnEditable',[true, true, true, true, true]);

% Choose default command line output for DJCGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DJCGUI wait for user response (see UIRESUME)
uiwait;


% --- Outputs from this function are returned to the command line.
function varargout = DJCGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles)
    close(hObject);
    varargout{1} = handles.out;
else
    varargout{1} = [];
end    


% --- Executes on button press in closeWinButt.
function closeWinButt_Callback(hObject, eventdata, handles)
% hObject    handle to closeWinButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.out = get(handles.DJCTable,'Data');
guidata(hObject, handles);
uiresume;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
