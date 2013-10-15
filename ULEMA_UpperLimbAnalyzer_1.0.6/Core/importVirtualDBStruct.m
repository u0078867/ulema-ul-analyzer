%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function trDB = importVirtualDBStruct(dir, fileExt, structType, noWaitBar, varargin)

version = currFileVersion();

% Adding subjects
subjectsFullPath = getDirContent(dir,'folders',NaN);
for i = 1 : length(subjectsFullPath)
    [dummy1,subjects{i},dummy2] = fileparts(subjectsFullPath{i});
end
if length(varargin) == 1
    indToKeep = strcmp(subjects,varargin{1});
    subjects = subjects(indToKeep);
end 
if length(varargin) == 2 % load only one subject
    if strcmp(varargin{2},'singleSubject')
        subjects = {};
        [dir, subjects{1}, dummy1] = fileparts(dir);
    end
end 
if ~noWaitBar
    h = waitbar2(0,'');
end
switch structType
    case 'tree'
        for i = 1 : length(subjects)
            if ~noWaitBar
                waitbar2(i / length(subjects), h, ['Loading subject: ', subjects{i}, '...']);
            end
            trDB.subjects(i).name = subjects{i};
            % Adding sessions
            sessionsFullPath = getDirContent(fullfile(dir,subjects{i}),'folders',NaN);
            for j = 1 : length(sessionsFullPath)
                [dummy1,name,dummy2] = fileparts(sessionsFullPath{j});
                sessions{j} = name;
                trDB.subjects(i).sessions(j).name = sessions{j};
                % Adding trials
                trialsFullPath = getDirContent(fullfile(dir,subjects{i},sessions{j}),'files',fileExt);
                for k = 1 : length(trialsFullPath)
                    [dummy1,name,ext] = fileparts(trialsFullPath{k});
                    trials{k} = [name,ext];
                    trDB.subjects(i).sessions(j).trials(k).name = trials{k};
                    trDB.subjects(i).sessions(j).trials(k).protocolID = [];
                    trDB.subjects(i).sessions(j).trials(k).path = fullfile(dir,subjects{i},sessions{j},trials{k});
                    trDB.subjects(i).sessions(j).trials(k).subPath = fullfile(dir,subjects{i});
                    trDB.subjects(i).sessions(j).trials(k).static = [];
                    trDB.subjects(i).sessions(j).trials(k).staticRef = [];
                    trDB.subjects(i).sessions(j).trials(k).DJC = [];
                    trDB.subjects(i).sessions(j).trials(k).version = version;
                end
            end
        end
end
if ~noWaitBar
    close(h);
end


