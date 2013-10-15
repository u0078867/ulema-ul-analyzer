%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function trToUseDB = delEmptyStructsInVirtualDB(trDB)

% Scanning for for trial with no protocol assigned
i = 1;
j = 1;
k = 1;
while i <= length(trDB.subjects)
    while j <= length(trDB.subjects(i).sessions)
        while k <= length(trDB.subjects(i).sessions(j).trials)
            if isempty(trDB.subjects(i).sessions(j).trials(k).protocolID)
                trDB.subjects(i).sessions(j).trials(k) = [];
            else
                k = k + 1;
            end
        end
        k = 1;
        if isempty(trDB.subjects(i).sessions(j).trials)
            trDB.subjects(i).sessions(j) = [];
        else
            j = j + 1;
        end
    end
    j = 1;
    if isempty(trDB.subjects(i).sessions)
        trDB.subjects(i) = []; 
    else
        i = i + 1;
    end
end

trToUseDB = trDB;















