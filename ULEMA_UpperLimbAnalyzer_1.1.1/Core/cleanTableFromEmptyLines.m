%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function tableCleaned = cleanTableFromEmptyLines(table, varargin)

% from table, exclude the columns indicated in varargin{1}
% Cells (table elements) are excluded if:
% - their content is white spaces only chars (string cell)
% - the content is only NaN (numeric cell)
% - the subcells consists in empty strings (cell-array)

if nargin > 1
    exceptCol = varargin{1};
else
    exceptCol = [];
end
tableCleaned = {};
for i = 1 : size(table,1)
    cols = 1 : size(table,2);
    cols(exceptCol) = [];
    for j = cols
        withData(j) = ~isempty(strtok(table{i,j})) && ...
            ( ~iscell(table{i,j}) && sum(isnan(table{i,j})) ) == 0; % I test it for isnan only if it is not a cell
        if iscell(table{i,j}) % I test it for emptyness only if it is a cell array
            if isempty(char(table{i,j}))
                withData(j) = 0;
            else
                withData(j) = withData(j) && 1;
            end
        end
    end
    if sum(withData) > 0
        tableCleaned(end+1,:) = table(i,:);
    end
end

