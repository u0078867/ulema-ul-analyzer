%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% ##############################################
% ##############################################
% ####                                      ####
% #### BodyMech.m application script        ####
% ####                                      ####
% ####          			                ####
% ####                                      ####
% ##############################################
% ##############################################
% ProjectModel_LowEx_4Segm_Left.m 
% Body Definition 4 segments: foot, lower leg, upper leg and pelvis

% clear previous BODY declaration
ClearBody

CreateBodyHeader('BM_DEMO');

% #########################
% ## Create a body model ##
% #########################
%Create your own segments
%CreateBodySegment('Name_Segment',segment number,[Optotrak LED number]);
%For example:

CreateBodySegment('Left_Foot',1,[1 2 3]); % Segment 1
CreateBodySegment('Left_Shank',2,[4 5 6 7]); % Segment 2
CreateBodySegment('Left_Thigh',3,[8 9 10 11]); % Segment 3
CreateBodySegment('Pelvis',4,[12 13 14 15]); % Segment 4

% ######################################
% ## Define anatomical landmark names ##
% ######################################
BodyMechFuncHeader; 

% Left foot (1)
% Fill in your anatomical landmarks of the foot between the ''
BODY.SEGMENT(1).AnatomicalLandmark(1).Name={'Calcaneus_left'}; 
BODY.SEGMENT(1).AnatomicalLandmark(2).Name={'MTP_I_left'}; % metatarsale I
BODY.SEGMENT(1).AnatomicalLandmark(3).Name={'MTP_V_left'}; % metatarsale V
BODY.SEGMENT(1).AnatomicalLandmark(4).Name={'Malleolus_Lateral_left'}; 
BODY.SEGMENT(1).AnatomicalLandmark(5).Name={'Malleolus_Medial_left'}; 

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

CreateBodyJoint('Left_Ankle',1,[2 1],[Z X Y]); % joint 1
CreateBodyJoint('Left_Knee',2,[3 2],[Z X Y]); % joint 2
CreateBodyJoint('Left_Hip',3,[4 3],[Z X Y]); % joint 3

%###########
% Muscles ##
%###########

CreateBodyMuscle('rectus_femoris_left',1,2,[3 2]);
CreateBodyMuscle('vastus_lateralis_left',2,3,[3 2]);
CreateBodyMuscle('vastus_medialis_left',3,4,[3 2]);
CreateBodyMuscle('biceps_femoris_left',4,5,[3 2]);
CreateBodyMuscle('semitendinosus_left',5,6,[3 2]);
CreateBodyMuscle('gastrocnemius_left',6,7,[2 1]);

%###############
% LAB CONTEXT ##
%###############

CreateBodyContext('LAB_VUmc Amsterdam');

load ForcePlateCorners1999

%load ForcePlateCorners_new_11062003.mat
% load ForcePlateCorners_2003oct28;
[ma2lab,fp2lab]=FixedLabCalibration(FPcornersMAS);
BODY.CONTEXT.MotionCaptureToLab=ma2lab;

CreateExternalForce('grf1',1,fp2lab,2,[10 11 12 13 14 15]);
CreateStylus('Stylus1',6,[16 17 18 19 20 21],'NDprobe06117');

%###############################
% Anatomical Calculation file ##
%###############################
AnatomicalCalculationFunction='DemoAnatCalc_LowEx_4Segm_Left.m'; 
BODY.CONTEXT.AnatomicalCalculationFunction=AnatomicalCalculationFunction;

% END ### DEMOLowEx_Model_4Segm_Left.m ###
