%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ClearAllButProjectModel()
% CLEARALLBUTPROJECTMODEL [ BodyMech 3.06.01]: Clears (global) BODY content of all Session and Trial fields except PROJECTMODEL
% INPUT
%   none
% PROCESS
%   Clears all BODY Session & Trial fields: BODY content of PROJECTmodel remains
% OUTPUT
%   GLOBAL BODY content for ProjectModel

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

global BODY
% BODY.HEADER fields
% keep ProjectBody fields
BODY.HEADER.Version='3.06.01';
BODY.HEADER.ModelType='<Project>';
BODY.HEADER.ProjectName;
BODY.HEADER.ProjectCode;
BODY.HEADER.FileName';
BODY.HEADER.FileCreationDate;
BODY.HEADER.FileCreationTime;

% clear all SESSION fields
BODY.HEADER.Session.Name='';
BODY.HEADER.Session.Code='';
BODY.HEADER.Session.Investigator='';
BODY.HEADER.Session.Date='';
BODY.HEADER.Session.Time='';
BODY.HEADER.Session.MarkerDataFile='';
BODY.HEADER.Session.Remarks='';
BODY.HEADER.Subject.Name='';
BODY.HEADER.Subject.Code='';
BODY.HEADER.Subject.AdmRecordNo='';
BODY.HEADER.Subject.Height='';
BODY.HEADER.Subject.Weight='';
BODY.HEADER.Subject.DateOfBirth='';
BODY.HEADER.Subject.Sexe='';
% clear all TRIAL fields
BODY.HEADER.Trial.Name='';
BODY.HEADER.Trial.Code='';
BODY.HEADER.Trial.Time='';
BODY.HEADER.Trial.MarkerDataFile='';
BODY.HEADER.Trial.AnalogDataFile='';
BODY.HEADER.Trial.WalkingVelocity='';
BODY.HEADER.Trial.Remarks='';

% SEGMENT

for iSegment=1:length(BODY.SEGMENT),
    % keep PROJECT fields only
    BODY.SEGMENT(iSegment).Name;
    BODY.SEGMENT(iSegment).Cluster.MarkerInputFileIndices;
    BODY.SEGMENT(iSegment).AnatomicalLandmark.Name;
    BODY.SEGMENT(iSegment).AnatomicalLandmark.MarkerInputFileIndex;
    BODY.SEGMENT(iSegment).AnatomicalFrame.MarkerModel;

    % clear all SESSION fields
    BODY.SEGMENT(iSegment).Cluster.MarkerCoordinates=zeros(0,0);
    BODY.SEGMENT(iSegment).Cluster.PosturePose=zeros(4,4,0);
    BODY.SEGMENT(iSegment).AnatomicalFrame.ToCluster=zeros(4,4,0);

    for iA=1:length(BODY.SEGMENT(iSegment).AnatomicalLandmark),
        BODY.SEGMENT(iSegment).AnatomicalLandmark(iA).ProbingPose=zeros(4,4,0);
        BODY.SEGMENT(iSegment).AnatomicalLandmark(iA).ClusterFrameCoordinates=zeros(3,0);
    end

    % clear all TRIAL fields
    BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers=zeros(3,0,0);
    BODY.SEGMENT(iSegment).Cluster.RecordedMarkers=zeros(0,0);
    BODY.SEGMENT(iSegment).Cluster.AvailableMarkers=zeros(0,0);
    BODY.SEGMENT(iSegment).Cluster.KinematicsPose=zeros(4,4,0);
    BODY.SEGMENT(iSegment).Cluster.PostureRefKinematicsPose=zeros(4,4,0);
    BODY.SEGMENT(iSegment).Cluster.TimeGain=[];
    BODY.SEGMENT(iSegment).Cluster.TimeOffset=[];
    for iS=1:length(BODY.SEGMENT(iSegment).StickFigure),
        BODY.SEGMENT(iSegment).StickFigure(iS).ClusterFrameCoordinates=zeros(3,0);
        BODY.SEGMENT(iSegment).StickFigure(iS).Kinematics=zeros(3,0,0);
        BODY.SEGMENT(iSegment).StickFigure(iS).TimeGain=[];
        BODY.SEGMENT(iSegment).StickFigure(iS).TimeOffset=[];
    end

    BODY.SEGMENT(iSegment).AnatomicalFrame.ToCluster=zeros(4,4,0);
    BODY.SEGMENT(iSegment).AnatomicalFrame.KinematicsPose=zeros(4,4,0);
    BODY.SEGMENT(iSegment).AnatomicalFrame.TimeGain=[];
    BODY.SEGMENT(iSegment).AnatomicalFrame.TimeOffset=[];

    for iA=1:length(BODY.SEGMENT(iSegment).AnatomicalLandmark),
        BODY.SEGMENT(iSegment).AnatomicalLandmark(iA).Kinematics=zeros(3,0,0);
        BODY.SEGMENT(iSegment).AnatomicalLandmark(iA).TimeGain=[];
        BODY.SEGMENT(iSegment).AnatomicalLandmark(iA).TimeOffset=[];
    end
end

for iJoint=1:length(BODY.JOINT)
    % keep all PROJECT fields only
    BODY.JOINT(iJoint).Name;
    BODY.JOINT(iJoint).ProximalSegmentName;
    BODY.JOINT(iJoint).DistalSegmentName;
    BODY.JOINT(iJoint).PostureRefKinematics.DecompositionFormat;
    BODY.JOINT(iJoint).AnatomyRefKinematics.DecompositionFormat;

    % clear all SESSION fields
    % clear all TRIAL fields
    BODY.JOINT(iJoint).PostureRefKinematics.Pose=zeros(4,4,0);
    BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles=zeros(3,0);
    BODY.JOINT(iJoint).PostureRefKinematics.TimeGain=[];
    BODY.JOINT(iJoint).PostureRefKinematics.TimeOffset=[];
    BODY.JOINT(iJoint).AnatomyRefKinematics.Pose=zeros(4,4,0);
    BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles=zeros(3,0);
    BODY.JOINT(iJoint).AnatomyRefKinematics.TimeGain=[];
    BODY.JOINT(iJoint).AnatomyRefKinematics.TimeOffset=[];
end

for iMuscle=1:length(BODY.MUSCLE),
    % keep all PROJECT fields only
    BODY.MUSCLE(iMuscle).Name;
    BODY.MUSCLE(iMuscle).Segments;
    BODY.MUSCLE(iMuscle).Emg.InputFileIndices;
    % clear all SESSION fields
    % clear all TRIAL fields
    BODY.MUSCLE(iMuscle).Emg.Signal=[];
    BODY.MUSCLE(iMuscle).Emg.TimeGain=[];
    BODY.MUSCLE(iMuscle).Emg.TimeOffset=[];
    BODY.MUSCLE(iMuscle).Emg.Envelope=[];
    BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeGain=[];
    BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeOffset=[];
    BODY.MUSCLE(iMuscle).Emg.EnvelopeProcessingFilter=[];
end

%---------
% all CONTEXT fields (from CreateContext)
% keep Project Fields
%% deleted june 2007 by Ellen Jaspers - FaBeR, KULeuven (Belgie)%%
%BODY.CONTEXT.Name;
%BODY.CONTEXT.MotionCaptureToLab; % 4x4 transformation matrix from MotionCaptureFrame to labFrame

%for iForce=1:length(BODY.CONTEXT.ExternalForce),
    %BODY.CONTEXT.ExternalForce(iForce).Name;
    %BODY.CONTEXT.ExternalForce(iForce).Type;
    %BODY.CONTEXT.ExternalForce(iForce).InputFileIndices;
    %BODY.CONTEXT.ExternalForce(iForce).ForceSensorToLab;
    %BODY.CONTEXT.ExternalForce(iForce).SensMatrix;

    % clear all SESSION and TRIAL fields
    %BODY.CONTEXT.ExternalForce(iForce).Signals=zeros(0,0); % [N_CHANNELS N_SAMPLES]
    %BODY.CONTEXT.ExternalForce(iForce).MeasuredSignals=zeros(0,0); % [N_CHANNELS N_SAMPLES]
    %BODY.CONTEXT.ExternalForce(iForce).TimeGain=[];
    %BODY.CONTEXT.ExternalForce(iForce).TimeOffset=[];
%end

% keep Project Fields
BODY.CONTEXT.Stylus.Name;
BODY.CONTEXT.Stylus.Type;
BODY.CONTEXT.Stylus.ToTipFunction;
BODY.CONTEXT.Stylus.CalibrationDate;
BODY.CONTEXT.Stylus.MarkerInputFileIndices;
BODY.CONTEXT.AnatomicalCalculationFunction;

% clear all SESSION fields
% clear all TRIAL fields
BODY.CONTEXT.Stylus.TipPosition=[];
BODY.CONTEXT.Stylus.KinematicsMarkers=NaN;
BODY.CONTEXT.EVENTS=[];

% =====================================================================
% END ### ClearAllButProjectModel ###
