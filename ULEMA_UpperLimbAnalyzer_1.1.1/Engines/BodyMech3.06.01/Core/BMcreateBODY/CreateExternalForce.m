%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

 function CreateExternalForce(ExtForceName,ExtForceIndex,ForceSensorToLab,ForceSensorType,ForceSensorChannels,SensMatrix)
% CREATEEXTERNALFORCE [ BodyMech 3.06.01 ]: declares a new external force to BODY.CONTEXT
% INPUT
%  ExtForceName    : name of the external force
%  ExtForceIndex   : indexnumber of the external forces
%  ForceSensorToLab : transformation matrix from forceplate coordinate system(s) to
%            lab coordinate system. Usually FP corner measurements are used to construct this
%
%  ForceSensorType : either 1,2,3 or 4; 4 is identical 2 except that a 
%             sensitivity matrix is used (definition follows C3D conventions)
%                              TYPE 1     TYPE 2,4      TYPE 3
%
%             CHANNEL (1,i)    Force X     Force X     Force X1,2
%             CHANNEL (2,i)    Force Y     Force Y     Force X3,4
%             CHANNEL (3,i)    Force Z     Force Z     Force Y1,4
%             CHANNEL (4,i)     CoP X      Moment X    Force Y2,3
%             CHANNEL (5,i)     CoP Y      Moment Y    Force Z1
%             CHANNEL (6,i) Free Moment Z  Moment Z    Force Z2
%             CHANNEL (7,i)     n/a          n/a       Force Z3
%             CHANNEL (8,i)     n/a          n/a       Force Z4
%             typical brand     --       AMTI;BERTEC    KISTLER
%
%  ForceSensorChannels: channel numbers that correspond to the analog input file,
%  SensMatrix: optional,only required for type 4 forcesensors
%
% PROCESS
%   Generation of variable that represent a external force to the body 
% OUTPUT
%   GLOBAL: BODY.CONTEXT.ExternalForce : an element is added to the array

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver. 1.0 Creation (Jaap Harlaar VUmc, Amsterdam, November 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

if nargin < 5 
   errordlg({'CREATE_EXTERNAL_FORCE';' ';...
      'wrong input format';...
      ' define a name,number,matrix,type,channels';...
      },...
      '** BODYMECH ERROR') 
   return
end
if nargin < 6 
   SensMatrix=eye(6);
end

if ForceSensorType==4 &  nargin < 6 
   warndlg({'CREATE_EXTERNAL_FORCE';' ';...
      ' missing value';...
      ' type 4 forceplate requires sensitivity matrix ';...
      },...
      '** BODYMECH WARNING') 
end


n_extforces=length(BODY.CONTEXT.ExternalForce);


% check if the name already exists
if n_extforces~=0
   for i=1:n_extforces
      if strcmpi(BODY.CONTEXT.ExternalForce(i).Name,ExtForceName)
         errordlg({'CREATE_EXTERNAL_FORCE';' ';...
               'external force names must be (case insensitive) unique ';...
               ['duplicate force name: ', char(ExtForceName)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end
end

ForceIndex=fix(ExtForceIndex); % number of ForcePLates used
   if n_extforces~=0 & ForceIndex <= n_extforces
      if ~isempty(BODY.CONTEXT.ExternalForce(ForceIndex).Name)
         errordlg({'CREATE_external_force';' ';...
               'external force number already exists';... 
               ['duplicate force number: ', int2str(ForceIndex)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end


% identification 
BODY.CONTEXT.ExternalForce(ForceIndex).Name=ExtForceName;
BODY.CONTEXT.ExternalForce(ForceIndex).Type=ForceSensorType;
BODY.CONTEXT.ExternalForce(ForceIndex).InputFileIndices=ForceSensorChannels;

% reference and  calibration
BODY.CONTEXT.ExternalForce(ForceIndex).ForceSensorToLab=ForceSensorToLab;
BODY.CONTEXT.ExternalForce(ForceIndex).SensMatrix=SensMatrix;

% data
BODY.CONTEXT.ExternalForce(ForceIndex).MeasuredSignals=zeros(0,0); % original recorded ForceSignals [N_CHANNELS N_SAMPLES]
BODY.CONTEXT.ExternalForce(ForceIndex).Signals=zeros(0,0); % calibrated ForceSignals and COP (m)
BODY.CONTEXT.ExternalForce(ForceIndex).TimeGain=[]; 
BODY.CONTEXT.ExternalForce(ForceIndex).TimeOffset=[];

BodyMechFuncFooter
return
% ============================================ 
% END ### CreateExternalForce ###
