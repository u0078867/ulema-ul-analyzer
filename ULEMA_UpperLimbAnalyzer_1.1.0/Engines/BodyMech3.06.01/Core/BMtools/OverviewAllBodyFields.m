%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function OverviewAllBodyFields()
% OVERVIEWALLBODYFIELDS [ BodyMech 3.06.01 ]: list of all possible BODY fields 
%
% PROCESS
%   none

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% all BODY.HEADER fields (from CreateHeader)
    % identification 
BODY.HEADER.Version='3.06.01';
BODY.HEADER.ModelType='<Project>';   
BODY.HEADER.ProjectName;
BODY.HEADER.ProjectCode;
BODY.HEADER.FileName;            
BODY.HEADER.FileCreationDate;    
BODY.HEADER.FileCreationTime;    

BODY.HEADER.Session.Name;
BODY.HEADER.Session.Code;
BODY.HEADER.Session.Investigator;
BODY.HEADER.Session.Date;
BODY.HEADER.Session.Time;
BODY.HEADER.Session.MarkerDataFile;
BODY.HEADER.Session.Remarks;

BODY.HEADER.Subject.Name;
BODY.HEADER.Subject.Code;
BODY.HEADER.Subject.AdmRecordNo;
BODY.HEADER.Subject.Height;
BODY.HEADER.Subject.Weight;
BODY.HEADER.Subject.DateOfBirth;
BODY.HEADER.Subject.Sexe;

BODY.HEADER.Trial.Name;
BODY.HEADER.Trial.Code;
BODY.HEADER.Trial.Time;
BODY.HEADER.Trial.MarkerDataFile; 
BODY.HEADER.Trial.AnalogDataFile; 
BODY.HEADER.Trial.WalkingVelocity;
BODY.HEADER.Trial.Remarks; 
BODY.HEADER.Version
BODY.HEADER.ModelType
BODY.HEADER.ProjectName
BODY.HEADER.ProjectCode
BODY.HEADER.FileName
BODY.HEADER.FileCreationDate
BODY.HEADER.FileCreationTime

% All SEGMENT fields (from CreateSegment)

BODY.SEGMENT.Name;
BODY.SEGMENT.Cluster.MarkerInputFileIndices;
BODY.SEGMENT.Cluster.MarkerCoordinates;
BODY.SEGMENT.Cluster.PosturePose;
BODY.SEGMENT.Cluster.KinematicsMarkers;
BODY.SEGMENT.Cluster.RecordedMarkers;
BODY.SEGMENT.Cluster.AvailableMarkers;
BODY.SEGMENT.Cluster.KinematicsPose;
BODY.SEGMENT.Cluster.PostureRefKinematicsPose;
BODY.SEGMENT.Cluster.TimeGain;
BODY.SEGMENT.Cluster.TimeOffset;
BODY.SEGMENT.StickFigure.ClusterFrameCoordinates
BODY.SEGMENT.StickFigure.Kinematics;
BODY.SEGMENT.StickFigure.TimeGain;
BODY.SEGMENT.StickFigure.TimeOffset;
BODY.SEGMENT.AnatomicalFrame.ToCluster;	% kinematics
BODY.SEGMENT.AnatomicalFrame.KinematicsPose;
BODY.SEGMENT.AnatomicalFrame.TimeGain;
BODY.SEGMENT.AnatomicalFrame.TimeOffset;
BODY.SEGMENT.AnatomicalFrame.MarkerModel;
BODY.SEGMENT.AnatomicalLandmark.Name;
BODY.SEGMENT.AnatomicalLandmark.ProbingPose;
BODY.SEGMENT.AnatomicalLandmark.ClusterFrameCoordinates;
BODY.SEGMENT.AnatomicalLandmark.MarkerInputFileIndex;
BODY.SEGMENT.AnatomicalLandmark.Kinematics;
BODY.SEGMENT.AnatomicalLandmark.TimeGain;
BODY.SEGMENT.AnatomicalLandmark.TimeOffset;

% all JOINT fields (from CreateJoint)
BODY.JOINT.Name;
BODY.JOINT.ProximalSegmentName;
BODY.JOINT.DistalSegmentName;
BODY.JOINT.PostureRefKinematics.Pose;
BODY.JOINT.PostureRefKinematics.DecompositionFormat;
BODY.JOINT.PostureRefKinematics.RotationAngles;
BODY.JOINT.PostureRefKinematics.TimeGain;
BODY.JOINT.PostureRefKinematics.TimeOffset;
BODY.JOINT.AnatomyRefKinematics.Pose;
BODY.JOINT.AnatomyRefKinematics.DecompositionFormat;
BODY.JOINT.AnatomyRefKinematics.RotationAngles;
BODY.JOINT.AnatomyRefKinematics.TimeGain;
BODY.JOINT.AnatomyRefKinematics.TimeOffset;

% all MUSCLE fields (from CreateMuscle)
BODY.MUSCLE.Name;
BODY.MUSCLE.Segments;
BODY.MUSCLE.Emg.InputFileIndices;
BODY.MUSCLE.Emg.Signal;
BODY.MUSCLE.Emg.TimeGain; 
BODY.MUSCLE.Emg.TimeOffset;
BODY.MUSCLE.Emg.Envelope;
BODY.MUSCLE.Emg.EnvelopeTimeGain; 
BODY.MUSCLE.Emg.EnvelopeTimeOffset;
BODY.MUSCLE.Emg.EnvelopeProcessingFilter;

% all CONTEXT fields (from CreateContext)
BODY.CONTEXT.Name;
BODY.CONTEXT.MotionCaptureToLab; % 4x4 transformation matrix from MotionCaptureFrame to labFrame
BODY.CONTEXT.ExternalForce;
BODY.CONTEXT.ExternalForce.Name;
BODY.CONTEXT.ExternalForce.Type;
BODY.CONTEXT.ExternalForce.InputFileIndices;
BODY.CONTEXT.ExternalForce.ForceSensorToLab;
BODY.CONTEXT.ExternalForce.SensMatrix;
BODY.CONTEXT.ExternalForce.MeasuredSignals; % [N_CHANNELS N_SAMPLES]
BODY.CONTEXT.ExternalForce.Signals; 
BODY.CONTEXT.ExternalForce.TimeGain; 
BODY.CONTEXT.ExternalForce.TimeOffset;
BODY.CONTEXT.Stylus;
BODY.CONTEXT.Stylus.Name;
BODY.CONTEXT.Stylus.Type;
BODY.CONTEXT.Stylus.TipPosition;
BODY.CONTEXT.Stylus.ToTipFunction;
BODY.CONTEXT.Stylus.CalibrationDate;
BODY.CONTEXT.Stylus.MarkerInputFileIndices;
BODY.CONTEXT.Stylus.KinematicsMarkers;
BODY.CONTEXT.AnatomicalCalculationFunction;
BODY.CONTEXT.EVENTS;
BODY.CONTEXT.RESULTS;
% =====================================================
% END ### OverviewAllBodyFields ###
