%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CalculateJointKinematics(method)
% CALCULATEJOINTKINEMATICS [ BodyMech 3.06.01 ]: calculates Euler- joint angles 
% INPUT
%    Method : string, either 'AnatomyBased' or 'ReferenceBased'
% PROCESS
%    Calculates the rotationmatrix between two segments
%    Decomposition of the matrix into sequentional rotation angles (Euler, Cardanic)
% OUTPUT
%   Alfa, Beta & Gamma for each joint
%   BODY.JOINT(jnt_id).AnatomyRefKinematics.RotationAngles
%   BODY.JOINT(jnt_id).PostureRefKinematics.RotationAngles

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the 
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader

if nargin < 1 
   errordlg({'CalculateJointKinematics';' ';...
         'no method defined';... 
      },...
      '** BODYMECH ERROR **');
   
   return
end

Njoints=length(BODY.JOINT);

if strcmp(method,'AnatomyBased'),
    % clear old info
    for iJoint=1:Njoints
        if ~isempty(BODY.JOINT(iJoint).Name)
            BODY.JOINT(iJoint).AnatomyRefKinematics.Pose=zeros(4,4,0);
            BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles=zeros(3,0);
        end
    end
    for iJoint=1:Njoints,  % for each joint
        
        ProxSegm=0;
        DistSegm=0;
        for segNr = 1:length(BODY.SEGMENT)
            if strcmp(BODY.JOINT(iJoint).ProximalSegmentName, BODY.SEGMENT(segNr).Name)
                ProxSegm = segNr;
            end
        end
        for segNr = 1:length(BODY.SEGMENT)
            if strcmp(BODY.JOINT(iJoint).DistalSegmentName, BODY.SEGMENT(segNr).Name);
                DistSegm = segNr;
            end
        end
        if DistSegm==0,    
            errordlg({'CalculateJointKinematics';' ';...
                    'no valid distalsegment';},... 
                '** BODYMECH ERROR **');
            return
        end
        
        Nsamples=size(BODY.SEGMENT(DistSegm).Cluster.KinematicsPose,3);
        for iSample=1:Nsamples,  % for each time-instance 
            
            if ProxSegm==0,
                T=BODY.SEGMENT(DistSegm).AnatomicalFrame.KinematicsPose(:,:,iSample); % relative to the global frame
            else
                T=inv(BODY.SEGMENT(ProxSegm).AnatomicalFrame.KinematicsPose(:,:,iSample))...  % (eq.16)
                    * BODY.SEGMENT(DistSegm).AnatomicalFrame.KinematicsPose(:,:,iSample);
            end
            
            BODY.JOINT(iJoint).AnatomyRefKinematics.Pose=...           % concatenate the new transformation matrix
                cat(3,BODY.JOINT(iJoint).AnatomyRefKinematics.Pose, T); % to the 3rd (time-)dimension
            % is equivalent to
            % BODY.JOINT(iJoint).AnatomyRefKinematics.Pose(:,:,iSample)=T;
        end
        
        BODY.JOINT(iJoint).AnatomyRefKinematics.TimeGain=BODY.SEGMENT(DistSegm).Cluster.TimeGain;
        BODY.JOINT(iJoint).AnatomyRefKinematics.TimeOffset=BODY.SEGMENT(DistSegm).Cluster.TimeOffset;
    end
    
elseif strcmp(method,'ReferenceBased')
    for iJoint=1:Njoints
        if ~isempty(BODY.JOINT(iJoint).Name)
            BODY.JOINT(iJoint).PostureRefKinematics.Pose=zeros(4,4,0);
            BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles=zeros(3,0);
        end
    end
    
    for iJoint=1:Njoints, % for each joint
        ProxSegm=0;
        DistSegm=0;
        for segNr = 1:length(BODY.SEGMENT)
            if strcmp(BODY.JOINT(iJoint).ProximalSegmentName, BODY.SEGMENT(segNr).Name)
                ProxSegm = segNr;   % if ProxSegm==0 this is the laboratory frame
            end
        end
        for segNr = 1:length(BODY.SEGMENT)
            if strcmp(BODY.JOINT(iJoint).DistalSegmentName, BODY.SEGMENT(segNr).Name);
                DistSegm = segNr;
            end
        end
        if DistSegm==0,    
            errordlg({'CalculateJointKinematics';' ';...
                    'no valid distalsegment';},... 
                '** BODYMECH ERROR **');
            return
        end
        Nsamples=size(BODY.SEGMENT(DistSegm).Cluster.PostureRefKinematicsPose,3);
        for iSample=1:Nsamples,  % for each time-instance 
            
            if ProxSegm==0,
                T=BODY.SEGMENT(DistSegm).Cluster.PostureRefKinematicsPose(:,:,iSample); % relative to the global frame
            else
                T=inv(BODY.SEGMENT(ProxSegm).Cluster.PostureRefKinematicsPose(:,:,iSample))...  % (eq.16)
                    * BODY.SEGMENT(DistSegm).Cluster.PostureRefKinematicsPose(:,:,iSample);
            end
            
            BODY.JOINT(iJoint).PostureRefKinematics.Pose=...           % concatenate the new transformation matrix
                cat(3,BODY.JOINT(iJoint).PostureRefKinematics.Pose, T); % to the 3rd (time-)dimension
            % is equivalent to
            % BODY.JOINT(iJoint).PostureRefKinematics.Pose(:,:,iSample)=T;
        end
        
        BODY.JOINT(iJoint).PostureRefKinematics.TimeGain=BODY.SEGMENT(DistSegm).Cluster.TimeGain;
        BODY.JOINT(iJoint).PostureRefKinematics.TimeOffset=BODY.SEGMENT(DistSegm).Cluster.TimeOffset;
    end
    
else
    errordlg({'CalculateJointKinematics';' ';...
            'invalid method defined'},...
        '** BODYMECH ERROR **') 
    return
end

%  calculate joint-angles
if strcmp(method,'AnatomyBased')
    for iJoint=1:Njoints,
        if ~isempty(BODY.JOINT(iJoint).AnatomyRefKinematics.Pose),
            jointrot=BODY.JOINT(iJoint).AnatomyRefKinematics.Pose(1:3,1:3,:);
            DecompositionFormat=BODY.JOINT(iJoint).AnatomyRefKinematics.DecompositionFormat;
            for iSample=1:size(jointrot,3),
                actkneerot=jointrot(:,:,iSample);
                [a b]=RotationMatrixToCardanicAngles(jointrot(:,:,iSample),DecompositionFormat);
                x(:,iSample)=a';
                y(:,iSample)=b';
            end
            BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles=180/pi*x;
        end
    end
elseif strcmp(method,'ReferenceBased')
    for iJoint=1:Njoints,
        if ~isempty(BODY.JOINT(iJoint).PostureRefKinematics.Pose),
            jointrot=BODY.JOINT(iJoint).PostureRefKinematics.Pose(1:3,1:3,:);
            DecompositionFormat=BODY.JOINT(iJoint).PostureRefKinematics.DecompositionFormat;
            for iSample=1:size(jointrot,3),
                actkneerot=jointrot(:,:,iSample);
                [a b]=RotationMatrixToCardanicAngles(jointrot(:,:,iSample),DecompositionFormat);
                x(:,iSample)=a';
                y(:,iSample)=b';
            end
            BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles=180/pi*x;
        end    
    end
end

return

% ============================================ 
% END ### CalculateJointKinematics ###
