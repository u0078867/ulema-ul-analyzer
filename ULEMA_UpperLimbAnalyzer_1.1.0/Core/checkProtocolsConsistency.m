%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [trToUseDB, ok] = checkProtocolsConsistency(trToUseDB, trToUseDBOrig, protList, sectionsToComp, forceDataOverwriting)

% check if for every trial the protocol content for the old computation is
% the same to the content of the new wanted computation. This check is done
% only if the protocol names are the same.

sections = getSectionsToCompList(sectionsToComp);
protOptsDescr = ProtOptsDescr();

ok = 1;
for i = 1 : length(trToUseDB.subjects)
    for j = 1 : length(trToUseDB.subjects(i).sessions)
        for k = 1 : length(trToUseDB.subjects(i).sessions(j).trials)
            protocolID = trToUseDB.subjects(i).sessions(j).trials(k).protocolID;
            ind = strcmp({protList.protName},protocolID);         
      
            if sum(ind) > 0 % if there is a corrispondence in name  
                if forceDataOverwriting == 0 
                    % note: in this part there is no need to assign also
                    % protoclID, because it is already matching with
                    % protList(ind).protName
                    if isAlreadyProcessed(trToUseDB.subjects(i).sessions(j).trials(k))
                        res = compareProtocols(protList(ind), trToUseDBOrig.subjects(i).sessions(j).trials(k).protocolData, protOptsDescr, sections, {});
                        if res == 0 % if the existing protocol is different from the one assigned
                            cellMsg = {};
                            cellMsg{end+1} = fullfile(trToUseDB.subjects(i).name,trToUseDB.subjects(i).sessions(j).name,trToUseDB.subjects(i).sessions(j).trials(k).name);
                            cellMsg{end+1} = '';
                            cellMsg{end+1} = 'Protocol previously used to process this';
                            cellMsg{end+1} = 'trial is different from the one assigned';
                            cellMsg{end+1} = 'now, despite they have the same name.';
                            cellMsg{end+1} = 'Which one do you want to use?';
                            choice = questdlg(cellMsg,'','Old','Assigned','Stop process','Assigned');
                            switch choice
                                case 'Old'
                                    trToUseDB.subjects(i).sessions(j).trials(k).protocolData = trToUseDBOrig.subjects(i).sessions(j).trials(k).protocolData;
                                case 'Assigned'
                                    trToUseDB.subjects(i).sessions(j).trials(k).protocolData = protList(ind); 
                                case {'Stop process','Cancel',''}
                                    ok = 0;
                                    return
                            end
                        else % the protocol content is the same
                            trToUseDB.subjects(i).sessions(j).trials(k).protocolData = protList(ind);
                        end
                    else % if there is no protocol content already stored
                        trToUseDB.subjects(i).sessions(j).trials(k).protocolData = protList(ind);
                    end
                else
                    trToUseDB.subjects(i).sessions(j).trials(k).protocolData = protList(ind);
                end
            else
                % There is no correspondence in name: it means that in the
                % "checkProtocolexistance" the old procolID and
                % protocolData were assigned for the current processing.
                % Thus, there is no need to check for protocol consistency
                % since there protList(ind).protName will not used
            end
        end
    end
end


