%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function itemsListCell = getDirContent(folder,type,ext,varargin)

% Returns a cell-array of strings representing the full path of subcontents
% contained in a folders tree with head "folder". It can return any "type"
% of subcontent (folders, files, both). If type == "files", it returns 
% only files with a specified extension ("ext"). Optionally, the depth on
% which to scan in the folder tree can be specified (default = 1).


if ~isempty(varargin)
    depth = varargin{1};
else
    depth = 1;
end
d = dir(folder);
itemsListCell = {};
if ~isempty(d)
    d = d(3:end);   % exclude . and .. folders
    for i = 1 : length(d)
        canAdd = 0;
        switch type
            case 'folders'
                if d(i).isdir == 1
                    canAdd = 1;
                end
            case 'files'
                if d(i).isdir == 0 && strcmpi(d(i).name(end-length(ext)+1:end),ext) == 1 && depth == 1
                    canAdd = 1;
                end
            case 'both'
                canAdd = 1;
        end
        if canAdd == 1
            itemsListCell{end+1,1} = fullfile(folder,d(i).name);
        end
        if d(i).isdir == 1 && strcmp(type,'files') && depth > 1
            newFolder = fullfile(folder, d(i).name);
            itemsListCell = [itemsListCell; getDirContent(newFolder,type,ext,depth-1)];
        end
    end
end
