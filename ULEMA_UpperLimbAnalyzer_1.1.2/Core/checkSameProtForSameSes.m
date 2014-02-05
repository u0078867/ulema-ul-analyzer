%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ok = checkSameProtForSameSes(trToUseDB, sectionsToComp)

% Check if, for all the selected trials in a session, the procol contents
% are the same (as a whole or only partially, it depends on the section).

sections = getSectionsToCompList(sectionsToComp);
protOptsDescr = ProtOptsDescr();

sectionsToCheck = {'bestCy'};   % this list can be modified (and can also be empty)
sections = intersect(sections,sectionsToCheck);
ok = 1;
if isempty(sections)
    % there is no need to do further checking. The test is passed
    return
end

for i = 1 : length(trToUseDB.subjects)
    for j = 1 : length(trToUseDB.subjects(i).sessions)
        for k = 1 : length(trToUseDB.subjects(i).sessions(j).trials)
            if k > 1
                prevProtocolData = trToUseDB.subjects(i).sessions(j).trials(k-1).protocolData;
                currProtocolData = trToUseDB.subjects(i).sessions(j).trials(k).protocolData;
                for s = 1 : length(sections)
                    switch sections{s}
                        case 'bestCy'
                            res = compareProtocols(prevProtocolData, currProtocolData, protOptsDescr, [], {'bestCyclesN'});
                            if res == 1
                                cellMsg = {};
                                cellMsg{end+1} = 'It has been detected that, for some sessions,';
                                cellMsg{end+1} = 'not all the protocols attached to the trials';
                                cellMsg{end+1} = 'have the same best cycles number. Adjust this';
                                cellMsg{end+1} = 'paramter and try again';
                                ok = 0;
                                uiwait(errordlg(cellMsg, ''));
                                return
                            end
                    end
                end
            end % end if
        end
    end
end


