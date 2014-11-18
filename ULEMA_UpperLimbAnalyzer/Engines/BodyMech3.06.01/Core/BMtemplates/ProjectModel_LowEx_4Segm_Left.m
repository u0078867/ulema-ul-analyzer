%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% PROJECTMODEL_LOWEX_4SEGM_LEFT [ BodyMech 3.06.01 ]: Template to create New ProjectModel 
% for 4 segments: foot, lower leg, upper leg, pelvis 
% INPUT
%    Input : none
% PROCESS
%   will run to create a BODY with ProjectModel content
% OUTPUT
%   GLOBAL BODY with projectModel content

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% clear previous BODY declaration
ClearBody

CreateBodyHeader('YourProject');

% #########################
% ## Create a body model ##
% #########################
%Create your own segments
%CreateBodySegment('Name_Segment',segment number,[Optotrak LED number]);
%For example:

CreateBodySegment('Left_Foot',1,[1 2 3]); % Segment 1
CreateBodySegment('Left_Shank',2,[4 5 6]); % Segment 2
CreateBodySegment('Left_Thigh',3,[7 8 9]); % Segment 3
CreateBodySegment('Pelvis',4,[10 11 12]); % Segment 4

% ######################################
% ## Define anatomical landmark names ##
% ######################################
BodyMechFuncHeader; 

% Left foot (1)
% Fill in your anatomical landmarks of the foot between the ''
BODY.SEGMENT(1).AnatomicalLandmark(1).Name={'Calcaneus_left'}; 
BODY.SEGMENT(1).AnatomicalLandmark(2).Name={'MTP_I_left'}; % metatarsale I
BODY.SEGMENT(1).AnatomicalLandmark(3).Name={'MTP_V_left'}; % metatarsale V

% Left shank (2)
% Fill in your anatomical landmarks of the lower leg between the ''
BODY.SEGMENT(2).AnatomicalLandmark(1).Name={'Caput_Fibulae_left'}; 
BODY.SEGMENT(2).AnatomicalLandmark(2).Name={'Tuberositas_Tibia_left'}; 
BODY.SEGMENT(2).AnatomicalLandmark(3).Name={'Malleolus_Lateral_left'}; 
BODY.SEGMENT(2).AnatomicalLandmark(4).Name={'Malleolus_Medial_left'}; 

% Left thigh (3)
% Fill in your anatomical landmarks of the upper leg between the ''
BODY.SEGMENT(3).AnatomicalLandmark(1).Name={'Trochanter_Major_left'}; 
BODY.SEGMENT(3).AnatomicalLandmark(2).Name={'Femur_Condyle_Lateral_left'}; 
BODY.SEGMENT(3).AnatomicalLandmark(3).Name={'Femur_Condyle_Medial_left'};

% Pelvis (4)
% Fill in your anatomical landmarks of the pelvis between the ''
BODY.SEGMENT(4).AnatomicalLandmark(1).Name={'ASIS_Right'}; % anterior superior iliac spine right
BODY.SEGMENT(4).AnatomicalLandmark(2).Name={'ASIS_Left'}; % anterior superior iliac spine left
BODY.SEGMENT(4).AnatomicalLandmark(3).Name={'PSIS_Right'}; % posterior superior iliac spine right
BODY.SEGMENT(4).AnatomicalLandmark(4).Name={'PSIS_Left'}; % posterior superior iliac spine left


%##########
% Joints ##
%##########
%Create your own Joints
%CreateBodyJoint('Name_Joint',number joint,[proximal segment, distal segment],[decomposition order]);
%For example:

CreateBodyJoint('Left_Ankle',1,[2 1],[Z X Y]); % joint 1
CreateBodyJoint('Left_Knee',2,[3 2],[Z X Y]); % joint 2
CreateBodyJoint('Left_Hip',3,[4 3],[Z X Y]); % joint 3

%###########
% Muscles ##
%###########
%Create your own muscles
%CreateBodyMuscle('MuscleName', MuscleIndex, EmgChannel,[proximal segment, distal segment])
%For example:

CreateBodyMuscle('rectus_femoris_left',1,8,[3 2]); % muscle 1
CreateBodyMuscle('vastus_lateralis_left',2,9,[3 2]); % muscle 2
CreateBodyMuscle('vastus_medialis_left',3,10,[3 2]); % muscle 3
CreateBodyMuscle('biceps_femoris_left',4,11,[3 2]); % muscle 4
CreateBodyMuscle('semitendinosus_left',5,12,[3 2]); % muscle 5
CreateBodyMuscle('gastrocnemius_left',6,13,[2 1]); % muscle 6
CreateBodyMuscle('soleus_left',7,14,[2 1]); % muscle 7
CreateBodyMuscle('tibialis_ant_left',8,15,[2 1]); % muscle 8

%###############
% LAB CONTEXT ##
%###############
% Lab specific!!
% CreateBodyContext('lab_rehab_VU_amsterdam');
% load ForcePlateCorners_2003oct28;
% [ma2lab,fp2lab]=FixedLabCalibration(FPcornersMAS);
% BODY.CONTEXT.MotionCaptureToLab=ma2lab;

% CreateExternalForce('grf1',1,fp2lab,2,[2 3 4 5 6 7]);
% CreateStylus('Stylus1',6,[13 14 15 16 17 18],'NDprobe06117');

%###############################
% Anatomical Calculation file ##
%###############################
%Fill in the anatomical calculation file of your project. 
%AnatomicalCalculationFunction='AnatCalc_Your_Project.m';

AnatomicalCalculationFunction='AnatCalc_LowEx_4Segm_Left.m';
BODY.CONTEXT.AnatomicalCalculationFunction='AnatCalc_LowEx_4Segm_Left';

%=====================================================================
% END ### ProjectModel_LowEx_4Segm_Left ###
