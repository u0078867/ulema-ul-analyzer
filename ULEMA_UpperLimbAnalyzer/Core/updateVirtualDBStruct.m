%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function DB1 = updateVirtualDBStruct(DB1,DB2,toUpdate)

if ~isempty(DB2.subjects)
    
    for i = 1 : length(DB1.subjects)
        subInd = strcmp({DB2.subjects.name},DB1.subjects(i).name);
        if sum(subInd) > 0
            for j = 1 : length(DB1.subjects(i).sessions)
                sesInd = strcmp({DB2.subjects(subInd).sessions.name},DB1.subjects(i).sessions(j).name);
                if sum(sesInd) > 0
                    for k = 1 : length(DB1.subjects(i).sessions(j).trials)
                        trInd = strcmp({DB2.subjects(subInd).sessions(sesInd).trials.name},DB1.subjects(i).sessions(j).trials(k).name);
                        if sum(trInd) > 0
                            for f = 1 : length(toUpdate)
                                DB1.subjects(i).sessions(j).trials(k).(toUpdate{f}) = DB2.subjects(subInd).sessions(sesInd).trials(trInd).(toUpdate{f});
                            end
                        end
                    end
                end
            end
        end
    end
    
end

