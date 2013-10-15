%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function createXMLFiles(XMLPath, saveBestCyXML, trToUseDB, nTr, nSes)

version = currFileVersion();

if saveBestCyXML
    h = waitbar2(0,'');
    cb = 0;
    for i = 1 : length(trToUseDB.subjects);
        % Load the subject
        sub = trToUseDB.subjects(i).name;
        fprintf('Subject %s loaded...\n', sub);
        subject = loadStructData(trToUseDB, sub);
        % Create the folder for the subject
        subPath = fullfile(XMLPath,sub);
        mkdir(subPath);
        % Loop for every session
        for j = 1 : length(subject.sessions)
            ses = subject.sessions(j).name;
            % Create the folder for the session
            sesPath = fullfile(subPath,ses);
            mkdir(sesPath);
            % Update the waitbar
            cb = cb + 1;
            waitbarText = [fullfile(trToUseDB.subjects(i).name, trToUseDB.subjects(i).sessions(j).name), 'MAT -> XML...'];
            waitbar2(cb/nSes,h,waitbarText);
            % Create .xml file for bestCycles
            if isfield(subject.sessions(j), 'bestCycles') && ~isempty(subject.sessions(j).bestCycles)
                bestCycles = subject.sessions(j).bestCycles;
                bestCycles.ATTRIBUTE.version = ['UZP_',num2str(version)];
                filePath = fullfile(sesPath,'bestCycles.xml');
                xml_write(filePath, bestCycles, 'bestCycles');
            end
        end
    end
    close(h);
end



