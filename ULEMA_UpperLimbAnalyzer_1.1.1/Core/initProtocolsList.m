%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = initProtocolsList(handles)

n = length(handles.protDB.protList);
protList = {};
for i = 1 : n
    protList{i} = handles.protDB.protList(i).protName;
end
set(handles.protocolsList,'String',protList);
