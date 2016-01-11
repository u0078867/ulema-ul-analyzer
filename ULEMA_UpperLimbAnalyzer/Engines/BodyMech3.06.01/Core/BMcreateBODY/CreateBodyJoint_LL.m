%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CreateBodyJoint(JointName,JointIndex,SegmentLinks,DecompositionFormat)
% CREATEBODYJOINT [ BodyMech 3.06.01 ]: declares a new bodyjoint to BODY.JOINT
% INPUT
%   JointName : name of the joint
%   SegmentLinks: [proximal_segment_no distal_segment_no]
%   JointIndex: a priori joint number
%   DecompositionFormat: eulerian; cardanian decomposition format
% PROCESS
%   Generation of variable that represent a joint of the human body
% OUTPUT
%   GLOBAL: BODY.JOINT: new cell in the array of joint names

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, August 1999) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

if nargin < 3
   errordlg({'CREATE_BODYJOINT';' ';...
      'wrong input format';...
      ' define name,jointno,segments [p d],decomposition';...
      },...
      '** BODYMECH ERROR') 
   return
end

if size(SegmentLinks)~=[1 2],
   errordlg({'CREATE_BODYJOINT';' ';...
      'wrong input format';...
      ' define two linked segments';...
      },...
      '** BODYMECH ERROR') 
   return
end
if size(DecompositionFormat)~=[1 3],
   errordlg({'CREATE_BODYJOINT';' ';...
      'wrong input format';...
      ' define a valid decomposition format';...
      },...
      '** BODYMECH ERROR') 
   return
end

n_joints=length(BODY.JOINT);

% check if the name already exists
if n_joints~=0
   for i=1:n_joints
      if strcmpi(BODY.JOINT(i).Name,JointName)
         errordlg({'CREATE_BODYJOINT';' ';...
               'joint names must be (case insensitive) unique ';...
               ['duplicate joint name: ', char(JointName)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end
end

if JointIndex<=0; % no a priori joint number is given
   JointIndex=0;
   if n_joints~=0
      for i=1:n_joints,
         if ~isempty(BODY.JOINT(i).Name) & JointIndex==0,
            JointIndex=i; % first empty free cell is assigned
         end
      end
      if JointIndex == 0, 
         JointIndex=n_joints+1; % a next cell wil be created and assigned
      end
   else
      JointIndex=1;  % first cell 
   end
else
   JointIndex=fix(JointIndex); 
   if n_joints~=0 & JointIndex <= n_joints
      if ~isempty(BODY.JOINT(JointIndex).Name)
         errordlg({'CREATE_BODYJOINT';' ';...
               'joint number already exists';... 
               ['duplicate joint number: ', int2str(JointIndex)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end
end

% create a new bodyjoint 

% identification 
BODY.JOINT(JointIndex).Name=JointName;
if SegmentLinks(1)==0,
    BODY.JOINT(JointIndex).ProximalSegmentName='Global';
    BODY.JOINT(JointIndex).DistalSegmentName=BODY.SEGMENT(SegmentLinks(2)).Name;
elseif SegmentLinks(2)==0,
    BODY.JOINT(JointIndex).ProximalSegmentName='Global';
    BODY.JOINT(JointIndex).DistalSegmentName=BODY.SEGMENT(SegmentLinks(1)).Name;
else
    BODY.JOINT(JointIndex).ProximalSegmentName=BODY.SEGMENT(SegmentLinks(1)).Name;
    BODY.JOINT(JointIndex).DistalSegmentName=BODY.SEGMENT(SegmentLinks(2)).Name;
end
% Posture referenced kinematics
BODY.JOINT(JointIndex).PostureRefKinematics.Pose=nan(4,4,0);
BODY.JOINT(JointIndex).PostureRefKinematics.DecompositionFormat=DecompositionFormat;
BODY.JOINT(JointIndex).PostureRefKinematics.RotationAngles=nan(3,0);
BODY.JOINT(JointIndex).PostureRefKinematics.TimeGain=BODY.SEGMENT(SegmentLinks(1)).Cluster.TimeGain;
BODY.JOINT(JointIndex).PostureRefKinematics.TimeOffset=BODY.SEGMENT(SegmentLinks(1)).Cluster.TimeOffset;

% Anatomy referenced kinematics
BODY.JOINT(JointIndex).AnatomyRefKinematics.Pose=nan(4,4,0);
BODY.JOINT(JointIndex).AnatomyRefKinematics.DecompositionFormat=DecompositionFormat;
BODY.JOINT(JointIndex).AnatomyRefKinematics.RotationAngles=nan(3,0);
BODY.JOINT(JointIndex).AnatomyRefKinematics.TimeGain=BODY.SEGMENT(SegmentLinks(1)).Cluster.TimeGain;
BODY.JOINT(JointIndex).AnatomyRefKinematics.TimeOffset=BODY.SEGMENT(SegmentLinks(1)).Cluster.TimeOffset;

return
% ============================================ 
% END ### CreateBodyJoint ###
