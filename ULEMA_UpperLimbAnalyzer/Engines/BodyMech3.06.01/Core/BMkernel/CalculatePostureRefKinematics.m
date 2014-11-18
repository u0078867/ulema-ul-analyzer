%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CalculatePostureRefKinematics()
% CALCULATEPOSTUREREFKINEMATICS [ BodyMech 3.06.01 ]: calculates all segment kinematics 
% INPUT
%   GLOBAL :BODY.SEGMENT(..).Cluster.KinematicsPose,
%   GLOBAL :BODY.SEGMENT(..).Cluster.PosturePose)
% PROCESS
%   Calculates segment kinematics relative to a reference posture
% OUTPUT
%   GLOBAL : BODY.SEGMENT(..).Cluster.PostureRefKinematicsPose

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

for iSegment=1:length(BODY.SEGMENT),  % for each segment
   if ~isempty( BODY.SEGMENT(iSegment).Name),
      waitbar_txt=['BodyMech calculus, segment ',num2str(iSegment),' please wait...'];
      h_waitbar = waitbar(0,waitbar_txt);
      Nsamples=size(BODY.SEGMENT(iSegment).Cluster.KinematicsPose,3);
      for iSample=1:Nsamples,  % for each time-instance
         if iSample > Nsamples/10*ceil(iSegment*10/Nsamples), 
            waitbar(iSample/Nsamples);
        end
         
         T=BODY.SEGMENT(iSegment).Cluster.KinematicsPose(:,:,iSample )*inv(BODY.SEGMENT(iSegment).Cluster.PosturePose);
         BODY.SEGMENT(iSegment).Cluster.PostureRefKinematicsPose(:,:,iSample )=T;
         
      end
      close(h_waitbar) 
      
   end
end

return

% ============================================ 
% END ### PostureRefSegmentKinematics ###
