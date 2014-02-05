%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function AssignMarkerDataToBody
% ASSIGNMARKERDATATOBODY [ BodyMech 3.06.01 ]: assigns measured data in the appropiate BODY-fields
% INPUT
%   GLOBAL : MARKER_DATA      
%            MARKER_TIME_BASE
% PROCESS 
%   breaks up to data and assigns it according to current BODYdefinition
%   Transforms all data to the laboratory frame
% OUTPUT 
%   GLOBAL : BODY.SEGMENT(..).Cluster.KinematicsMarkers
%            BODY.SEGMENT(..).Cluster.RecordedMarkers 
%            BODY.SEGMENT(..).Cluster.AvailableMarkers 

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, December 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

ClearKinematics('markers')

MotionAnalysisToLab=BODY.CONTEXT.MotionCaptureToLab; 

% ASSIGN MARKER DATA TO BODYSEGMENTS 
% ==============================================
for i=1:length(BODY.SEGMENT),
   if ~isempty( BODY.SEGMENT(i).Name),
      BODY.SEGMENT(i).Cluster.KinematicsMarkers=...
      MARKER_DATA(:,BODY.SEGMENT(i).Cluster.MarkerInputFileIndices,:);  % in m.
      MarkerTrace=shiftdim(BODY.SEGMENT(i).Cluster.KinematicsMarkers(X,:,:));
      % x coordinate represents 3 dimension 
      NanArray=isnan(MarkerTrace);
      for iMarker=1:size(MarkerTrace,1),
         BODY.SEGMENT(i).Cluster.RecordedMarkers(iMarker,:)= NanArray(iMarker,:).*MarkerTrace(iMarker,:)+1;
      end
      
      % equals 1 where visible, NaN when occluded 
      BODY.SEGMENT(i).Cluster.AvailableMarkers=BODY.SEGMENT(i).Cluster.RecordedMarkers;

      % obsolete: BODY.SEGMENT(i).kinematics_sample_frequency=MARKER_SAMPLE_FREQUENCY;
      TimeOffset=MARKER_TIME_OFFSET;
      TimeGain=MARKER_TIME_GAIN;
      BODY.SEGMENT(i).Cluster.TimeGain=TimeGain;
      BODY.SEGMENT(i).Cluster.TimeOffset=TimeOffset;
   end
end

% ==============================================
% transformation from motion analysis coordinates
% to laboratory coordinates
% ==============================================
for i=1:length(BODY.SEGMENT),
   if ~isempty( BODY.SEGMENT(i).Name),
      [ndim,nmarkers,ntime]=size(BODY.SEGMENT(i).Cluster.KinematicsMarkers);
      BODY.SEGMENT(i).Cluster.KinematicsMarkers=...
         cat(1,BODY.SEGMENT(i).Cluster.KinematicsMarkers,ones([1 nmarkers ntime])); % homogenize
      for t=1:ntime,
         BODY.SEGMENT(i).Cluster.KinematicsMarkers(:,:,t)=...
            MotionAnalysisToLab*BODY.SEGMENT(i).Cluster.KinematicsMarkers(:,:,t); % transform to lab coordinates
      end
      BODY.SEGMENT(i).Cluster.KinematicsMarkers=...
         BODY.SEGMENT(i).Cluster.KinematicsMarkers(1:3,:,:); % de-homogenize 
   end
end

BodyMechFuncFooter
return
% ============================================ 
% END ### AssignMarkerDataToBody ###     
