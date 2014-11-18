%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function HeaderInfo=ListBodyHeader
% LISTBODYHEADER [ BodyMech 3.06.01 ]: lists the BODYheader to the screen
% INPUT
%   global: BODY
% PROCESS
%   creates char list of all header-info on the screen

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, August 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

if isempty(BODY.HEADER)
   CreateBodyheader('no project');
end
if ~isfield (BODY.HEADER.Session,'MarkerDataFile')
   BODY.HEADER.Session.MarkerDataFile='';
end
if ~isfield(BODY.CONTEXT,'AnatomicalCalculationFunction')
    BODY.CONTEXT.AnatomicalCalculationFunction='n.i';
end

HeaderInfo={...
'';...
['LAB_Id: === ',BODY.CONTEXT.Name,'   ==='];...
'';...
['<Project>: ',BODY.HEADER.ProjectName,'  |||  Code: ',BODY.HEADER.ProjectCode];...
['AnatomicalCalculationFcn: ',BODY.CONTEXT.AnatomicalCalculationFunction];...
'';...
['<Session>: ',BODY.HEADER.Session.Name,'  |||  Code: ',BODY.HEADER.Session.Code,'  ||   Date: ',BODY.HEADER.Session.Date];...
['Subject: ',BODY.HEADER.Subject.Code,'  |||  Static Kinematics file: ',BODY.HEADER.Session.MarkerDataFile];...
'';...
['<Trial>: ',BODY.HEADER.Trial.Name,'  |||  Code: ',BODY.HEADER.Trial.Code,'  |||  Time: ',BODY.HEADER.Trial.Time];...
[' || AnalogSignalFile: ',BODY.HEADER.Trial.AnalogDataFile];...
[' || KinematicsFile: ',BODY.HEADER.Trial.MarkerDataFile];,...
'';...
['BMB file: ',BODY.HEADER.FileName,'  |||||  dated: ',BODY.HEADER.FileCreationDate];...  
'';...
['Remarks: ',BODY.HEADER.Trial.Remarks]...
};

return
% ============================================ 
% END ### ListBodyHeader ###
