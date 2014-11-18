%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function handles = loadStructInGUI(handles, fileExt, structType, groupType)

% fileExt: extension of the files to be loaded (c3d, mat, ...)
% structType, groupType: their meaning depends on the type of files to be loaded:
% - never processed files (e.g. c3d):
%       - structType is the type of structure in which files are physically
%         organized on the hard-drive, e.g.: tree (subject, sessions,
%         trials), flat (all the files in a folder, file name:
%         <sub>_<ses>_<tr>.c3d), ...
%       - groupType describes how many loading of the type structType has
%         to be performed. For a tree, for instance, this can represent 
%         the head node of the tree.
% - already processed files (e.g. mat):
%       - structType makes no sense anymore, since in the processed files
%         there is only one unique structure type, a tree for every
%         subject.
%       - groupType describes type of structure in which the already processed
%         files are physically organized on the hard-drive.


switch fileExt
    case 'c3d'
        dir = uigetdir(pwd,'Select DB folder');
        condition = ~isempty(dir) && dir(1) ~= 0;
        askMergingMethod = 1;
        numLoadings = 1;
    case 'mat'
        switch groupType
            case 'singleFile'
                [filename, pathname] = uigetfile('*.mat', 'Choose the MAT data file');
                condition = ~isempty(filename) && filename(1) ~= 0;
                askMergingMethod = 1;
                numLoadings = 1;
            case 'filesInTree1' % files contained in a folder (considered as tree with max depth as 1), e.g.: a session folder
                dir = uigetdir(pwd,'Select folder containing MAT files');   % filenames are absolute paths
                condition = ~isempty(dir) && dir(1) ~= 0;
                askMergingMethod = 0;
                if condition == 1
                    filenames = getDirContent(dir,'files','mat',1);
                    numLoadings = length(filenames);
                end
            case 'filesInTree2' % files contained in a folder structure (considered as tree with max depth as 2), e.g.: a subject folder
                dir = uigetdir(pwd,'Select tree (depth 2) containing MAT files');   % filenames are absolute paths
                condition = ~isempty(dir) && dir(1) ~= 0;
                askMergingMethod = 0;
                if condition == 1
                    filenames = getDirContent(dir,'files','mat',2);
                    numLoadings = length(filenames);
                end
            case 'filesInTree3' % files contained in a folder structure (considered as tree with max depth as 3), e.g.: a folder containing a group of subjects
                dir = uigetdir(pwd,'Select tree (depth 3) containing MAT files');   % filenames are absolute paths
                condition = ~isempty(dir) && dir(1) ~= 0;
                askMergingMethod = 0;
                if condition == 1
                    filenames = getDirContent(dir,'files','mat',3);
                    numLoadings = length(filenames);
                end
        end
end
h = waitbar2(0,'Loading subjects...please wait...');
if condition == 1
    for l = 1 : numLoadings
        waitbar2(l/numLoadings,h);
        switch fileExt
            case 'c3d'
                % Load the root
                handles.lastUsedDir = dir;
                switch groupType
                    case 'singleSubject'
                        newTrDB = loadStruct(handles.lastUsedDir, fileExt, structType, 'singleSubject');
                    case 'groupSubjects'
                        newTrDB = loadStruct(handles.lastUsedDir, fileExt, structType, 'groupSubjects');
                end
            case 'mat'
                switch groupType
                    case 'singleFile'
                        handles.lastUsedDir = pathname;
                        newTrDB = loadStruct([pathname, filename], fileExt, []);
                        fprintf('\n\nNew DB loaded\n\n');
                    case {'filesInTree1', 'filesInTree2', 'filesInTree3'}
                        handles.lastUsedDir = dir;
                        newTrDB = loadStruct(filenames{l}, fileExt, []);
                        fprintf('\n\nNew DB loaded\n\n');
                        if l == 1 
                            uiwait(msgbox('All the MAT files will be merged overwriting duplicates...', 'DB merging warning', 'warn'));
                        end
                end
        end
        if ~isempty(handles.trDB.subjects) % if I already uploaded something
            if askMergingMethod == 1
                choice = questdlg('A data structure is already present. What are going do with the new loeaded one?', '', 'Merge', 'Merge (overwrite trial duplicates)', 'Overwrite all', 'Merge (don''t overwrite duplicates)');
            else
                choice = 'Merge (overwrite trial duplicates)';
            end
            switch choice 
                case {'Merge', 'Merge (overwrite trial duplicates)'}
                    if strcmp(choice, 'Merge')
                        [warningsList, tempDB] = mergeVirtualDBStructs(handles.trDB, newTrDB, 'useOld');
                    end
                    if strcmp(choice, 'Merge (overwrite trial duplicates)')
                        [warningsList, tempDB] = mergeVirtualDBStructs(handles.trDB, newTrDB, 'useNew');
                    end
                    if strcmp(get(handles.WarnDuplSSMenu, 'Checked'),'on') && ~isempty(warningsList)
                        fprintf('\n\No DB merging due to duplicates\n\n');
                        msg = char([{'Duplicates detected:'}; ' '; warningsList]);
                        fid = fopen(fullfile(handles.lastUsedDir, 'Duplicates.txt'),'w');
                        fprintfCell(fid, msg);
                        msgbox(['List of duplicates has been saved in ', handles.lastUsedDir, '\Duplicates.txt'], 'DB merging warning', 'warn');
                        handles.trDB = tempDB;
                        fclose(fid);
                    else
                        handles.trDB = tempDB;
                        fprintf('\n\Previously loaded DB and just loaded DB merged\n\n');
                    end
                case 'Overwrite all'
                    handles.trDB = newTrDB;
                    fprintf('\n\nNew DB assigned to current DB\n\n');
            end
        else
            handles.trDB = newTrDB;
            fprintf('\n\nNew DB assigned to current DB\n\n');
        end
    end
    % Get the list of subjects
    subjectsListCell = getVirtualDBNames(handles.trDB, '', 'subjects', {});
    handles.subNames = [subjectsListCell, {' '}];
    handles.currentSubject = subjectsListCell{1};
    set(handles.subjectsList, 'String', subjectsListCell);

end
close(h);
