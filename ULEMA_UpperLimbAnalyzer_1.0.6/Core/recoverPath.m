%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function p = recoverPath(recoveryPath, fileExt, structType, pathFor, subName, sesName, trName)

p = [];

switch structType
    case 'tree'
        recDB = importVirtualDBStruct(recoveryPath, fileExt, 'tree', 1, subName);
        subInd = strcmp({recDB.subjects.name},subName);
        if sum(subInd) == 0
            return;
        end
        if strcmp(pathFor,'subject')
            p = recDB.subjects(subInd).sessions(1).trials(1).subPath;
            return;
        end
        sesInd = strcmp({recDB.subjects(subInd).sessions.name},sesName);
        if sum(sesInd) == 0
            return;
        end
        if strcmp(pathFor,'session')
            p = fullfile(recDB.subjects(subInd).sessions(1).trials(1).subPath,sesName);
            return;
        end
        trInd = strcmp({recDB.subjects(subInd).sessions(sesInd).trials.name},trName);
        if sum(trInd) == 0
            return;
        end
        p = fullfile(recDB.subjects(subInd).sessions(1).trials(1).subPath,sesName,trName);
end

