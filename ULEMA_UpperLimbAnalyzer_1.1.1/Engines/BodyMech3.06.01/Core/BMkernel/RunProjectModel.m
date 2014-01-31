%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function RunProjectModel
% RUNPROJECTMODEL [ BodyMech 3.06.01 ]: opens and calls a function to create a New ProjectModel
% INPUT
%    Input : none
% PROCESS
%   Loads and calls an m.file for creation of a new ProjectModel
%   
% OUTPUT
%   GLOBAL BODY with projectModel content

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

% get file name 
% ==============================================
[filename,pathname] = uigetfile('*.m', 'run BodyMech ProjectModel function');

% read BODY
if filename ~= 0
   ClearBody;
   cd(pathname);
   filename=strrep(filename,'.m',''); % remove file extension ".m"
   eval(filename);
else
    return
end
 
% ============================================ 
% END ### RunProjectModel ###
