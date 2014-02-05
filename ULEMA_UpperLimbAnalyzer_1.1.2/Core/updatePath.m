%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function trToUseDB = updatePath(trToUseDB,savePath,splitProcDataLevels)

% Select, among the splitProcDataLevels, the one that alloes the mimimum number of .mat files loading, to improve speed
if sum(strcmp(splitProcDataLevels,'subject'))
    topLevel = 'subject';
elseif sum(strcmp(splitProcDataLevels,'session'))
    topLevel = 'session';
elseif sum(strcmp(splitProcDataLevels,'trial'))
    topLevel = 'trial';
end

% Set, for every trial, "subPath" and "path" according to the string previously created
if ~isempty(trToUseDB)
    for i = 1 : length(trToUseDB.subjects)
        for j = 1 : length(trToUseDB.subjects(i).sessions)
            for k = 1 : length(trToUseDB.subjects(i).sessions(j).trials)
                
                switch topLevel
                    case 'subject'
                        trToUseDB.subjects(i).sessions(j).trials(k).subPath = fullfile(savePath,[trToUseDB.subjects(i).name,'.mat']);
                        trToUseDB.subjects(i).sessions(j).trials(k).path = fullfile(savePath,[trToUseDB.subjects(i).name,'.mat']);
                    case 'session'
                        trToUseDB.subjects(i).sessions(j).trials(k).subPath = fullfile(savePath,trToUseDB.subjects(i).name,[trToUseDB.subjects(i).sessions(j).name,'.mat']);
                        trToUseDB.subjects(i).sessions(j).trials(k).path = fullfile(savePath,trToUseDB.subjects(i).name,[trToUseDB.subjects(i).sessions(j).name,'.mat']);
                    case 'trial'
                        trToUseDB.subjects(i).sessions(j).trials(k).subPath = fullfile(savePath,trToUseDB.subjects(i).name,trToUseDB.subjects(i).sessions(j).name,[trToUseDB.subjects(i).sessions(j).trials(k).name(1:end-4),'.mat']);
                        trToUseDB.subjects(i).sessions(j).trials(k).path = fullfile(savePath,trToUseDB.subjects(i).name,trToUseDB.subjects(i).sessions(j).name,[trToUseDB.subjects(i).sessions(j).trials(k).name(1:end-4),'.mat']);
                end
                
            end
        end
    end
end
