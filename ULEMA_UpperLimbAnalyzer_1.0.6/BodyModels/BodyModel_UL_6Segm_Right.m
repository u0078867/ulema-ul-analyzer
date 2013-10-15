%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% BODYMODEL_UL_6SEGM_RIGHT [ BodyMech 3.06.01 ]: Create Upper Limb ProjectModel 
% 5 segments: humerus, forearm, hand, acromion (scapula) and
% sternum (trunk)
% INPUT
%    Input : none
% PROCESS
%   will run to create a BODY with ProjectModel content
% OUTPUT
%   GLOBAL BODY with projectModel content

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)
% $ Ver 3.06.02 FaBeR, Leuven, June 2007 (Ellen Jaspers)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% clear previous BODY declaration
ClearBody

CreateBodyHeader('right_UL');

% #############################
% ## create body model       ##
% #############################
% create your own segments

% Markers names
MyLabelSequence{1} = 'RUA1';
MyLabelSequence{2} = 'RUA2';
MyLabelSequence{3} = 'RUA3';
MyLabelSequence{4} = 'RUA4';
MyLabelSequence{5} = 'RLA1';
MyLabelSequence{6} = 'RLA2';
MyLabelSequence{7} = 'RLA3';
MyLabelSequence{8} = 'RLA4';
MyLabelSequence{9} = 'RH1';
MyLabelSequence{10} = 'RH2';
MyLabelSequence{11} = 'RH3';
MyLabelSequence{12} = 'RACR1';
MyLabelSequence{13} = 'RACR2';
MyLabelSequence{14} = 'RACR3';
MyLabelSequence{15} = 'ST1';
MyLabelSequence{16} = 'ST2';
MyLabelSequence{17} = 'ST3';
MyLabelSequence{18} = 'CH1';
MyLabelSequence{19} = 'CH2';
MyLabelSequence{20} = 'CH3';
MyLabelSequence{21} = 'P1';
MyLabelSequence{22} = 'P2';
MyLabelSequence{23} = 'P3';
MyLabelSequence{24} = 'P4';
iP = [21, 22, 23, 24];

PushLabelsToBODY(MyLabelSequence);
CreateBodySegmentAdv('Right_Humerus', 1, [1 2 3 4]);  % segment 1
CreateBodySegmentAdv('Right_Forearm', 2, [5 6 7 8]);  % segment 2
CreateBodySegmentAdv('Right_Hand', 3, [9 10 11]);     % segment 3
CreateBodySegmentAdv('Right_Acromion', 4, [12 13 14]);% segment 4
CreateBodySegmentAdv('Right_Sternum', 5, [15 16 17]); % segment 5
% added March 2009: create bodysegment for chair and H1
CreateBodySegmentAdv('Right_Hum1', 6, [1 2 3 4]);    % segment 6
%CreateBodySegmentAdv('Chair', 7, [18 19 20]);         % segment 7

% #####################################
% ## define anatomic landmark names  ##
% #####################################
BodyMechFuncHeader; 

% right humerus (1)
% anatomical landmarks of the humerus between the ' '
% BODY.SEGMENT(1).AnatomicalLandmark(1).Name=('GHr'); % GH rotation centre
% defined in AnatCalc_UL_5Segm_Right
BODY.SEGMENT(1).AnatomicalLandmark(1).Name=('REL');  % lateral epicondyl
BODY.SEGMENT(1).AnatomicalLandmark(1).SharedWith = {'Right_Forearm'};
BODY.SEGMENT(1).AnatomicalLandmark(2).Name=('REM');  % medial epicondyl
BODY.SEGMENT(1).AnatomicalLandmark(2).SharedWith = {'Right_Forearm'};

% right forearm (2)
% anatomical landmarks of the lowerarm between the ' '
BODY.SEGMENT(2).AnatomicalLandmark(1).Name=('RRS');  % radial styloid
BODY.SEGMENT(2).AnatomicalLandmark(1).SharedWith = {'Right_Humerus'};
BODY.SEGMENT(2).AnatomicalLandmark(2).Name=('RUS');  % ulnar styloid
BODY.SEGMENT(2).AnatomicalLandmark(2).SharedWith = {'Right_Humerus'};

% right hand (3)
% anatomical landmarks of the hand between the ' '
BODY.SEGMENT(3).AnatomicalLandmark(1).Name=('RMC3');     % proc styl metacarpal 3
BODY.SEGMENT(3).AnatomicalLandmark(2).Name=('RMCP2');    % metacarpo-phalangeal 2
BODY.SEGMENT(3).AnatomicalLandmark(3).Name=('RMCP3');    % metacarpo-phalangeal 3
BODY.SEGMENT(3).AnatomicalLandmark(4).Name=('RMCP5');    % metacarpo-phalangeal 5

% right acromion (4)
% anatomical landmarks of the scapula between the ' '
BODY.SEGMENT(4).AnatomicalLandmark(1).Name=('RAA');  % ang acromialis
BODY.SEGMENT(4).AnatomicalLandmark(2).Name=('RAI');  % ang inferior
BODY.SEGMENT(4).AnatomicalLandmark(3).Name=('RTS');  % trig spin scap
BODY.SEGMENT(4).AnatomicalLandmark(4).Name=('RPC');  % proc coraco�deus
BODY.SEGMENT(4).AnatomicalLandmark(5).Name=('RAC');  % art acromioclavicularis

% right sternum (5)
% anatomical landmarks of the trunk between the ' '
BODY.SEGMENT(5).AnatomicalLandmark(1).Name=('C7');  % proc spin C7
BODY.SEGMENT(5).AnatomicalLandmark(2).Name=('T8');  % proc spin T8
BODY.SEGMENT(5).AnatomicalLandmark(3).Name=('IJ');  % inc jungularis
BODY.SEGMENT(5).AnatomicalLandmark(4).Name=('PX');  % proc xypho�deus

% right hum1 (6)
% anatomical landmarks of the humerus between the ' '
BODY.SEGMENT(6).AnatomicalLandmark(1).Name=('REL');  % lateral epicondyl
BODY.SEGMENT(6).AnatomicalLandmark(2).Name=('REM');  % medial epicondyl


% ####################
% ## create joints  ##
% ####################
% create upper limb joints
% CreateBodyJoint ('Name_Joint', number joint, [proximal segment, distal
% segment], [decomposition order]);

%CreateBodyJoint('Right_Shoulder', 1, [4 1], [Y X Y],'SecondSolution');      % joint 1 humerus relative to scapula (ISB)
CreateBodyJoint('Right_H2Shoulder', 1, [5 1], [Y X Y],'SecondSolution');     % joint 1 humerus relative to trunk
CreateBodyJoint('Right_H1Shoulder', 2, [5 6], [Y X Y],'SecondSolution');     % joint 2 hum1 (H1 ACFrelative to trunk (ISB decomposition)
CreateBodyJoint('Right_Elbow', 3, [6 2], [Z X Y],'FirstSolution');          % joint 3 forearm relative to humerusH1
CreateBodyJoint('Right_Wrist', 4, [2 3], [Z X Y],'FirstSolution');          % joint 4 hand relative to forearm
CreateBodyJoint('Right_Scapula', 5, [5 4], [Y X Z],'FirstSolution');        % joint 5 scapula relative to trunk
CreateBodyJoint('Right_Trunk', 6, [5 0], [Y X Z],'FirstSolution');          % joint 6 trunk relative to global lab frame 
% global lab frame: y = lateral axis, x = forward axis and z = upward axis
% --> decomposition order fl-abd-rot = lat axis(Y), forw axis(X), upw axis(Z)
% added March 2009
CreateBodyJoint('Right_H2Sh1', 7, [5 1], [Z X Y],'FirstSolution');     % joint 7 humerus (H2 ACF) relative to trunk (FL ABD ROT)
CreateBodyJoint('Right_H2Sh2', 8, [5 1], [X Z Y],'FirstSolution');     % joint 8 humerus (H2 ACF) relative to trunk (ABD FL ROT)
CreateBodyJoint('Right_H1Sh1', 9, [5 6], [Z X Y],'FirstSolution');     % joint 9 hum1 (H1 ACF) relative to trunk (FL ABD ROT)
CreateBodyJoint('Right_H1Sh2', 10, [5 6], [X Z Y],'FirstSolution');    % joint 10 hum1 (H1 ACFrelative to trunk (ABD FL ROT)
%CreateBodyJoint('Right_Trunk', , [7 5], [Z X Y],'FirstSolution');    % joint  trunk relative to chair frame 

% ####################
% ## name angles    ##
% ####################

SetAnglesMeaning(1, [1 1 1], {'RElevationplaneH2', 'RShoulderElevationH2', 'RShoulderRotationH2'});
SetAnglesMeaning(2, [1 1 1], {'RElevationplaneH1', 'RShoulderElevationH1', 'RShoulderRotationH1'});
SetAnglesMeaning(3, [1 0 1], {'RElbowFlExt', '', 'RElbowProSupination'});
SetAnglesMeaning(4, [1 1 0], {'RWristFlExt', 'RWristDeviation', ''});
SetAnglesMeaning(5, [1 1 1], {'RScapProRetraction', 'RScapRotation', 'RScapTilting'});
SetAnglesMeaning(6, [1 1 1], {'RTrunkFlExt', 'RTrunkLateralFl', 'RTrunkAxialRotation'});

SetAnglesMeaning(7, [1 1 1], {'RH2SAG_Flexion', 'RH2SAG_Abduction', 'RH2SAG_Rotation'});
SetAnglesMeaning(8, [1 1 1], {'RH2FRONT_Abduction', 'RH2FRONT_Flexion', 'RH2FRONT_Rotation'});
SetAnglesMeaning(9, [1 1 1], {'RH1SAG_Flexion', 'RH1SAG_Abduction', 'RH1SAG_Rotation'});
SetAnglesMeaning(10, [1 1 1], {'RH1FRONT_Abduction', 'RH1FRONT_Flexion', 'RH1FRONT_Rotation'});

% ##################
% ## LAB CONTEXT  ##
% ##################
% Lab specific!!
% CreateBodyContext('ClinMotionAnalysis_lab_UZPellenberg');

BODY.CONTEXT.MotionCaptureToLab=eye(4);

% ##################################
% ## Anatomical Calculation file  ##
% ##################################
%anatomical calculation file of UL project. 
%AnatomicalCalculationFunction='AnatCalc_Your_Project.m';

% AnatomicalCalculationFunction='AnatCalc_UL_6Segm_Right.m';
% BODY.CONTEXT.AnatomicalCalculationFunction='AnatCalc_UL_6Segm_Right';

%========================================================================
% END ### BodyModel_UL_5Segm_Right ###
