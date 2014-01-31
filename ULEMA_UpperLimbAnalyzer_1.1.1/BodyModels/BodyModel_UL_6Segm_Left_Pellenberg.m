%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% BODYMODEL_UL_6SEGM_LEFT [ BodyMech 3.06.01 ]: Create Upper Limb ProjectModel 
% for 5 segments: humerus, forearm, hand, trunk and scapula
% INPUT
%    Input : none
% PROCESS
%   will run to create a BODY with ProjectModel content
% OUTPUT
%   GLOBAL BODY with projectModel content

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)
% $ Ver 3.06.02 FaBeR, Leuven, December 2007 (Ellen Jaspers)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% clear previous BODY declaration
ClearBody

CreateBodyHeader('left_UL');
% #############################
% ## create body model       ##
% #############################
% create your own segments

% Markers names
MyLabelSequence{1} = 'LUA1';
MyLabelSequence{2} = 'LUA2';
MyLabelSequence{3} = 'LUA3';
MyLabelSequence{4} = 'LUA4';
MyLabelSequence{5} = 'LFA1';
MyLabelSequence{6} = 'LFA2';
MyLabelSequence{7} = 'LFA3';
MyLabelSequence{8} = 'LFA4';
MyLabelSequence{9} = 'LH1';
MyLabelSequence{10} = 'LH2';
MyLabelSequence{11} = 'LH3';
MyLabelSequence{12} = 'LACR1';
MyLabelSequence{13} = 'LACR2';
MyLabelSequence{14} = 'LACR3';
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

MyLabelSequence{25} = 'LEL';
MyLabelSequence{26} = 'LEM';
MyLabelSequence{27} = 'LRS';
MyLabelSequence{28} = 'LUS';
MyLabelSequence{29} = 'LMC3';
MyLabelSequence{30} = 'LMCP2';
MyLabelSequence{31} = 'LMCP3';
MyLabelSequence{32} = 'LMCP5';
MyLabelSequence{33} = 'LAA';
MyLabelSequence{34} = 'LAI';
MyLabelSequence{35} = 'LTS';
MyLabelSequence{36} = 'LPC';
MyLabelSequence{37} = 'LAC';
MyLabelSequence{38} = 'C7';
MyLabelSequence{39} = 'T8';
MyLabelSequence{40} = 'IJ';
MyLabelSequence{41} = 'PX';

iP = [21, 22, 23, 24];

PushLabelsToBODY(MyLabelSequence);
CreateBodySegmentAdv('Left_Humerus', 1, [1 2 3 4]);  % segment 1
CreateBodySegmentAdv('Left_Forearm', 2, [5 6 7 8]);  % segment 2
CreateBodySegmentAdv('Left_Hand', 3, [9 10 11]);     % segment 3
CreateBodySegmentAdv('Left_Acromion', 4, [12 13 14]);% segment 4
CreateBodySegmentAdv('Left_Sternum', 5, [15 16 17]); % segment 5
% added March 2009: create bodysegment for chair and H1
CreateBodySegmentAdv('Left_Hum1', 6, [1 2 3 4]);    % segment 6
%CreateBodySegmentAdv('Chair', 7, [18 19 20]);       % segment 7

% #####################################
% ## define anatomic landmark names  ##
% #####################################
BodyMechFuncHeader; 

% left humerus (1)
% anatomical landmarks of the humerus between the ' '
% BODY.SEGMENT(1).AnatomicalLandmark(1).Name=('GHr'); % GH rotation centre
% defined in AnatCalc_UL_6Segm_Right
BODY.SEGMENT(1).AnatomicalLandmark(1).Name=('LEL');  % lateral epicondyl
BODY.SEGMENT(1).AnatomicalLandmark(1).SharedWith = {'Left_Forearm'};
BODY.SEGMENT(1).AnatomicalLandmark(2).Name=('LEM');  % medial epicondyl
BODY.SEGMENT(1).AnatomicalLandmark(2).SharedWith = {'Left_Forearm'};

% left forearm (2)
% fill in anatomical landmarks of the lowerarm between the ' '
BODY.SEGMENT(2).AnatomicalLandmark(1).Name=('LRS');  % radial styloid
BODY.SEGMENT(2).AnatomicalLandmark(1).SharedWith = {'Left_Humerus'};
BODY.SEGMENT(2).AnatomicalLandmark(2).Name=('LUS');  % ulnar styloid
BODY.SEGMENT(2).AnatomicalLandmark(2).SharedWith = {'Left_Humerus'};

% left hand (3)
% anatomical landmarks of the hand between the ' '
BODY.SEGMENT(3).AnatomicalLandmark(1).Name=('LMC3');     % proc styl metacarpal 3
BODY.SEGMENT(3).AnatomicalLandmark(2).Name=('LMCP2');    % metacarpo-phalangeal 2
BODY.SEGMENT(3).AnatomicalLandmark(3).Name=('LMCP3');    % metacarpo-phalangeal 3
BODY.SEGMENT(3).AnatomicalLandmark(4).Name=('LMCP5');    % metacarpo-phalangeal 5

% left acromion (4)
% anatomical landmarks of the scapula between the ' '
BODY.SEGMENT(4).AnatomicalLandmark(1).Name=('LAA');  % ang acromialis
BODY.SEGMENT(4).AnatomicalLandmark(2).Name=('LAI');  % ang inferior
BODY.SEGMENT(4).AnatomicalLandmark(3).Name=('LTS');  % trig spin scap
BODY.SEGMENT(4).AnatomicalLandmark(4).Name=('LPC');  % proc coraco�deus
BODY.SEGMENT(4).AnatomicalLandmark(5).Name=('LAC');  % art acromioclavicularis

% left sternum (5)
% anatomical landmarks of the trunk between the ' '
BODY.SEGMENT(5).AnatomicalLandmark(1).Name=('C7');  % proc spin C7
BODY.SEGMENT(5).AnatomicalLandmark(2).Name=('T8');  % proc spin T8
BODY.SEGMENT(5).AnatomicalLandmark(3).Name=('IJ');  % inc jungularis
BODY.SEGMENT(5).AnatomicalLandmark(4).Name=('PX');  % proc xypho�deus

% left hum1 (6)
% anatomical landmarks of the humerus between the ' '
BODY.SEGMENT(6).AnatomicalLandmark(1).Name=('LEL');  % lateral epicondyl
BODY.SEGMENT(6).AnatomicalLandmark(2).Name=('LEM');  % medial epicondyl

% ####################
% ## create joints  ##
% ####################
% create upper limb joints
% CreateBodyJoint ('Name_Joint', number joint, [proximal segment, distal
% segment], [decomposition order]);

%CreateBodyJoint('Left_Shoulder', 1, [4 1], [Y X Y],'SecondSolution');   % joint 1 humerus relative to scapula (ISB)
CreateBodyJoint('Left_H2Shoulder', 1, [5 1], [Y X Y],'FirstSolution');  % joint 1 humerus relative to trunk
CreateBodyJoint('Left_H1Shoulder', 2, [5 6], [Y X Y],'FirstSolution');  % joint 2 hum1 (H1 ACFrelative to trunk (ISB decomposition)
CreateBodyJoint('Left_Elbow', 3, [6 2], [Z X Y],'FirstSolution');       % joint 3 forearm relative to humerusH1
CreateBodyJoint('Left_Wrist', 4, [2 3], [Z X Y],'FirstSolution');       % joint 4 hand relative to forearm
CreateBodyJoint('Left_Scapula', 5, [5 4], [Y X Z],'FirstSolution');     % joint 5 scapula relative to trunk
CreateBodyJoint('Left_Trunk', 6, [5 0], [Y X Z],'FirstSolution');       % joint 6 trunk relative to global lab frame 
% global lab frame: y = lateral axis, x = forward axis and z = upward axis
% --> decomposition order fl-abd-rot = lat axis(Y), forw axis(X), upw axis(Z)
% added March 2009
CreateBodyJoint('Left_H2Sh1', 7, [5 1], [Z X Y],'FirstSolution');       % joint 7 humerus (H2 ACF) relative to trunk (FL ABD ROT)
CreateBodyJoint('Left_H2Sh2', 8, [5 1], [X Z Y],'FirstSolution');       % joint 8 humerus (H2 ACF) relative to trunk (ABD FL ROT)
CreateBodyJoint('Left_H1Sh1', 9, [5 6], [Z X Y],'FirstSolution');       % joint 9 hum1 (H1 ACF) relative to trunk (FL ABD ROT)
CreateBodyJoint('Left_H1Sh2', 10, [5 6], [X Z Y],'FirstSolution');      % joint 10 hum1 (H1 ACFrelative to trunk (ABD FL ROT)
%CreateBodyJoint('Right_Trunk', , [7 5], [Z X Y],'FirstSolution');      % joint  trunk relative to chair frame 

% ####################
% ## name angles    ##
% ####################

SetAnglesMeaning(1, [-1 -1 -1], {'LElevationplaneH2', 'LShoulderElevationH2', 'LShoulderRotationH2'});
SetAnglesMeaning(2, [-1 -1 -1], {'LElevationplaneH1', 'LShoulderElevationH1', 'LShoulderRotationH1'});
SetAnglesMeaning(3, [1 0 -1], {'LElbowFlExt', '', 'LElbowProSupination'});
SetAnglesMeaning(4, [1 -1 0], {'LWristFlExt', 'LWristDeviation', ''});
SetAnglesMeaning(5, [-1 -1 1], {'LScapProRetraction', 'LScapRotation', 'LScapTilting'});
SetAnglesMeaning(6, [1 -1 -1], {'LTrunkFlExt', 'LTrunkLateralFl', 'LTrunkAxialRotation'});

SetAnglesMeaning(7, [1 -1 -1], {'LH2SAG_Flexion', 'LH2SAG_Abduction', 'LH2SAG_Rotation'});
SetAnglesMeaning(8, [-1 1 -1], {'LH2FRONT_Abduction', 'LH2FRONT_Flexion', 'LH2FRONT_Rotation'});
SetAnglesMeaning(9, [1 -1 -1], {'LH1SAG_Flexion', 'LH1SAG_Abduction', 'LH1SAG_Rotation'});
SetAnglesMeaning(10, [-1 1 -1], {'LH1FRONT_Abduction', 'LH1FRONT_Flexion', 'LH1FRONT_Rotation'});

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

% AnatomicalCalculationFunction='AnatCalc_UL_6Segm_Left.m';
% BODY.CONTEXT.AnatomicalCalculationFunction='AnatCalc_UL_6Segm_Left';

%========================================================================
% END ### BodyModel_UL_5Segm_Left ###
