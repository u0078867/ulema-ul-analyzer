%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = setGUIforCopiedProt(handles)

% Adding the copy of the protocol
n = get(handles.protocolsList,'Value');
handles.protDB.protList(end+1) = handles.protDB.protList(n);

% Creating new protocol ID number
protNamesStr = get(handles.protocolsList,'String');
sourceName = protNamesStr{n};
protIDs = 1:length(protNamesStr);
newID = max(protIDs)+1;
set(handles.protNameEdit,'String',['Copy of ',sourceName]);
set(handles.protocolsList, 'String', [protNamesStr; {['Copy of ',sourceName]}]);
set(handles.protocolsList, 'Value', newID);

