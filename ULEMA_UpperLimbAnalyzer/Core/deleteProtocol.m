%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = deleteProtocol(handles)

% Put the focus on a the protocol that is previous (or following) to the deleted one
n = get(handles.protocolsList,'Value');
if n > 0
    l = get(handles.protocolsList,'String');
    if n == 1
        set(handles.protocolsList,'Value',1);
        handles.selectedProt = 1;
        for i = 1 : handles.defaultTaskPrefixN
            for j = 1 : 50
                handles.anglesList{i}{j,1} = '';
            end
        end
    else
        set(handles.protocolsList,'Value',n-1);
        handles.selectedProt = n-1;
        handles.anglesList = handles.protDB.protList(n-1).anglesList;
    end

    % Deleting the loaded protocol DB
    handles.protDB.protList(n) = [];

    % Saving the new (smaller) protocol DB
    protDB = handles.protDB;
    save(handles.protDBpath,'-struct','protDB');

    % Deleting protocol from the GUI list
    listL = length(l)-1;
    l = {};
    for i = 1 : listL
        l{i} = handles.protDB.protList(i).protName;
    end
    set(handles.protocolsList,'String',l);
end

