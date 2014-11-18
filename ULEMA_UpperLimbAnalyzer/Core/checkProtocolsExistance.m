%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [trToUseDB, ok] = checkProtocolsExistance(trToUseDB, trToUseDBOrig, protList)

% check if the procol name assigned to the trial matches with one in
% the list of available protocols. Of course, this check has to be done
% regardless of the choice about forceDataOverwriting.

ok = 1;
for i = 1 : length(trToUseDB.subjects)
    for j = 1 : length(trToUseDB.subjects(i).sessions)
        for k = 1 : length(trToUseDB.subjects(i).sessions(j).trials)
            protocolID = trToUseDB.subjects(i).sessions(j).trials(k).protocolID;
            ind = strcmp({protList.protName},protocolID);
            if sum(ind) == 0
                if isAlreadyProcessed(trToUseDB.subjects(i).sessions(j).trials(k))
                    cellMsg = {};
                    cellMsg{end+1} = fullfile(trToUseDB.subjects(i).name,trToUseDB.subjects(i).sessions(j).name,trToUseDB.subjects(i).sessions(j).trials(k).name);
                    cellMsg{end+1} = '';
                    cellMsg{end+1} = 'Protocol name not found in the list!';
                    cellMsg{end+1} = 'However, this trial was loaded from a';
                    cellMsg{end+1} = '.mat file and it''s possible to retrieve';
                    cellMsg{end+1} = 'the protocol content originally used.';
                    cellMsg{end+1} = 'Do you want to use it? If No, process';
                    cellMsg{end+1} = 'will stop';
                    choice = questdlg(cellMsg,'','Yes','No','No');
                    switch choice
                        case 'Yes'
                            trToUseDB.subjects(i).sessions(j).trials(k).protocolID = trToUseDBOrig.subjects(i).sessions(j).trials(k).protocolID;
                            trToUseDB.subjects(i).sessions(j).trials(k).protocolData = trToUseDBOrig.subjects(i).sessions(j).trials(k).protocolData;
                        case {'No','Cancel',''}
                            ok = 0;
                            return
                    end
                else
                    cellMsg = {};
                    cellMsg{end+1} = fullfile(trToUseDB.subjects(i).name,trToUseDB.subjects(i).sessions(j).name,trToUseDB.subjects(i).sessions(j).trials(k).name);
                    cellMsg{end+1} = '';
                    cellMsg{end+1} = 'Protocol name not found in the list!';
                    cellMsg{end+1} = 'Since this trial doesn''t come from a';
                    cellMsg{end+1} = '.mat file, there is no way to recover';
                    cellMsg{end+1} = 'the protocol content. Process will stop';
                    uiwait(errordlg(cellMsg,''));
                    ok = 0;
                    return
                end
            else
                % the procol name assigned to the trial matches with one in
                % the list of available protocols.
            end
        end
    end
end


