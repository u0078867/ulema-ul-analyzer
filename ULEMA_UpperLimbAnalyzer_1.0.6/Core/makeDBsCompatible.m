%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [trDB1, trDB2] = makeDBsCompatible(trDB1, trDB2)

% Make compatibility test for both structures
cmp = fieldnames(trDB1.subjects(1).sessions(1).trials);
[testPassed1, allFields1] = testDBForCompatibility(trDB1, cmp);
[testPassed2, allFields2] = testDBForCompatibility(trDB2, cmp);
%testPassed = testPassed1 && testPassed2;
allFields = unique([allFields1; allFields2]);
% Make the structures compatible, if needed
% if ~testPassed
    trDB1 = createCompatibleDB(trDB1, allFields);
    trDB2 = createCompatibleDB(trDB2, allFields);
% end



%% Subfunctions

function [testPassed, allFields] = testDBForCompatibility(trDB, cmp)

testPassed = 1;
allFields = {};
for i = 1 : length(trDB.subjects)
    for j = 1 : length(trDB.subjects(i).sessions)
        if ~isempty(trDB.subjects(i).sessions(j).trials)
            newFields = fieldnames(trDB.subjects(i).sessions(j).trials);
%             if ~isequal(cmp, newFields)
                allFields = [allFields; newFields];
                testPassed = 0;
%             end
        end
    end
end


function trDBNew = createCompatibleDB(trDB, allFields)

for i = 1 : length(trDB.subjects)
    workbar(i / length(trDB.subjects), 'Creating compatible DB...', 'DB creation');
    trDBNew.subjects(i).name = trDB.subjects(i).name;
    for j = 1 : length(trDB.subjects(i).sessions)
        trDBNew.subjects(i).sessions(j).name = trDB.subjects(i).sessions(j).name;
        for k = 1 : length(trDB.subjects(i).sessions(j).trials)
            for f = 1 : length(allFields)
                if isfield(trDB.subjects(i).sessions(j).trials(k), allFields{f})
                    trDBNew.subjects(i).sessions(j).trials(k).(allFields{f}) = trDB.subjects(i).sessions(j).trials(k).(allFields{f});
                else
                    trDBNew.subjects(i).sessions(j).trials(k).(allFields{f}) = [];
                end
            end
        end
    end
end



