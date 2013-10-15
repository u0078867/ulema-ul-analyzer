%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function namesList = getVirtualDBNames(trDB, superNames, level, namesToExclude)

% Getting all the names
namesList = {};
switch level
    case 'subjects'
        for i = 1 : length(trDB.subjects)
            namesList{i} = trDB.subjects(i).name;
        end
    case 'sessions'
        subject = superNames{1};
        su = getVirtualDBIndexes(trDB, {subject});
        for i = 1 : length(trDB.subjects(su).sessions)
            namesList{i} = trDB.subjects(su).sessions(i).name;
        end
    case 'trials'
        subject = superNames{1};
        session = superNames{2};
        [su, se] = getVirtualDBIndexes(trDB, {subject, session});
        for i = 1 : length(trDB.subjects(su).sessions(se).trials)
            namesList{i} = trDB.subjects(su).sessions(se).trials(i).name;
            if ~isempty(trDB.subjects(su).sessions(se).trials(i).protocolID)
                namesList{i} = [namesList{i}, '->', trDB.subjects(su).sessions(se).trials(i).protocolID];
            end
        end
end

% Excluding names
indToRemove = [];
for i = 1 : length(namesList)
    [t,r] = strtok(namesList{i},'->');
    if ~isempty(findc(namesToExclude,t));
        indToRemove(end+1) = i;
    end
end
namesList(indToRemove) = [];


