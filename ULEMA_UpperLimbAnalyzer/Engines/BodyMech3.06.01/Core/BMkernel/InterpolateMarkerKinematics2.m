%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function InterpolateMarkerKinematics2
% INTERPOLATEMARKERKINEMATICS [ BodyMech 3.06.01 ]: interpolates all marker-signalsarray 
% INPUT
%   GLOBAL: BODY.SEGMENT(..).Cluster.KinematicsMarkers
%   GLOBAL: BODY.SEGMENT(..).Cluster.RecordedMarkers
%   CriticalHole : warninglevel
% PROCESS
%   Interpolates "holes" in the signal and smoothes the signal
%   uses GCVSPL  
% OUTPUT
%   GLOBAL: BODY.SEGMENT(..).Cluster.KinematicsMarkers
%   GLOBAL: BODY.SEGMENT(..).Cluster.AvailableMarkers

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

warning('off','MATLAB:dispatcher:InexactMatch')
% declaration
BodyMechFuncHeader

% initialisation 

Nsegments=length(BODY.SEGMENT);
if Nsegments > 0,  
   for iSegment=1:Nsegments, % for each segment
      if ~isempty( BODY.SEGMENT(iSegment).Name),
         if ~isempty(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers),
            [Ndim,Nmarkers,Nsamples]=size(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers);
            SegmentHoles=cell([1,Nmarkers]);
            
            for iMarker=1:Nmarkers,
                              
               Array=BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,iMarker,:);
               
               Array(isnan(Array)) = 0;
               
               BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,iMarker,:) = Array;
               
            end % next marker
         end % no marker kinematics
      end % no segment.name
   end % next segment
else % no BODY.SEGMENTS
   return
end

% OUTPUT     
% 
%

return
% ============================================ 
% END ### InterpolateMarkerKinematics ###
