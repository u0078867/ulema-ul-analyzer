%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CreateBodySegmentAdv(SegmentName,SegmentId,MarkerList)
% CREATEBODYSEGMENT [ BodyMech 3.06.01 ]: declares a new bodysegment to BODY.SEGMENT
% INPUT
%   SegmentName : name of the segment
%   SegmentId   : number of the segment (optional)
%   MarkerList  : list of marker indeces assigned to the bodysegment (optional)
% PROCESS
%   Generation of variable that represent a rigid body of the human body
% OUTPUT
%   GLOBAL: BODY.SEGMENT: (first free) cell in the array of segment names is assigned 

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Davide Monari, Pellenberg Kliniek, Leuven, October 2011) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

if nargin < 1 
   errordlg({'CREATE_BODYSEGMENT';' ';...
      'wrong input format';...
      ' define a body segmentname';...
      },...
      '** BODYMECH ERROR') 
   return
end

n_segments=length(BODY.SEGMENT);

% check if the name already exists
if n_segments~=0
   for i=1:n_segments
      if strcmpi(BODY.SEGMENT(i).Name,SegmentName)
         errordlg({'CREATE_BODYSEGMENT';' ';...
               'segment names must be (case insensitive) unique ';...
               ['duplicate segment name: ', char(SegmentName)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end
end

if nargin < 2, % no a priori segment number is given
   SegmentId=0;
   if n_segments~=0
      for i=1:n_segments
         if ~isempty(BODY.SEGMENT(i).Name) & SegmentId==0,
            SegmentId=i; % first empty free cell is assigned
         end
      end
      if SegmentId== 0, 
         SegmentId=n_segments+1; % a next cell wil be created and assigned
      end
   else
      SegmentId=1;  % first cell 
   end
else
   SegmentId=fix(SegmentId); 
   if n_segments~=0 & SegmentId <= n_segments
      if ~isempty(BODY.SEGMENT(SegmentId).Name)
         errordlg({'CREATE_BODYSEGMENT';' ';...
               'segment number already exists';... 
               ['duplicate segment number: ', int2str(SegmentId)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end
end


if nargin<3,
   MarkerList=[];
end
   
   
% create a new bodysegment 

% SEGMENT identification 
BODY.SEGMENT(SegmentId).Name=SegmentName;
% SEGMENT.Cluster fields
BODY.SEGMENT(SegmentId).Cluster.MarkerInputFileIndices=MarkerList;
if max(MarkerList) <= length(BODY.CONTEXT.MarkerLabels)
    BODY.SEGMENT(SegmentId).Cluster.MarkerLabels=BODY.CONTEXT.MarkerLabels(MarkerList);
else
    BODY.SEGMENT(SegmentId).Cluster.MarkerLabels=[];
    errordlg({'CREATE_BODYSEGMENT';' ';...
               'segment number already exists';... 
               ['Index out of marker labels list for segment: ',int2str(SegmentId)];...
            },...
            '** BODYMECH ERROR') 
         return
end
BODY.SEGMENT(SegmentId).Cluster.MarkerCoordinates=zeros(0,0);
	% reference and anatomical calibration
BODY.SEGMENT(SegmentId).Cluster.PosturePose=zeros(4,4,0);
	% kinematics
BODY.SEGMENT(SegmentId).Cluster.KinematicsMarkers=zeros(3,0,0);
BODY.SEGMENT(SegmentId).Cluster.RecordedMarkers=zeros(0,0);
BODY.SEGMENT(SegmentId).Cluster.AvailableMarkers=zeros(0,0);
BODY.SEGMENT(SegmentId).Cluster.KinematicsPose=zeros(4,4,0);
BODY.SEGMENT(SegmentId).Cluster.PostureRefKinematicsPose=zeros(4,4,0);
	% time
BODY.SEGMENT(SegmentId).Cluster.TimeGain=0;
BODY.SEGMENT(SegmentId).Cluster.TimeOffset=0;

% SEGMENT.StickFigure fields
	% reference and anatomical calibration
BODY.SEGMENT(SegmentId).StickFigure.ClusterFrameCoordinates=zeros(3,0);
	% kinematics
BODY.SEGMENT(SegmentId).StickFigure.Kinematics=zeros(3,0,0);
	% time
BODY.SEGMENT(SegmentId).StickFigure.TimeGain=0;
BODY.SEGMENT(SegmentId).StickFigure.TimeOffset=0;

% SEGMENT.AnatomicalFrame fields
	% reference and anatomical calibration
BODY.SEGMENT(SegmentId).AnatomicalFrame.ToCluster=zeros(4,4,0);	% kinematics
	% kinematics
BODY.SEGMENT(SegmentId).AnatomicalFrame.KinematicsPose=zeros(4,4,0);
	% time
BODY.SEGMENT(SegmentId).AnatomicalFrame.TimeGain=0;
BODY.SEGMENT(SegmentId).AnatomicalFrame.TimeOffset=0;
	% model
BODY.SEGMENT(SegmentId).AnatomicalFrame.MarkerModel=[''];

% SEGMENT.AnatomicalLandmark fields
	% reference and anatomical calibration
BODY.SEGMENT(SegmentId).AnatomicalLandmark.Name={};
BODY.SEGMENT(SegmentId).AnatomicalLandmark.ProbingPose=zeros(4,4,0);
BODY.SEGMENT(SegmentId).AnatomicalLandmark.ClusterFrameCoordinates=zeros(3,0);
BODY.SEGMENT(SegmentId).AnatomicalLandmark.MarkerInputFileIndex=0;
	% kinematics
BODY.SEGMENT(SegmentId).AnatomicalLandmark.Kinematics=zeros(3,0,0);
	% time
BODY.SEGMENT(SegmentId).AnatomicalLandmark.TimeGain=0;
BODY.SEGMENT(SegmentId).AnatomicalLandmark.TimeOffset=0;


BodyMechFuncFooter
return
% =============================== 
% END ### CreateBodySegment ###
