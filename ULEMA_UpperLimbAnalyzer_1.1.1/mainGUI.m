%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = mainGUI(varargin)
% MAINGUI M-file for mainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainGUI

% Last Modified by GUIDE v2.5 18-Nov-2013 16:04:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @mainGUI_OutputFcn, ...
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


% --- Executes just before mainGUI is made visible.
function mainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainGUI (see VARARGIN)

handles.LoadsOptsList = {'WarnDuplSSMenu', 'NoWarnDuplSSMenu'};
% Create waitbar
h = waitbar(0,'Setting software path...');
% Automatically set the path to UZPellGUI (sub)folders
thisSoftwarePath = genpath(pwd);
addpath(thisSoftwarePath,'-end');
handles.origPath = path;
% Get all available engines
handles.enginesInfo = eGetAllEngines(pwd);
enginesList = {handles.enginesInfo.name};
set(handles.enginesPopup, 'String', enginesList);
handles.engineIndex = 1;
waitbar(1/4,h,'Selecting correct BTK folder...');
% Descard the BTK subfolders that aren't relative to the current operating system
osInfo = computer;
fprintf('\n\nOperative system: %s\n\n', osInfo);
switch osInfo
    case 'PCWIN64'
        handles.currPath{1} = rmTreeFromPath(handles.origPath, 'BTK_WinXP_32bit');
        path(handles.currPath{1});
    case 'PCWIN'
        handles.currPath{1} = rmTreeFromPath(handles.origPath, 'BTK_Win7_64bit');
        path(handles.currPath{1});
    otherwise
        uiwait(warndlg('No BTK package detected for current operative system! It will be impossible to write data back to C3D.'));
        set(handles.ExportC3DSSMenu,'Enable','off');
        handles.currPath{1} = [];
end
waitbar(2/4,h,'Setting engine path...');
% Keep in the path only (sub)folders relative to the selected engine
if length(handles.enginesInfo) > 1
    engineIndicesToRemove = 1:length(handles.enginesInfo);
    engineIndicesToRemove(handles.engineIndex) = [];
    handles.currPath{2} = handles.currPath{1};
    for i = 1 : length(engineIndicesToRemove)
        handles.currPath{2} = rmTreeFromPath(handles.currPath{2}, handles.enginesInfo(engineIndicesToRemove(i)).name );
    end
    path(handles.currPath{2});
end

waitbar(3/4,h,'GUI initialization...');
% Parameters initialisation
handles.sectionsToComp.rawDataRead = 0;
set(handles.rawDataReadOptsButt,'Enable','off')
handles.sectionsToComp.kine = 0;
set(handles.kineOptsButt,'Enable','off')
handles.sectionsToComp.seg = 0;
set(handles.segOptsButt,'Enable','off')
handles.sectionsToComp.bestCy = 0;
set(handles.bestCyOptsButt,'Enable','off')
handles.sectionsToComp.cliPars = 0;
set(handles.cliParsOptsButt,'Enable','off')
handles.sectionsToComp.expC3D = 0;
handles = managePanelContent(handles, 'expC3DPanel', 'off');
handles.sectionsToComp.refData = 0;
handles = managePanelContent(handles, 'refDataPanel', 'off');
handles.sectionsToComp.expCSV = 0;
handles = managePanelContent(handles, 'expCSVPanel', 'off');
handles.sectionsToComp.expXML = 0;
handles = managePanelContent(handles, 'expXMLPanel', 'off');
handles.sectionsToComp.expXMLRefData = 0;
handles = managePanelContent(handles, 'expXMLRefDataPanel', 'off');
handles.forceDataOverwriting = 0;
handles.savePath = [];
handles.lastUsedDir = [];
handles.recoveryPath = [];
handles.splitProcDataLevels = {'session'};
handles.procDataSavingList = {'ProcDataSavingOverSSSMenu','ProcDataSavingSafeMerSSSMenu'};
%---
handles.export.RefData.refDataPath = [];
handles.export.RefData.outRefFile = 'MyRefFile';
handles.export.RefData.sidesForRefData = 4;
handles.export.C3D.saveToNewC3D = 0;
handles.export.CSV.CSVPath = [];
handles.export.CSV.saveTrCSV = 1;
handles.export.CSV.saveSesCSV = 1;
handles.export.CSV.expMovSideDataOnly = 1;
handles.export.XML.XMLPath = [];
handles.export.XML.saveBestCyXML = 1;
handles.export.XMLRefData.inFileFolder = [];
handles.export.XMLRefData.inFileName = 'MyRefFile';
handles.export.XMLRefData.outFileFolder = [];
handles.export.XMLRefData.outFileName = 'MyRefFile';
handles.export.XMLRefData.keepOnlyMeanStd = 1;
handles.export.General.cacheSubData = 1;
%---
handles.refFile = [];
handles.refFileData = [];
handles.refFileSubNames = {' '};
handles.subNames = {};
handles.ageMatch = {};
handles.currentSession = 1;
handles.calPrefix = 'cal';
handles.trDB.subjects = struct([]);
handles.trToUseDB.subjects = struct([]);
handles.trToUseDBNew.subjects = struct([]);
%---
handles.selectedProt = 1;
handles.defaultStpPointsN = 10;
handles.defaultPhasesN = 10;
handles.defaultTaskPrefixN = 200;
handles.defaultAnglesListN = 50;
handles.defaultSubMatchN = 50;
handles.defaultContextsN = 10;
%---
handles.cliPars.subMatch.Data = {};
handles.cliPars.refFile.String = '';
handles.cliPars.refFileSubNames = {};
handles.cliPars.refFileData = {};
%---
handles.bodyModelsFolder = fullfile(pwd,'BodyModels');
handles.kineCalcFolder = fullfile(pwd,'AnatCalcs');
handles.pointersFolder = fullfile(pwd,'Pointers');
% Load DB or create a new one
handles.protDBpath = fullfile(pwd,'Prot','ProtDB.mat');
if exist(handles.protDBpath,'file')
    handles.protDB = load(handles.protDBpath);
    handles = initProtocolsList(handles);
else % ProdDB.mat does not exist
    handles.protDB.protList = struct([]);
    createProtButt_Callback(hObject, '', handles);
    handles = saveNewProtToFile(handles);
    protDB = handles.protDB;
    save(handles.protDBpath,'-struct','protDB');
end
% Compile segmentation methods list
handles.evConfig = parseConfigFile('EventsConfig.txt',{'Segmentation'},{'Method'});
metList = {};
for i = 1 : length(handles.evConfig)
    metList{i} = num2str(handles.evConfig{i}.method);
end
guidata(hObject, handles);
% Set reference data calculation type to "Mix right and left side"
set(handles.sidesForRefDataPopup,'Value',4);
% Init BodyMech
InitBodyMech
% Copy current content of the protocol internally
handles = updateProtocolInfo(handles);
% Close waitbar
disp('win initialized')
waitbar(1,h,'Finished');
close(h);

% Choose default command line output for mainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes mainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadFileStructButt.
function loadFileStructButt_Callback(hObject, eventdata, handles)
% hObject    handle to loadFileStructButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on selection change in subjectsList.
function subjectsList_Callback(hObject, eventdata, handles)
% hObject    handle to subjectsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subjectsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subjectsList

if ~isempty(handles.trDB.subjects)
    selectedIndex = get(hObject,'Value');
    itemsList = get(handles.subjectsList,'String');
    handles.currentSubject = itemsList{selectedIndex};
    sessionsList = getVirtualDBNames(handles.trDB, {handles.currentSubject}, 'sessions', {});
    set(handles.sessionsList,'String',sessionsList);
    set(handles.sessionsList,'Value',1);
    guidata(hObject, handles);
    sessionsList_Callback(handles.sessionsList,'',handles);
end


% --- Executes during object creation, after setting all properties.
function subjectsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sessionsList.
function sessionsList_Callback(hObject, eventdata, handles)
% hObject    handle to sessionsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sessionsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sessionsList

if ~isempty(handles.trDB.subjects)
    itemsList = get(hObject,'String');
    if ~isempty(itemsList)
        selectedIndex = get(hObject,'Value');
        handles.currentSession = itemsList{selectedIndex};
%         % Getting only the files related to anatomical landamrks calibration
%         allJoints = get(handles.wantedJointsList,'String');
%         selJointsInd = get(handles.wantedJointsList,'Value');
%         BodyMechFuncHeader
%         s = get(handles.bodyModelPopup,'String');
%         l = get(handles.bodyModelPopup,'Value');
%         bodyModel = s{l};
%         eval(bodyModel);
%         DeleteUnusedSegments(allJoints(selJointsInd));
%         anatMarkers = {};
%         for i =  1 : length(BODY.SEGMENT)
%             for j = 1 : length(BODY.SEGMENT(i).AnatomicalLandmark)
%                 anatMarkers{end+1} = BODY.SEGMENT(i).AnatomicalLandmark(j).Name;
%             end
%         end
%         anatMarkers = unique(anatMarkers);
%         for i = 1 : length(anatMarkers)
%             filesToExclude{i} = [handles.calPrefix, anatMarkers{i}, '.c3d'];
%         end
%         trialsList = getVirtualDBNames(handles.trDB, {handles.currentSubject, handles.currentSession}, 'trials', filesToExclude);
        trialsList = getVirtualDBNames(handles.trDB, {handles.currentSubject, handles.currentSession}, 'trials', {});
        set(handles.trialsList, 'String', trialsList);
        set(handles.trialsList, 'Value', 1);
        if ~isempty(trialsList)
            set(handles.linkProtToSubButt,'Enable','on');
            set(handles.unlinkProtToSubButt,'Enable','on');
            set(handles.linkProtToSesButt,'Enable','on');
            set(handles.unlinkProtToSesButt,'Enable','on');
            set(handles.linkProtToTrButt,'Enable','on');
            set(handles.unlinkProtToTrButt,'Enable','on');
        else
            set(handles.trialsList,'String', {});
            set(handles.linkProtToSubButt,'Enable','off');
            set(handles.unlinkProtToSubButt,'Enable','off');
            set(handles.linkProtToSesButt,'Enable','off');
            set(handles.unlinkProtToSesButt,'Enable','off');
            set(handles.linkProtToTrButt,'Enable','off');
            set(handles.unlinkProtToTrButt,'Enable','off');
            disp('No trials');
        end
    else
        set(hObject,'String', {});
        set(handles.trialsList,'String', {});
        set(handles.linkProtToSubButt,'Enable','off');
        set(handles.unlinkProtToSubButt,'Enable','off');
        set(handles.linkProtToSesButt,'Enable','off');
        set(handles.unlinkProtToSesButt,'Enable','off');
        set(handles.linkProtToTrButt,'Enable','off');
        set(handles.unlinkProtToTrButt,'Enable','off');
        disp('No sessions');
    end
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function sessionsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in trialsList.
function trialsList_Callback(hObject, eventdata, handles)
% hObject    handle to trialsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns trialsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trialsList


% --- Executes during object creation, after setting all properties.
function trialsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in protocolsList.
function protocolsList_Callback(hObject, eventdata, handles)
% hObject    handle to protocolsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns protocolsList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from protocolsList

l = get(hObject,'String');
selectedProtString = l{handles.selectedProt};
if handles.selectedProt ~= get(hObject,'Value') && selectedProtString(end) == '*'
    % if you change selected protocol without seving the highlithed one
    nextSelection = get(hObject,'Value'); 
    set(hObject,'Value',handles.selectedProt);
    choice = questdlg('Do you want to save this protocol?','Yes','No');
    switch choice
        case 'Yes'
            % Saving
            handles = saveNewProtToFile(handles);
            fprintf('\nNew protocl saved\n');
        otherwise
            fprintf('\nProtocol not saved\n');
    end
    % Erasing '*' after protocol ID number in the list
    l = get(hObject,'String');
    i = get(hObject,'Value');
    l{i} = strrep(l{i},' *','');
    % Updating (if necessary) the new name of the current protocol
    l{i} = handles.protDB.protList(i).protName;
    % Update the protocols list
    set(hObject,'String',l);
    % Now you can jump to the next selected protocol
    set(hObject,'Value',nextSelection);
    % Enable "Create new protocol" and "Delete protocol from list"
    set(handles.createProtButt,'Enable','on');
    set(handles.copyProtButt,'Enable','on');
    set(handles.deleteProtButt,'Enable','on');
end
% Update the selected protocol
handles.selectedProt = get(hObject,'Value');
% Update GUI with protocol information.
handles = updateProtocolInfo(handles);
% Get list of all markers and update the list of point in the ST parameter table for points
guidata(hObject,handles);


% --- Executes on button press in noSaveProtButt.
function noSaveProtButt_Callback(hObject, eventdata, handles)
% hObject    handle to noSaveProtButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

l = get(handles.protocolsList,'String');
selectedProtString = l{handles.selectedProt};
if selectedProtString(end) == '*'
    fprintf('\nProtocol not saved\n');
    % Erasing '*' after protocol ID number in the list
    l = get(handles.protocolsList,'String');
    i = get(handles.protocolsList,'Value');
    l{i} = strrep(l{i},' *','');
    % Updating (if necessary) the new name of the current protocol
    l{i} = handles.protDB.protList(i).protName;
    % Update the protocols list
    set(handles.protocolsList,'String',l);
    % Enable "Create new protocol" and "Delete protocol from list" and the
    % up and down arrows
    set(handles.createProtButt,'Enable','on');
    set(handles.copyProtButt,'Enable','on');
    set(handles.deleteProtButt,'Enable','on');
    set(handles.protUpButt,'Enable','on');
    set(handles.protDoButt,'Enable','on');
end
% Update the selected protocol
handles.selectedProt = get(handles.protocolsList,'Value');
% Update GUI with protocol information.
handles = updateProtocolInfo(handles);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function protocolsList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocolsList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function protocolDEdit_Callback(hObject, eventdata, handles)
% hObject    handle to protocolDEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of protocolDEdit as text
%        str2double(get(hObject,'String')) returns contents of protocolDEdit as a double


% --- Executes during object creation, after setting all properties.
function protocolDEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocolDEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createProtButt.
function createProtButt_Callback(hObject, eventdata, handles)
% hObject    handle to createProtButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = setGUIforNewProt(handles);
handles.selectedProt = get(handles.protocolsList,'Value');
handles = saveNewProtToFile(handles);
guidata(hObject, handles);

% --- Executes on button press in deleteProtButt.
function deleteProtButt_Callback(hObject, eventdata, handles)
% hObject    handle to deleteProtButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

choice = questdlg('Do you want to delete this protocol?','Protocol','Yes','No');
switch choice
    case 'Yes'
        handles = deleteProtocol(handles);
        protocolsList_Callback(handles.protocolsList,'',handles);
end
guidata(hObject, handles);


% --- Executes on button press in linkProtToTrButt.
function linkProtToTrButt_Callback(hObject, eventdata, handles)
% hObject    handle to linkProtToTrButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = num2str([get(handles.protToTrCurSessRadio,'Value'), ...
        get(handles.protToTrAllSessRadio,'Value'), ...
        get(handles.protToTrAllSubjRadio,'Value')]);
switch str
    case '1  0  0'
        handles = appDelProtToTrial(handles, 'trial', 1);
    case '0  1  0'
        handles = appDelProtToTrial(handles, 'trialsAllSes', 1);
    case '0  0  1'
        handles = appDelProtToTrial(handles, 'trialsAllSub', 1);
end
sessionsList_Callback(handles.sessionsList, '', handles);
guidata(hObject, handles);

% --- Executes on button press in linkProtToSesButt.
function linkProtToSesButt_Callback(hObject, eventdata, handles)
% hObject    handle to linkProtToSesButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = appDelProtToTrial(handles, 'session', 1);
sessionsList_Callback(handles.sessionsList, '', handles);
guidata(hObject, handles);


% --- Executes on button press in linkProtToSubButt.
function linkProtToSubButt_Callback(hObject, eventdata, handles)
% hObject    handle to linkProtToSubButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = appDelProtToTrial(handles, 'subject', 1);
sessionsList_Callback(handles.sessionsList, '', handles);
guidata(hObject, handles);


% --- Executes on button press in saveProtButt.
function saveProtButt_Callback(hObject, eventdata, handles)
% hObject    handle to saveProtButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = saveNewProtToFile(handles);
guidata(hObject, handles);

% --- Executes on button press in runButt.
function runButt_Callback(hObject, eventdata, handles)
% hObject    handle to runButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in unlinkProtToSesButt.
function unlinkProtToSesButt_Callback(hObject, eventdata, handles)
% hObject    handle to unlinkProtToSesButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = appDelProtToTrial(handles, 'session', 0);
sessionsList_Callback(handles.sessionsList, '', handles);
guidata(hObject, handles);


% --- Executes on button press in unlinkProtToSubButt.
function unlinkProtToSubButt_Callback(hObject, eventdata, handles)
% hObject    handle to unlinkProtToSubButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = appDelProtToTrial(handles, 'subject', 0);
sessionsList_Callback(handles.sessionsList, '', handles);
guidata(hObject, handles);


% --- Executes on button press in unlinkProtToTrButt.
function unlinkProtToTrButt_Callback(hObject, eventdata, handles)
% hObject    handle to unlinkProtToTrButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = num2str([get(handles.protToTrCurSessRadio,'Value'), ...
        get(handles.protToTrAllSessRadio,'Value'), ...
        get(handles.protToTrAllSubjRadio,'Value')]);
switch str
    case '1  0  0'
        handles = appDelProtToTrial(handles, 'trial', 0);
    case '0  1  0'
        handles = appDelProtToTrial(handles, 'trialsAllSes', 0);
    case '0  0  1'
        handles = appDelProtToTrial(handles, 'trialsAllSub', 0);
end
sessionsList_Callback(handles.sessionsList, '', handles);
guidata(hObject, handles);


% --- Executes on button press in refFileButt.
function refFileButt_Callback(hObject, eventdata, handles)
% hObject    handle to refFileButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.trDB.subjects)
    msg{1} = 'Load subject first!';
    msg{2} = '(File -> Load)';
    warndlg(msg,'');
    return
end
[filename, pathname] = uigetfile('*.mat', 'Choose the reference data MAT file',pwd);
if ~isempty(filename) && filename(1) ~= 0
    % Load ref data
    handles.refFile = [pathname, filename];
    handles.refFileData = load(handles.refFile);
    % Get list of all subjects names
    handles.refDataFormat = refDataFormatRecognizer(handles.refFileData);
    fprintf('\n\nFormat of the ref file: %s\n\n', handles.refDataFormat);
    handles.refFileSubNames = refDataSubList(handles.refFileData, handles.refDataFormat);
    handles.refFileSubNames = [handles.refFileSubNames, {' '}];
    % Put that list of names in the age match table
    set(handles.ageMatchTable,'ColumnFormat',{handles.subNames,handles.refFileSubNames});
    % Show file name
    set(handles.refFileString,'String',filename);
end
guidata(hObject, handles);


% --- Executes when selected object is changed in expC3DDestPanel.
function expC3DDestPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in expC3DDestPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if get(handles.saveToNewC3DRadio,'Value')
    handles.export.C3D.saveToNewC3D = 1;
else
    handles.export.C3D.saveToNewC3D = 0;
end
guidata(hObject, handles);


% --- Executes on button press in copyProtButt.
function copyProtButt_Callback(hObject, eventdata, handles)
% hObject    handle to copyProtButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = setGUIforCopiedProt(handles);
handles.selectedProt = length(handles.protDB.protList);
handles = saveNewProtToFile(handles);
guidata(hObject, handles);



% --- Executes on selection change in sidesForRefDataPopup.
function sidesForRefDataPopup_Callback(hObject, eventdata, handles)
% hObject    handle to sidesForRefDataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sidesForRefDataPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sidesForRefDataPopup

handles.export.RefData.sidesForRefData = get(hObject,'Value');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sidesForRefDataPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sidesForRefDataPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outRefFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to outRefFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outRefFileEdit as text
%        str2double(get(hObject,'String')) returns contents of outRefFileEdit as a double

handles.export.RefData.outRefFile = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function outRefFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outRefFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function protNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to protNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of protNameEdit as text
%        str2double(get(hObject,'String')) returns contents of protNameEdit as a double

handles.protName = get(hObject,'String');
handles = editProtocolParam(handles, 'protocol');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function protNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in enginesPopup.
function enginesPopup_Callback(hObject, eventdata, handles)
% hObject    handle to enginesPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns enginesPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from enginesPopup

handles.engineIndex = get(hObject, 'Value');
% Keep in the path only (sub)folders relative to the selecte path
if length(handles.enginesInfo) > 1
    engineIndicesToRemove = 1:length(handles.enginesInfo);
    engineIndicesToRemove(handles.engineIndex) = [];
    handles.currPath{2} = handles.currPath{1};
    for i = 1 : length(engineIndicesToRemove)
        handles.currPath{2} = rmTreeFromPath(handles.currPath{2}, handles.enginesInfo(engineIndicesToRemove(i)).name );
    end
    path(handles.currPath{2});
end


% --- Executes during object creation, after setting all properties.
function enginesPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enginesPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ProcessingMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessingMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SectionsSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SectionsSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OptionsSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OptionsSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function LoadC3DSbjSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadC3DSbjSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadStructInGUI(handles, 'c3d', 'tree', 'singleSubject');
subjectsList_Callback(handles.subjectsList, '', handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function LoadC3DSbjGroupSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadC3DSbjGroupSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadStructInGUI(handles, 'c3d', 'tree', 'groupSubjects');
subjectsList_Callback(handles.subjectsList, '', handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function LoadMATSingleFileSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMATSingleFileSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadStructInGUI(handles, 'mat', [], 'singleFile');
subjectsList_Callback(handles.subjectsList, '', handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function LoadMATTree1SSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMATTree1SSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadStructInGUI(handles, 'mat', [], 'filesInTree1');
subjectsList_Callback(handles.subjectsList, '', handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function LoadMATTree2SSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMATTree2SSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadStructInGUI(handles, 'mat', [], 'filesInTree2');
subjectsList_Callback(handles.subjectsList, '', handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function LoadMATTree3SSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMATTree3SSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = loadStructInGUI(handles, 'mat', [], 'filesInTree3');
subjectsList_Callback(handles.subjectsList, '', handles);
guidata(hObject, handles);

% --------------------------------------------------------------------
function WarnDuplSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to WarnDuplSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = menuMutualSel(handles, handles.LoadsOptsList, get(hObject,'Tag'));
guidata(hObject, handles);

% --------------------------------------------------------------------
function DelStructSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to DelStructSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.trDB.subjects = struct([]);
handles.trToUseDB.subjects = struct([]);
handles.trToUseDBNew.subjects = struct([]);
set(handles.subjectsList, 'String', {' '});
set(handles.subjectsList, 'Value', 1);
set(handles.sessionsList, 'String', {' '});
set(handles.sessionsList, 'Value', 1);
set(handles.trialsList, 'String', {' '});
set(handles.trialsList, 'Value', 1);
guidata(hObject, handles);


% --------------------------------------------------------------------
function ForceDataOverSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ForceDataOverSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   handles.forceDataOverwriting = 1;
   set(hObject,'Checked','on');
else
   handles.forceDataOverwriting = 0;
   set(hObject,'Checked','off');
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function RawDataReadingSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to RawDataReadingSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   set(handles.rawDataReadOptsButt,'Enable','on')
   handles.sectionsToComp.rawDataRead = 1;
   set(hObject,'Checked','on');
else
   set(handles.rawDataReadOptsButt,'Enable','off')
   handles.sectionsToComp.rawDataRead = 0;
   set(hObject,'Checked','off');
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function KinematicsSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to KinematicsSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   set(handles.kineOptsButt,'Enable','on')
   handles.sectionsToComp.kine = 1;
   set(hObject,'Checked','on');
else
   set(handles.kineOptsButt,'Enable','off')
   handles.sectionsToComp.kine = 0;
   set(hObject,'Checked','off');
end
guidata(hObject, handles);



% --------------------------------------------------------------------
function SegmentationSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SegmentationSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   set(handles.segOptsButt,'Enable','on')
   handles.sectionsToComp.seg = 1;
   set(hObject,'Checked','on');
else
   set(handles.segOptsButt,'Enable','off')
   handles.sectionsToComp.seg = 0;
   set(hObject,'Checked','off');
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function BestCySSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to BestCySSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   set(handles.bestCyOptsButt,'Enable','on')
   handles.sectionsToComp.bestCy = 1;
   set(hObject,'Checked','on');
else
   set(handles.bestCyOptsButt,'Enable','off')
   handles.sectionsToComp.bestCy = 0;
   set(hObject,'Checked','off');
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function ClinParsSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ClinParsSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   set(handles.cliParsOptsButt,'Enable','on')
   handles.sectionsToComp.cliPars = 1;
   set(hObject,'Checked','on')
else
   set(handles.cliParsOptsButt,'Enable','off')
   handles.sectionsToComp.cliPars = 0;
   set(hObject,'Checked','off')
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function ExportC3DSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to export.C3DSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   handles = managePanelContent(handles, 'expC3DPanel', 'on');
   handles.sectionsToComp.expC3D = 1;
   set(hObject,'Checked','on')
else
   handles = managePanelContent(handles, 'expC3DPanel', 'off');
   handles.sectionsToComp.expC3D = 0;
   set(hObject,'Checked','off')
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function RefDataSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to RefDataSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   handles = managePanelContent(handles, 'refDataPanel', 'on');
   handles.sectionsToComp.refData = 1;
   set(hObject,'Checked','on')
else
   handles = managePanelContent(handles, 'refDataPanel', 'off');
   handles.sectionsToComp.refData = 0;
   set(hObject,'Checked','off')
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function ExportCSVSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to export.CSVSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   handles = managePanelContent(handles, 'expCSVPanel', 'on');
   handles.sectionsToComp.expCSV = 1;
   set(hObject,'Checked','on')
else
   handles = managePanelContent(handles, 'expCSVPanel', 'off');
   handles.sectionsToComp.expCSV = 0;
   set(hObject,'Checked','off')
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function ExportXMLSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ExportXMLSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   handles = managePanelContent(handles, 'expXMLPanel', 'on');
   handles.sectionsToComp.expXML = 1;
   set(hObject,'Checked','on')
else
   handles = managePanelContent(handles, 'expXMLPanel', 'off');
   handles.sectionsToComp.expXML = 0;
   set(hObject,'Checked','off')
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function LoadOptsSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadOptsSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ToolsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ToolsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function MemViewSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to MemViewSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Run memory manager
mm


% --------------------------------------------------------------------
function NoWarnDuplSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to NoWarnDuplSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = menuMutualSel(handles, handles.LoadsOptsList, get(hObject,'Tag'));
guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel14.
function uipanel14_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel14 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RunSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to RunSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

N = 19;
withPause = 0;
pauseTime = 0.5;
cont = 0;
% Check if there is no sections to computed indicated
cont = cont + 1;
h = waitbar(cont/N,'Check n. of active sections...');
fn = fieldnames(handles.sectionsToComp);
sectionsToCompN = 0;
for i = 1 : length(fn)
    sectionsToCompN = sectionsToCompN + handles.sectionsToComp.(fn{i});
end
if sectionsToCompN == 0
    cellMsg{1} = 'You must specify at least one section to compute';
    cellMsg{2} = '(Processing -> Sections -> ...)';
    uiwait(errordlg(cellMsg, ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end
% Force the user to select at least on type of processed data saving
cont = cont + 1;
waitbar(cont/N,h,'Check data saving type...');
if isempty(handles.splitProcDataLevels)
    cellMsg{1} = 'You must specify at least one type of processed data saving';
    cellMsg{2} = '(Processing -> Options -> Split proc. data into .mat files for -> ...)';
    uiwait(errordlg(cellMsg, ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end
% Force the user to specify a path for data under processing
cont = cont + 1;
waitbar(cont/N,h,'Check if save path is set...');
if isempty(handles.savePath)
    if handles.sectionsToComp.rawDataRead || handles.sectionsToComp.kine || handles.sectionsToComp.seg || handles.sectionsToComp.bestCy || handles.sectionsToComp.cliPars 
        cellMsg{1} = 'You must specify a folder for processed data';
        cellMsg{2} = '(Processing -> Options -> Set proc. data path)';
        uiwait(errordlg(cellMsg, ''));
        close(h);
        return
    end
end
if withPause == 1
    pause(pauseTime);
end
% Check if reference data has to be loaded
cont = cont + 1;
waitbar(cont/N,h,'Check if reference data has to be loaded...');
if handles.sectionsToComp.cliPars && isempty(handles.cliPars.refFileData)
    uiwait(errordlg('Choose the reference data file!', ''));
    close(h);
    return
end 
if withPause == 1
    pause(pauseTime);
end
% Check if save path for reference data is set
cont = cont + 1;
waitbar(cont/N,h,'Check save path for reference data...');
if handles.sectionsToComp.refData && isempty(handles.export.RefData.refDataPath)
    uiwait(errordlg('Choose a reference data path!', ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end
% Check if name for reference data file is empty
cont = cont + 1;
waitbar(cont/N,h,'Check file name for reference data...');
if handles.sectionsToComp.refData && isempty(handles.export.RefData.outRefFile)
    uiwait(errordlg('Enter the name of reference data file!', ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end    
% Check if folder path for input reference file (XML exportation) is empty
cont = cont + 1;
waitbar(cont/N,h,'Check path for input reference file (XML exportation)...');
if handles.sectionsToComp.expXMLRefData && isempty(handles.export.XMLRefData.inFileFolder)
    uiwait(errordlg('Choose folder path for input reference file (XML exportation)!', ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end  
% Check if name for for input reference file (XML conversion) is empty
cont = cont + 1;
waitbar(cont/N,h,'Check file name for input reference data (XML exportation)...');
if handles.sectionsToComp.expXMLRefData && isempty(handles.export.XMLRefData.inFileName)
    uiwait(errordlg('Enter the name of input reference data file (XML exportation)!', ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end 
% Check if folder path for output reference file (XML exportation) is empty
cont = cont + 1;
waitbar(cont/N,h,'Check path for output reference file (XML exportation)...');
if handles.sectionsToComp.expXMLRefData && isempty(handles.export.XMLRefData.outFileFolder)
    uiwait(errordlg('Choose folder path for output reference file (XML exportation)!', ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end  
% Check if name for for output reference file (XML conversion) is empty
cont = cont + 1;
waitbar(cont/N,h,'Check file name for output reference data (XML exportation)...');
if handles.sectionsToComp.expXMLRefData && isempty(handles.export.XMLRefData.outFileName)
    uiwait(errordlg('Enter the name of output reference data file (XML exportation)!', ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end  
% Check if save path for CSV exported data is set
cont = cont + 1;
waitbar(cont/N,h,'Check save path for CSV exported data...');
if handles.sectionsToComp.expCSV && isempty(handles.export.CSV.CSVPath)
    uiwait(errordlg('Choose CSV data path!', ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end
% Check if save path for XML exported data is set
cont = cont + 1;
waitbar(cont/N,h,'Check save path for XML exported data...');
if handles.sectionsToComp.expXML && isempty(handles.export.XML.XMLPath)
    uiwait(errordlg('Choose XML data path!', ''));
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end
% Delete all the empty substructures in handles.trDB, i.e., keep only 
% the trials with an associated protocol
cont = cont + 1;
waitbar(cont/N,h,'Select trials to (re)process...');
trToUseDB = delEmptyStructsInVirtualDB(handles.trDB);
if withPause == 1
    pause(pauseTime);
end
% Update trial paths of trToUseDB with the new one previously computed (if present)
cont = cont + 1;
waitbar(cont/N,h,'Update trial paths from prev. computations...');
trToUseDB = updateVirtualDBStruct(trToUseDB, handles.trToUseDBNew, {'path','subPath'});
trToUseDBOrig = updateVirtualDBStruct(trToUseDB, handles.trToUseDBNew, {'path','subPath','protocolData','protocolID'});
if withPause == 1
    pause(pauseTime);
end
% Check if there are some protocol IDs in trToUseDB that cannot be found in
% protocols list of the GUI. In that case, there can be 2 options:
% - some protocols renaming was done without relinking that protocol to the
% trials;
% - one of more .mat files were loaded and the protocols used to processs
% them is not in the list anymore.
% If one of the two cases above is verified, stop. Otherwise, create the
% protocolData field
cont = cont + 1;
waitbar(cont/N,h,'Check protocols existance...');
[trToUseDB, ok] = checkProtocolsExistance(trToUseDB, trToUseDBOrig, handles.protDB.protList);
if ok == 0
    close(h);
    return
end
pause(pauseTime);
% Check if, for the protocolsData field in trToUseDB, the protocol
% content is the same of the corresponding protocol in the protocols list
% of the GUI. If no, ask which protocol to keep
cont = cont + 1;
waitbar(cont/N,h,'Check protocols consistency...');
[trToUseDB, ok] = checkProtocolsConsistency(trToUseDB, trToUseDBOrig, handles.protDB.protList, handles.sectionsToComp, handles.forceDataOverwriting);
if ok == 0
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end
% Check if recovery path is required or not. It is necessary to input also 
% a copy of the trToUseDB that contains the original protocol content used
% for processing the data (in case of .mat file). This is trToUseDBOrig
cont = cont + 1;
waitbar(cont/N,h,'Check recovery path need (could take some time)...');
ok = checkRecoveryPathNeed(trToUseDB, trToUseDBOrig, handles.sectionsToComp, handles.recoveryPath, handles.forceDataOverwriting);
if ok == 0
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end
% Check that all the trials of the same session have the same session settings
cont = cont + 1;
waitbar(cont/N,h,'Check protocols equality for some session...');
ok = checkSameProtForSameSes(handles.trToUseDB, handles.sectionsToComp);
if ok == 0
    close(h);
    return
end
if withPause == 1
    pause(pauseTime);
end
% Check that all unprocessed trials have path to c3d files that really 
% exists on the HD (only for C3D loading)
% #TO DO
% Get the latest data about subjects match from the table for MAP computation
cont = cont + 1;
waitbar(cont/N,h,'Read subjects match for MAP...');
subMatch = cleanTableFromEmptyLines(handles.cliPars.subMatch.Data); % Version cleaned from epmty rows
if withPause == 1
    pause(pauseTime);
end
% Run processing
close(h);
if strcmp(get(handles.ProcDataSavingOverSSSMenu,'Checked'),'on')
    handles.procDataSaving = 'overwrite';
else
    handles.procDataSaving = 'safe_merge';
end
handles.trToUseDBNew = runProcessing(handles.enginesInfo, handles.engineIndex, handles.lastUsedDir, handles.recoveryPath, handles.savePath, handles.protDB, handles.sectionsToComp, handles.evConfig, trToUseDB, handles.trDB, handles.export, subMatch, handles.cliPars.refFileData, handles.forceDataOverwriting, handles.splitProcDataLevels, handles.procDataSaving);
guidata(hObject, handles);

% --------------------------------------------------------------------
function SetRecoveryPathSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SetRecoveryPathSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir = uigetdir(handles.recoveryPath,'Select path');
if ~isempty(dir) && dir(1) ~= 0
    handles.recoveryPath = dir;
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function LoadSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SetProcDataPathSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SetProcDataPathSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir = uigetdir(handles.savePath,'Select path');
if ~isempty(dir) && dir(1) ~= 0
    handles.savePath = dir;
end
guidata(hObject, handles);

% --- Executes on button press in refFilePathButt.
function refFilePathButt_Callback(hObject, eventdata, handles)
% hObject    handle to refFilePathButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir = uigetdir(handles.export.RefData.refDataPath,'Select path');
if ~isempty(dir) && dir(1) ~= 0
    handles.export.RefData.refDataPath = dir;
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function expC3DDestPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expC3DDestPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in CSVPathButt.
function CSVPathButt_Callback(hObject, eventdata, handles)
% hObject    handle to CSVPathButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir = uigetdir(handles.export.CSV.CSVPath,'Select path');
if ~isempty(dir) && dir(1) ~= 0
    handles.export.CSV.CSVPath = dir;
end
guidata(hObject, handles);


% --- Executes on button press in saveTrCSVCheck.
function saveTrCSVCheck_Callback(hObject, eventdata, handles)
% hObject    handle to saveTrCSVCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveTrCSVCheck

if get(hObject,'Value')
    handles.export.CSV.saveTrCSV = 1;
else
    handles.export.CSV.saveTrCSV = 0;
end
guidata(hObject, handles);


% --- Executes on button press in saveSesCSVCheck.
function saveSesCSVCheck_Callback(hObject, eventdata, handles)
% hObject    handle to saveSesCSVCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveSesCSVCheck

if get(hObject,'Value')
    handles.export.CSV.saveSesCSV = 1;
else
    handles.export.CSV.saveSesCSV = 0;
end
guidata(hObject, handles);


% --- Executes on button press in cacheSubDataCheck.
function cacheSubDataCheck_Callback(hObject, eventdata, handles)
% hObject    handle to cacheSubDataCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cacheSubDataCheck

if get(hObject,'Value')
    handles.export.General.cacheSubData = 1;
else
    handles.export.General.cacheSubData = 0;
end
guidata(hObject, handles);



% --------------------------------------------------------------------
function DeleteSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DelSingleSubSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to DelSingleSubSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.trDB.subjects)
    allSubs = get(handles.subjectsList,'String');
    currSubInd = get(handles.subjectsList,'Value');
    currSubName = allSubs{currSubInd};
    ind = strcmp({handles.trDB.subjects.name},currSubName);
    handles.trDB.subjects(ind) = [];
    if ~isempty(handles.trDB.subjects)
        allSubs(ind) = [];
        set(handles.subjectsList,'String',allSubs);
        if currSubInd > length(allSubs)
            currSubInd = currSubInd - 1;
        end
        handles.currentSubject = allSubs{currSubInd};
        guidata(hObject, handles);
        set(handles.subjectsList,'Value',currSubInd);
        subjectsList_Callback(handles.subjectsList, '', handles);
    else
        DelStructSSMenu_Callback(handles.DelStructSSMenu, '', handles);
    end
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function ClearRecoveryPathSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ClearRecoveryPathSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.recoveryPath = [];
guidata(hObject, handles);


% --------------------------------------------------------------------
function SplitProcDataSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SplitProcDataSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SplitProcDataSubSSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SplitProcDataSubSSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
    if sum(strcmp(handles.splitProcDataLevels,'subject')) == 0
        handles.splitProcDataLevels{end+1} = 'subject';
    end
    set(hObject,'Checked','on');
else
    ind = strcmp(handles.splitProcDataLevels,'subject');
    if sum(ind) > 0
        handles.splitProcDataLevels(ind) = [];
    end
    set(hObject,'Checked','off');
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function SplitProcDataSesSSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SplitProcDataSesSSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
    if sum(strcmp(handles.splitProcDataLevels,'session')) == 0
        handles.splitProcDataLevels{end+1} = 'session';
    end
    set(hObject,'Checked','on');
else
    ind = strcmp(handles.splitProcDataLevels,'session');
    if sum(ind) > 0
        handles.splitProcDataLevels(ind) = [];
    end
    set(hObject,'Checked','off');
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function SplitProcDataTrSSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SplitProcDataTrSSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
    if sum(strcmp(handles.splitProcDataLevels,'trial')) == 0
        handles.splitProcDataLevels{end+1} = 'trial';
    end
    set(hObject,'Checked','on');
else
    ind = strcmp(handles.splitProcDataLevels,'trial');
    if sum(ind) > 0
        handles.splitProcDataLevels(ind) = [];
    end
    set(hObject,'Checked','off');
end
guidata(hObject, handles);


% --- Executes on button press in protUpButt.
function protUpButt_Callback(hObject, eventdata, handles)
% hObject    handle to protUpButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

i = handles.selectedProt - 1;
if i > 0
    % Move up the protocol in the protocol list variable
    protUp = handles.protDB.protList(i);
    protDo = handles.protDB.protList(i+1);
    handles.protDB.protList(i) = protDo;
    handles.protDB.protList(i+1) = protUp;
    % Move up the selection of the protocol
    oldStringsList = get(handles.protocolsList,'String');
    newStringsList = oldStringsList;
    newStringsList{i} = oldStringsList{i+1};
    newStringsList{i+1} = oldStringsList{i};
    set(handles.protocolsList,'String',newStringsList);
    set(handles.protocolsList,'Value',i);
    handles.selectedProt = i;
    % Save the new protocol list to file
    protDB = handles.protDB;
    save(handles.protDBpath,'-struct','protDB');
    guidata(hObject, handles);
end

% --- Executes on button press in protDoButt.
function protDoButt_Callback(hObject, eventdata, handles)
% hObject    handle to protDoButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

i = handles.selectedProt + 1;
n = length(handles.protDB.protList);
if i <= n
    % Move down the protocol in the protocol list variable
    protUp = handles.protDB.protList(i-1);
    protDo = handles.protDB.protList(i);
    handles.protDB.protList(i) = protUp;
    handles.protDB.protList(i-1) = protDo;
    % Move down the selection of the protocol
    oldStringsList = get(handles.protocolsList,'String');
    newStringsList = oldStringsList;
    newStringsList{i} = oldStringsList{i-1};
    newStringsList{i-1} = oldStringsList{i};
    set(handles.protocolsList,'String',newStringsList);
    set(handles.protocolsList,'Value',i);
    handles.selectedProt = i;
    % Save the new protocol list to file
    protDB = handles.protDB;
    save(handles.protDBpath,'-struct','protDB');
    guidata(hObject, handles);
end


% --- Executes on button press in expMovSideDataOnlyCheck.
function expMovSideDataOnlyCheck_Callback(hObject, eventdata, handles)
% hObject    handle to expMovSideDataOnlyCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of expMovSideDataOnlyCheck

if get(hObject,'Value')
    handles.export.CSV.expMovSideDataOnly = 1;
else
    handles.export.CSV.expMovSideDataOnly = 0;
end
guidata(hObject, handles);


% --- Executes on button press in rawDataReadOptsButt.
function rawDataReadOptsButt_Callback(hObject, eventdata, handles)
% hObject    handle to rawDataReadOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiwait(msgbox('No options are available for this section','Raw data reading','modal'));

% --- Executes on button press in kineOptsButt.
function kineOptsButt_Callback(hObject, eventdata, handles)
% hObject    handle to kineOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[kine, allJoints, allMarkers] = kineGUI(handles.kine);
if ~isempty(kine)
    handles.kine = kine;
    handles.allJoints = allJoints;
    handles.allMarkers = allMarkers;
    handles = editProtocolParam(handles, 'kine');
    guidata(hObject, handles);
end

% --- Executes on button press in EMGOptsButt.
function EMGOptsButt_Callback(hObject, eventdata, handles)
% hObject    handle to EMGOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in segOptsButt.
function segOptsButt_Callback(hObject, eventdata, handles)
% hObject    handle to segOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[seg] = segGUI(handles.seg, handles.evConfig, handles.allMarkers, handles.defaultContextsN, handles.defaultStpPointsN, handles.defaultPhasesN);
if ~isempty(seg)
    handles.seg = seg;
    handles = editProtocolParam(handles, 'seg');
    guidata(hObject, handles);
end


% --- Executes on button press in bestCyOptsButt.
function bestCyOptsButt_Callback(hObject, eventdata, handles)
% hObject    handle to bestCyOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[bestCy] = bestCyGUI(handles.bestCy, handles.allAngles, handles.defaultTaskPrefixN, handles.defaultAnglesListN, handles.defaultPhasesN);
if ~isempty(bestCy)
    handles.bestCy = bestCy;
    handles = editProtocolParam(handles, 'bestCy');
    guidata(hObject, handles);
end


% --- Executes on button press in cliParsOptsButt.
function cliParsOptsButt_Callback(hObject, eventdata, handles)
% hObject    handle to cliParsOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

subNames = get(handles.subjectsList,'String');
[cliPars] = cliParsGUI(handles.cliPars, subNames, handles.defaultSubMatchN);
if ~isempty(cliPars)
    handles.cliPars = cliPars;
    handles = editProtocolParam(handles, 'cliPars');
    guidata(hObject, handles);
end


% --- Executes on button press in XMLPathButt.
function XMLPathButt_Callback(hObject, eventdata, handles)
% hObject    handle to XMLPathButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir = uigetdir(handles.export.XML.XMLPath,'Select path');
if ~isempty(dir) && dir(1) ~= 0
    handles.export.XML.XMLPath = dir;
end
guidata(hObject, handles);


% --- Executes on button press in saveBestCyXMLCheck.
function saveBestCyXMLCheck_Callback(hObject, eventdata, handles)
% hObject    handle to saveBestCyXMLCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saveBestCyXMLCheck

if get(hObject,'Value')
    handles.export.XML.saveBestCyXML = 1;
else
    handles.export.XML.saveBestCyXML = 0;
end
guidata(hObject, handles);


% --- Executes on button press in inFileFolderButt.
function inFileFolderButt_Callback(hObject, eventdata, handles)
% hObject    handle to inFileFolderButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir = uigetdir(handles.export.XMLRefData.inFileFolder,'Select path');
if ~isempty(dir) && dir(1) ~= 0
    handles.export.XMLRefData.inFileFolder = dir;
end
guidata(hObject, handles);



function inFileNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to inFileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inFileNameEdit as text
%        str2double(get(hObject,'String')) returns contents of inFileNameEdit as a double

handles.export.XMLRefData.inFileName = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function inFileNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inFileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outFileFolderButt.
function outFileFolderButt_Callback(hObject, eventdata, handles)
% hObject    handle to outFileFolderButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir = uigetdir(handles.export.XMLRefData.outFileFolder,'Select path');
if ~isempty(dir) && dir(1) ~= 0
    handles.export.XMLRefData.outFileFolder = dir;
end
guidata(hObject, handles);


function outFileNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to outFileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outFileNameEdit as text
%        str2double(get(hObject,'String')) returns contents of outFileNameEdit as a double

handles.export.XMLRefData.outFileName = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function outFileNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outFileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function ExportXMLRefDataSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ExportXMLRefDataSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(hObject,'Checked'),'off')
   handles = managePanelContent(handles, 'expXMLRefDataPanel', 'on');
   handles.sectionsToComp.expXMLRefData = 1;
   set(hObject,'Checked','on')
else
   handles = managePanelContent(handles, 'expXMLRefDataPanel', 'off');
   handles.sectionsToComp.expXMLRefData = 0;
   set(hObject,'Checked','off')
end
guidata(hObject, handles);


% --- Executes on button press in keepOnlyMeanStdCheck.
function keepOnlyMeanStdCheck_Callback(hObject, eventdata, handles)
% hObject    handle to keepOnlyMeanStdCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of keepOnlyMeanStdCheck

if get(hObject,'Value')
    handles.export.XMLRefData.keepOnlyMeanStd = 1;
else
    handles.export.XMLRefData.keepOnlyMeanStd = 0;
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function ProcDataSavingSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ProcDataSavingSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ProcDataSavingOverSSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ProcDataSavingOverSSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = menuMutualSel(handles, handles.procDataSavingList, get(hObject,'Tag'));
guidata(hObject, handles);


% --------------------------------------------------------------------
function ProcDataSavingSafeMerSSSMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ProcDataSavingSafeMerSSSMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = menuMutualSel(handles, handles.procDataSavingList, get(hObject,'Tag'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function kineOptsButt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kineOptsButt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
