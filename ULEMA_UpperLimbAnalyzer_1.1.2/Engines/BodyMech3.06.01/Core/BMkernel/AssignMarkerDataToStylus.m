%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function AssignMarkerDataToStylus;
% ASSIGNMARKERDATATOSTYLUS [ BodyMech 3.06.01 ]: assigns measured data the the current stylus
% INPUT
%   GLOBAL : MARKER_DATA
%          : MARKER_TIME_BASE
% PROCESS
%   Breaks up to data and assigns it to the stylus 
%   Transforms all data to the laboratory frame
% OUTPUT
%   GLOBAL : BODY.CONTEXT.Stylus.KinematicsMarkers

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, April 2001)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

MotionAnalysisToLab=BODY.CONTEXT.MotionCaptureToLab; 

% ASSIGN MARKER DATA TO STYLUS
StylusMarkerNumbers=BODY.CONTEXT.Stylus.MarkerInputFileIndices;
BODY.CONTEXT.Stylus.KinematicsMarkers=...
   MARKER_DATA(:,StylusMarkerNumbers,:);  % in m.

% homogenize
[ndim,nmarkers,ntime]=size(BODY.CONTEXT.Stylus.KinematicsMarkers);
BODY.CONTEXT.Stylus.KinematicsMarkers=...
   cat(1,BODY.CONTEXT.Stylus.KinematicsMarkers,ones([1 nmarkers ntime])); 

% transform to lab coordinates
for t=1:ntime,
   BODY.CONTEXT.Stylus.KinematicsMarkers(:,:,t)=...
      MotionAnalysisToLab*BODY.CONTEXT.Stylus.KinematicsMarkers(:,:,t); 
end

% de-homogenize 
BODY.CONTEXT.Stylus.KinematicsMarkers=...
   BODY.CONTEXT.Stylus.KinematicsMarkers(1:3,:,:); 

return
% ============================================ 
% END ### AssignMarkerDataToStylus ###     
