%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = managePanelContent(handles, panelTag, onOrOff)

% This also parses for every subpanes
objInPanel = get(get(handles.(panelTag),'Children'),'Tag');
if ~isempty(objInPanel)
    if ~iscell(objInPanel)  % only one item inside
        props = get(handles.(objInPanel));
        if isfield(props,'TitlePosition')
            handles = managePanelContent(handles, objInPanel, onOrOff);
        elseif isfield(props, 'Enable')
            set(handles.(objInPanel),'Enable',onOrOff);
        end
    else % more than one item inside
        for i = 1 : length(objInPanel)
            props = get(handles.(objInPanel{i}));
            if isfield(props,'TitlePosition')
                handles = managePanelContent(handles, objInPanel{i}, onOrOff);
            elseif isfield(props, 'Enable')
                set(handles.(objInPanel{i}),'Enable',onOrOff);
            end
        end
    end
end
