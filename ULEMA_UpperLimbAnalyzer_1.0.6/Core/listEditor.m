%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function newList = listEditor(oldList)


global h;
h.oldList = oldList;

% Figure initialization
h.f = figure('MenuBar','none','Position',[400 300 300 300],'CloseRequestFcn',{@closeWin_Callback},'WindowStyle','modal');
h.listEdit = uicontrol('Parent',h.f,'Style','edit','max',20,'Position',[0 30 300 270]);

% Recover Java object of edit control
h.jScrollPane = findjobj(h.listEdit);
h.jViewPort = h.jScrollPane.getViewport;
h.jListEdit = h.jViewPort.getComponent(0);
h.jListEdit.setContentType('text/html');
h.jListEdit.setText(listCell2HTML(h.oldList));

% Define the other componentes
h.saveButt = uicontrol('Parent',h.f,'Style','pushbutton','Callback',{@saveButt_Callback},'String','Save and close', 'Position',[0 0 150 30]);
h.noSaveButt = uicontrol('Parent',h.f,'Style','pushbutton','Callback',{@noSaveButt_Callback},'String','Don''t save and close','Position',[150 0 150 30]);

% Wait till resume
uiwait(h.f);

% Output
newList = h.newList';
delete(h.f);

% Callbacks

function saveButt_Callback(hObject, eventdata)

global h
h.newList = HTML2listCell(char(h.jListEdit.getText));
uiresume


function noSaveButt_Callback(hObject, eventdata)

global h
h.newList = h.oldList;
uiresume


function closeWin_Callback(hObject, eventdata)

global h
h.newList = h.oldList;
uiresume



