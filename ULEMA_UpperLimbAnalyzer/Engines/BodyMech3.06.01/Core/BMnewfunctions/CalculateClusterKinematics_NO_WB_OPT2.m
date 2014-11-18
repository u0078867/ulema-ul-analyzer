%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CalculateClusterKinematics_NO_WB_OPT2(segment_range)
% CALCULATECLUSTERKINEMATICS [ BodyMech 3.06.01 ]: Estimation of the transformation matrix
% INPUT
%   segment_range : vector of segment numbers (of actual BODY definition) to use 
%   global: BODY.SEGMENT(segment_no).Cluster.MarkerCoordinates
%           BODY.SEGMENT(segment_no).Cluster.KinematicsMarkers 
%           BODY.SEGMENT(segment_no).Cluster.AvailableMarkers
% PROCESS
%   Application of rigid_body transformation for each time-instance 
%   only valid markers are selected
% OUTPUT
%   GLOBAL BODY.SEGMENT(segment_no).Cluster.KinematicsPose

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, August 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader
% keyboard

% initialisation 

% INPUT checks
if nargin==0 
   disp('>> BodyMech.m APPLICATION ERROR:')
   disp('>> segment_no must be present')
   error(' wrong input format')
   return
elseif min(segment_range) < 1 | max(segment_range)>length(BODY.SEGMENT)
   disp('>> BodyMech.m APPLICATION ERROR:')
   disp('>> segment_no must be actual')
   error(' input out of range')
   return

end

for r = segment_range
    [n_coord,n_markers,n_samples]=size(BODY.SEGMENT(segment_range(r)).Cluster.KinematicsMarkers);
    if n_coord~=3 
       disp('>> BodyMech.m APPLICATION ERROR:')
       disp('>> 3 coordinates per marker are needed')
       error(' dimension error')
       return
    end
end

% PROCESS
% initialize an empty pose-matrix

for r = segment_range
    
    segment_no = segment_range(r);
    [n_coord,n_markers,n_samples]=size(BODY.SEGMENT(segment_no).Cluster.KinematicsMarkers);
    BODY.SEGMENT(segment_no).Cluster.KinematicsPose=zeros(4,4,n_samples);

    if ~isempty(BODY.SEGMENT(segment_no).Cluster.MarkerCoordinates)

        % waitbar_txt=['BodyMech calculus, segment ',num2str(segment_no),' please wait...'];
        % h_waitbar = waitbar(0,waitbar_txt);
%         LocalCoordinates=zeros(Z-X+1, 100, n_markers);
%         GlobalCoordinates=zeros(Z-X+1, 100, n_markers);
%         for i=1:n_samples,
    %         if i > n_samples/10*ceil(i*10/n_samples), 
    %             waitbar(i/n_samples);
    %         end

%             k=0;
%             for j=1:n_markers, % determine the actual valid markers for this time-instance "i"
%                 if BODY.SEGMENT(segment_no).Cluster.AvailableMarkers(j,i)==1,
%                     k=k+1;
                    LocalCoordinates = BODY.SEGMENT(segment_no).Cluster.MarkerCoordinates;
                    GlobalCoordinates = BODY.SEGMENT(segment_no).Cluster.KinematicsMarkers;
%                 end
%             end
%             LocalCoordinates = LocalCoordinates(:,1:k);
%             GlobalCoordinates = GlobalCoordinates(:,1:k,:);
%             if k >= 3,
%                 [R,t]=RigidBodyTransformation(LocalCoordinates,GlobalCoordinates);
%                 T=[R,t; 0 0 0 1];
%             else
%                 T=NaN*eye(4);
%             end

%             BODY.SEGMENT(segment_no).Cluster.KinematicsPose=cat(3,...    % OUTPUT:
%                 BODY.SEGMENT(segment_no).Cluster.KinematicsPose,...       % concatenate the new transformation matrix 
%                 T );                                                       % to the 3rd (time-)

            T = RigidBodyTransformation_VECT_OPT(LocalCoordinates,GlobalCoordinates);
            BODY.SEGMENT(segment_no).Cluster.KinematicsPose = T;
            
%         end
        % close(h_waitbar) 
    end
end

BodyMechFuncFooter
return
% ============================================ 
% END ### CalculateClusterKinematics ###
