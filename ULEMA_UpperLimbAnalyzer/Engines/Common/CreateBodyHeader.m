%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CreateBodyHeader(ProjectName,ProjectCode,Investigator)
% CREATEBODYHEADER [ BodyMech 3.06.01 ]: declares a header to BODY
% INPUT
%   project_name : name of the project
% PROCESS
%   Generation of variable that represent a rigid body of the human body
% OUTPUT
%   GLOBAL: BODY.HEADER

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver. 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, August 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

if nargin < 1,
    ProjectName='Project#0'; 
end
if nargin < 2,
    ProjectCode='000';
end
if nargin < 3
    Investigator='anonymous';
end
   
% create a bodyheader 
    % identification 
BODY.HEADER.Version='3.06.01';

BODY.HEADER.ModelType='Project'; 
BODY.HEADER.ProjectName=ProjectName;
BODY.HEADER.ProjectCode=ProjectCode;
BODY.HEADER.FileName='';  
BODY.HEADER.FileCreationDate=''; 
BODY.HEADER.FileCreationTime='';  

BODY.HEADER.Session.Name='';
BODY.HEADER.Session.Code='';
BODY.HEADER.Session.Investigator=Investigator;
BODY.HEADER.Session.Date='';
BODY.HEADER.Session.Time='';
BODY.HEADER.Session.MarkerDataFile=''; 
BODY.HEADER.Session.Remarks='';

BODY.HEADER.Subject.Name='';
BODY.HEADER.Subject.Code='';
BODY.HEADER.Subject.AdmRecordNo='';
BODY.HEADER.Subject.Height='';
BODY.HEADER.Subject.Weight='';
BODY.HEADER.Subject.DateOfBirth='';
BODY.HEADER.Subject.Sexe='';

BODY.HEADER.Trial.Name='';
BODY.HEADER.Trial.Code='';
BODY.HEADER.Trial.Time='';
BODY.HEADER.Trial.MarkerDataFile=''; % Ver 06.01
BODY.HEADER.Trial.AnalogDataFile=''; % Ver 06.01
BODY.HEADER.Trial.WalkingVelocity='';
BODY.HEADER.Trial.Remarks=''; % Ver 06.01

return
% ============================================ 
% END ### CreateBodyHeader ###
