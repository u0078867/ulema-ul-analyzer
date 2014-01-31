%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function EditNewAnatCalcFunction
% EDITNEWANATCALCFUNCTION  [ BodyMech 3.06.01 ]: opens a template Anatomical Calculation Function to edit
% INPUT
%    Input : none
% PROCESS
%    Loads an (template) anatomical calculation function (m.file) and opens Editor 
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
[filename,pathname] = uigetfile('AnatCalc*.m', 'Edit Anatomical Calculation Function');

% read BODY
if filename ~= 0
   cd(pathname);
   filename=strrep(filename,'.m',''); % remove file extension ".m"
   edit(filename);
else
    return
end
 
% ============================================ 
% END ### EditNewAnatCalcFunction ###
