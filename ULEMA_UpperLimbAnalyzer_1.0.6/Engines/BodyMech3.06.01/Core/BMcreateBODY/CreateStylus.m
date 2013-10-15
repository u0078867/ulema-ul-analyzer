%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CreateStylus(StylusName,StylusType,StylusIndex,StylusToTipFunction,StylusGeometryParams)
% CREATESTYLUS [ BodyMech 3.06.01 ]: declares a new stylus to BODY.CONTEXT
% INPUT 
%   StylusName          :  name of stylus 
%   StylusType          :  tracking sensor(0) or #markers(>=1) 
%   StylusToTipFunction :  .m function
%   StylusIndex         : StylusType==1+: list of marker labels assigned to the Stylus 
%                       : StylusType==0 : tracking sensor no.
%   StylusGeometryParams: structure containing geometric parameters of the pointer
% PROCESS
%   Generation of variable that represent a stylus, to be used in anatomical calibration
% OUTPUT
%   GLOBAL: BODY.CONTEXT.Stylus

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver. 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, April 2001) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

if nargin < 1 
   errordlg({'CREATE_Stylus';' ';...
         'wrong input format';...
         ' define stylus inputvariables';...
      },...
      '** BODYMECH ERROR') 
   return
elseif nargin < 2
   if StylusType==1,
      StylusToTipFunction='nop';
      StylusIndex=0;
   else
        errordlg({'CREATE_Stylus';' ';...
         'wrong input format';...
         ' define stylus inputvariables';...
      },...
      '** BODYMECH ERROR')    
   end
elseif nargin < 3 & ischar(StylusIndex),
   StylusToTipFunction=StylusIndex;
   StylusIndex=0;
elseif nargin < 3
   errordlg({'CREATE_Stylus';' ';...
         'wrong input format';...
         ' define stylus inputvariables';...
      },...
      '** BODYMECH ERROR')
elseif ~ischar(StylusToTipFunction)
      errordlg({'CREATE_Stylus';' ';...
         'wrong input format';...
         ' define stylus inputvariables';...
      },...
      '** BODYMECH ERROR')
end


Nstylus=length(BODY.CONTEXT.Stylus);

% check if the name already exists
if Nstylus~=0
   for i=1:Nstylus
      if strcmpi(BODY.CONTEXT.Stylus(i).Name,StylusName)
         errordlg({'CREATE_STYLUS';' ';...
               'name of stylus must be (case insensitive) unique ';...
               ['duplicate stylus name: ', char(StylusName)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end
end

n_segments=length(BODY.SEGMENT);

if StylusType ==0  % Stylus is a tracking sensor
   if StylusIndex<=0, % no a priori segment number is given
      StylusIndex=0;
      if n_segments~=0
         for i=1:n_segments
            if ~isempty(BODY.SEGMENT(i).Name) & StylusIndex==0,
               StylusIndex=i; % first empty free cell is assigned
            end
         end
         if StylusIndex == 0, 
            StylusIndex=n_segments+1; % a next cell wil be created and assigned
         end
      else
         StylusIndex=1;  % first cell 
      end
   else
      StylusIndex=fix(StylusIndex); 
      if n_segments~=0 & StylusIndex <= n_segments
         if ~isempty(BODY.SEGMENT(StylusIndex).name)
            errordlg({'CREATE_STYLUS';' ';...
                  'Stylus segment-number already exists';... 
                  ['duplicate segment number: ', int2str(StylusIndex)];...
               },...
               '** BODYMECH ERROR') 
            return
         end
      end
   end
   
elseif StylusType >=1 % Stylus is a set of markers
   if StylusIndex<=0, % no a priori marker numbers are declared
      StylusIndex=0;
      MaxMarkerLabel=0;
      if n_segments~=0
         for i=1:n_segments
            if ~isempty(BODY.SEGMENT(i).Cluster.MarkerInputFileIndices)
               CurrentMaxMarkerLabel=max(BODY.SEGMENT(i).Cluster.MarkerInputFileIndices);
               MaxMarkerLabel=max(CurrentMaxMarkerLabel,MaxMarkerLabel);
            end
         end
      end
      StylusIndex=MaxMarkerLabel+[1:StylusType]; % next set of free markers is assigned
      
   else
      % sorry, no check on consistency declared marker-labels with segment marker-labels
   end
else 
   errordlg({'CREATE_Stylus';' ';...
         'wrong input format';...
         ' define valid StylusType';...
      },...
      '** BODYMECH ERROR') 
   return
end
% create stylus 

BODY.CONTEXT.Stylus.Name=StylusName;
BODY.CONTEXT.Stylus.Type=StylusType;
BODY.CONTEXT.Stylus.TipPosition=[];
BODY.CONTEXT.Stylus.ToTipFunction=StylusToTipFunction;
BODY.CONTEXT.Stylus.CalibrationDate=[];
BODY.CONTEXT.Stylus.MarkerInputFileIndices=StylusIndex;
BODY.CONTEXT.Stylus.KinematicsMarkers=NaN;
BODY.CONTEXT.Stylus.StylusGeometryParams=StylusGeometryParams; 

return
% ============================================ 
% END ### CreateStylus ###
