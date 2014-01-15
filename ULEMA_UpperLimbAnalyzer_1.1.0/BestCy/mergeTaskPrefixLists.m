%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [mergedTaskPrefixList, mergedAnglesList, notFoundDuplicates] = mergeTaskPrefixLists(trials)

notFoundDuplicates = 1;

% Clean every table from empty lines and merge all of them
mergedTaskPrefixList = {};
mergedAnglesList = {};
for k = 1 : length(trials)
    % Add task prefix table
    toAdd = cleanTableFromEmptyLines(trials(k).protocolData.taskPrefixList,4);
    N = size(toAdd,1);
    mergedTaskPrefixList(end+1:end+N,:) = toAdd;
    % Add angles list table
    toAdd = cleanTableFromEmptyLines(trials(k).protocolData.anglesList(1:N)')';
    N = length(toAdd);
    mergedAnglesList(1,end+1:end+N) = toAdd;
    % In the 4th column add the index of the trial that generated it
    mergedTaskPrefixList(end-N+1:end,4) = num2cell(k * ones(N,1));
end

% Search for duplicate rows
toDelete = [];
for r1 = 1 : length(mergedAnglesList)
    for r2 = r1 + 1 : length(mergedAnglesList)
        if strcmp(mergedTaskPrefixList{r1,1},mergedTaskPrefixList{r2,1}) && ...
           strcmp(mergedTaskPrefixList{r1,2},mergedTaskPrefixList{r2,2}) && ...
           strcmp(mergedTaskPrefixList{r1,3},mergedTaskPrefixList{r2,3})
            toDelete(end+1) = r2;
            notFoundDuplicates = 0;
            mergedTaskPrefixList{r1,4}(end+1) = mergedTaskPrefixList{r2,4};
        end
    end
end
mergedTaskPrefixList(toDelete,:) = [];
mergedAnglesList(toDelete) = [];




