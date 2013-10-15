%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function EditNewProjectModel
% EDITNEWPROJECTMODEL [ BodyMech 3.06.01 ]: opens a template to create ProjectModel to edit
% INPUT
%    Input : none
% PROCESS
%   opens a template (m.file)to create ProjectModel and evokes the editor
% OUTPUT
%   none

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader

% get file name
% ==============================================
[filename,pathname] = uigetfile('Project*.m', 'Edit BodyMech ProjectModel Definition file');

% read BODY
if filename ~= 0
    ClearBody;
    cd(pathname);
    filename=strrep(filename,'.m',''); % remove file extension ".m"
    edit(filename);
else
    return
end

% ============================================
% END ### EditNewProjectModel ###
