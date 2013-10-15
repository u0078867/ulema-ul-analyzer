%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function createXMLRefDataFile(inFileFolder, inFileName, outFileFolder, outFileName, keepOnlyMeanStd)

h = waitbar2(0,'Reference data: MAT -> XML (may take some minutes)...');
inFilePath = fullfile(inFileFolder, [inFileName, '.mat']);
% Load mat file
data = load(inFilePath);
RefData.tasks = data.RefData.tasks;
RefData.ATTRIBUTE.version = data.RefData.formatType;
% Keep only mean and std (to avoid huge xml files)
if keepOnlyMeanStd == 1
    tasks = fieldnames(RefData.tasks);
    for ta = 1 : length(tasks)
        phases = fieldnames(RefData.tasks.(tasks{ta}));
        for ph = 1 : length(phases)
            RefData.tasks.(tasks{ta}).(phases{ph}).angles = rmfield(RefData.tasks.(tasks{ta}).(phases{ph}).angles, 'rawData');
        end
    end
end
% Write xml file
outFilePath = fullfile(outFileFolder, [outFileName, '.xml']);
xml_write(outFilePath, RefData, 'RefData')
waitbar2(1,h,'Conversion done');
close(h);

