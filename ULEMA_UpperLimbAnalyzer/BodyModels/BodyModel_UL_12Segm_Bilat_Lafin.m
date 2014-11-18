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

CreateBodyHeader('bilat_UL');

% #############################
% ## create body model       ##
% #############################
% create your own segments

% Right side technical
MyLabelSequence{1} = 'RUA1';
MyLabelSequence{2} = 'RUA2';
MyLabelSequence{3} = 'RUA3';
MyLabelSequence{4} = 'RUA4';
MyLabelSequence{5} = 'RLA1';
MyLabelSequence{6} = 'RLA2';
MyLabelSequence{7} = 'RLA3';
MyLabelSequence{8} = 'RLA4';
MyLabelSequence{9} = 'RACR1';
MyLabelSequence{10} = 'RACR2';
MyLabelSequence{11} = 'RACR3';

% Left side technical
MyLabelSequence{12} = 'LUA1';
MyLabelSequence{13} = 'LUA2';
MyLabelSequence{14} = 'LUA3';
MyLabelSequence{15} = 'LUA4';
MyLabelSequence{16} = 'LLA1';
MyLabelSequence{17} = 'LLA2';
MyLabelSequence{18} = 'LLA3';
MyLabelSequence{19} = 'LLA4';
MyLabelSequence{20} = 'LACR1';
MyLabelSequence{21} = 'LACR2';
MyLabelSequence{22} = 'LACR3';

% Common
MyLabelSequence{23} = 'ST1';
MyLabelSequence{24} = 'ST2';
MyLabelSequence{25} = 'ST3';

% Right side anatomical
MyLabelSequence{26} = 'REL';
MyLabelSequence{27} = 'REM';
MyLabelSequence{28} = 'RRS';
MyLabelSequence{29} = 'RUS';
MyLabelSequence{30} = 'RAA';
MyLabelSequence{31} = 'RAI';
MyLabelSequence{32} = 'RTS';


% Left side anatomical
MyLabelSequence{33} = 'LEL';
MyLabelSequence{34} = 'LEM';
MyLabelSequence{35} = 'LRS';
MyLabelSequence{36} = 'LUS';
MyLabelSequence{37} = 'LAA';
MyLabelSequence{38} = 'LAI';
MyLabelSequence{39} = 'LTS';


MyLabelSequence{40} = 'C7';
MyLabelSequence{41} = 'T8';
MyLabelSequence{42} = 'IJ';
MyLabelSequence{43} = 'PX';

PushLabelsToBODY(MyLabelSequence);

CreateBodySegmentAdv('Right_Humerus', 1, [1 2 3 4]);  % segment 1
CreateBodySegmentAdv('Right_Forearm', 2, [5 6 7 8]);  % segment 2
CreateBodySegmentAdv('Right_Acromion', 3, [9 10 11]);% segment 3
CreateBodySegmentAdv('Right_Sternum', 4, [23 24 25]); % segment 4
CreateBodySegmentAdv('Right_Hum1', 5, [1 2 3 4]);    % segment 5

CreateBodySegmentAdv('Left_Humerus', 6, [12 13 14 15]);  % segment 6
CreateBodySegmentAdv('Left_Forearm', 7, [16 17 18 19]);  % segment 7
CreateBodySegmentAdv('Left_Acromion', 8, [20 21 22]);% segment 8
CreateBodySegmentAdv('Left_Sternum', 9, [23 24 25]); % segment 9
CreateBodySegmentAdv('Left_Hum1', 10, [12 13 14 15]);    % segment 10

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

% right acromion (3)
% anatomical landmarks of the scapula between the ' '
BODY.SEGMENT(3).AnatomicalLandmark(1).Name=('RAA');  % ang acromialis
BODY.SEGMENT(3).AnatomicalLandmark(2).Name=('RAI');  % ang inferior
BODY.SEGMENT(3).AnatomicalLandmark(3).Name=('RTS');  % trig spin scap

% right sternum (4)
% anatomical landmarks of the trunk between the ' '
BODY.SEGMENT(4).AnatomicalLandmark(1).Name=('C7');  % proc spin C7
BODY.SEGMENT(4).AnatomicalLandmark(2).Name=('T8');  % proc spin T8
BODY.SEGMENT(4).AnatomicalLandmark(3).Name=('IJ');  % inc jungularis
BODY.SEGMENT(4).AnatomicalLandmark(4).Name=('PX');  % proc xypho�deus

% right hum1 (5)
% anatomical landmarks of the humerus between the ' '
BODY.SEGMENT(5).AnatomicalLandmark(1).Name=('REL');  % lateral epicondyl
BODY.SEGMENT(5).AnatomicalLandmark(2).Name=('REM');  % medial epicondyl

% left humerus (6)
% anatomical landmarks of the humerus between the ' '
% BODY.SEGMENT(1).AnatomicalLandmark(1).Name=('GHr'); % GH rotation centre
% defined in AnatCalc_UL_6Segm_Right
BODY.SEGMENT(6).AnatomicalLandmark(1).Name=('LEL');  % lateral epicondyl
BODY.SEGMENT(6).AnatomicalLandmark(1).SharedWith = {'Left_Forearm'};
BODY.SEGMENT(6).AnatomicalLandmark(2).Name=('LEM');  % medial epicondyl
BODY.SEGMENT(6).AnatomicalLandmark(2).SharedWith = {'Left_Forearm'};

% left forearm (7)
% fill in anatomical landmarks of the lowerarm between the ' '
BODY.SEGMENT(7).AnatomicalLandmark(1).Name=('LRS');  % radial styloid
BODY.SEGMENT(7).AnatomicalLandmark(1).SharedWith = {'Left_Humerus'};
BODY.SEGMENT(7).AnatomicalLandmark(2).Name=('LUS');  % ulnar styloid
BODY.SEGMENT(7).AnatomicalLandmark(2).SharedWith = {'Left_Humerus'};

% left acromion (8)
% anatomical landmarks of the scapula between the ' '
BODY.SEGMENT(8).AnatomicalLandmark(1).Name=('LAA');  % ang acromialis
BODY.SEGMENT(8).AnatomicalLandmark(2).Name=('LAI');  % ang inferior
BODY.SEGMENT(8).AnatomicalLandmark(3).Name=('LTS');  % trig spin scap

% left sternum (9)
% anatomical landmarks of the trunk between the ' '
BODY.SEGMENT(9).AnatomicalLandmark(1).Name=('C7');  % proc spin C7
BODY.SEGMENT(9).AnatomicalLandmark(2).Name=('T8');  % proc spin T8
BODY.SEGMENT(9).AnatomicalLandmark(3).Name=('IJ');  % inc jungularis
BODY.SEGMENT(9).AnatomicalLandmark(4).Name=('PX');  % proc xypho�deus

% left hum1 (10)
% anatomical landmarks of the humerus between the ' '
BODY.SEGMENT(10).AnatomicalLandmark(1).Name=('LEL');  % lateral epicondyl
BODY.SEGMENT(10).AnatomicalLandmark(2).Name=('LEM');  % medial epicondyl


% ####################
% ## create joints  ##
% ####################
% create upper limb joints
% CreateBodyJoint ('Name_Joint', number joint, [proximal segment, distal
% segment], [decomposition order]);

%CreateBodyJoint('Right_Shoulder', 1, [3 1], [Y X Y],'SecondSolution');      % joint 1 humerus relative to scapula (ISB)
CreateBodyJoint('Right_H2Shoulder', 1, [4 1], [Y X Y],'SecondSolution');     % joint 1 humerus relative to trunk
CreateBodyJoint('Right_H1Shoulder', 2, [4 5], [Y X Y],'SecondSolution');     % joint 2 hum1 (H1 ACFrelative to trunk (ISB decomposition)
CreateBodyJoint('Right_Elbow', 3, [5 2], [Z X Y],'FirstSolution');          % joint 3 forearm relative to humerusH1
CreateBodyJoint('Right_Scapula', 4, [4 3], [Y X Z],'FirstSolution');        % joint 5 scapula relative to trunk
CreateBodyJoint('Right_Trunk', 5, [4 0], [Y X Z],'FirstSolution');          % joint 6 trunk relative to global lab frame 
% global lab frame: y = lateral axis, x = forward axis and z = upward axis
% --> decomposition order fl-abd-rot = lat axis(Y), forw axis(X), upw axis(Z)
% added March 2009
CreateBodyJoint('Right_H2Sh1', 6, [4 1], [Z X Y],'FirstSolution');     % joint 7 humerus (H2 ACF) relative to trunk (FL ABD ROT)
CreateBodyJoint('Right_H2Sh2', 7, [4 1], [X Z Y],'FirstSolution');     % joint 8 humerus (H2 ACF) relative to trunk (ABD FL ROT)
CreateBodyJoint('Right_H1Sh1', 8, [4 5], [Z X Y],'FirstSolution');     % joint 9 hum1 (H1 ACF) relative to trunk (FL ABD ROT)
CreateBodyJoint('Right_H1Sh2', 9, [4 5], [X Z Y],'FirstSolution');    % joint 10 hum1 (H1 ACFrelative to trunk (ABD FL ROT)
%CreateBodyJoint('Right_Trunk', , [6 4], [Z X Y],'FirstSolution');    % joint  trunk relative to chair frame 

%CreateBodyJoint('Left_Shoulder', 10, [8 6], [Y X Y],'SecondSolution');   % joint 1 humerus relative to scapula (ISB)
CreateBodyJoint('Left_H2Shoulder', 10, [9 6], [Y X Y],'FirstSolution');  % joint 1 humerus relative to trunk
CreateBodyJoint('Left_H1Shoulder', 11, [9 10], [Y X Y],'FirstSolution');  % joint 2 hum1 (H1 ACFrelative to trunk (ISB decomposition)
CreateBodyJoint('Left_Elbow', 12, [10 7], [Z X Y],'FirstSolution');       % joint 3 forearm relative to humerusH1
CreateBodyJoint('Left_Scapula', 13, [9 8], [Y X Z],'FirstSolution');     % joint 5 scapula relative to trunk
CreateBodyJoint('Left_Trunk', 14, [9 0], [Y X Z],'FirstSolution');       % joint 6 trunk relative to global lab frame 
% global lab frame: y = lateral axis, x = forward axis and z = upward axis
% --> decomposition order fl-abd-rot = lat axis(Y), forw axis(X), upw axis(Z)
% added March 2009
CreateBodyJoint('Left_H2Sh1', 15, [9 6], [Z X Y],'FirstSolution');       % joint 7 humerus (H2 ACF) relative to trunk (FL ABD ROT)
CreateBodyJoint('Left_H2Sh2', 16, [9 6], [X Z Y],'FirstSolution');       % joint 8 humerus (H2 ACF) relative to trunk (ABD FL ROT)
CreateBodyJoint('Left_H1Sh1', 17, [9 10], [Z X Y],'FirstSolution');       % joint 9 hum1 (H1 ACF) relative to trunk (FL ABD ROT)
CreateBodyJoint('Left_H1Sh2', 18, [9 10], [X Z Y],'FirstSolution');      % joint 10 hum1 (H1 ACFrelative to trunk (ABD FL ROT)
%joint  trunk relative to chair frame 

% ####################
% ## name angles    ##
% ####################

SetAnglesMeaning(1, [1 1 1], {'RElevationplaneH2', 'RShoulderElevationH2', 'RShoulderRotationH2'});
SetAnglesMeaning(2, [1 1 1], {'RElevationplaneH1', 'RShoulderElevationH1', 'RShoulderRotationH1'});
SetAnglesMeaning(3, [1 0 1], {'RElbowFlExt', '', 'RElbowProSupination'});
SetAnglesMeaning(4, [1 1 1], {'RScapProRetraction', 'RScapRotation', 'RScapTilting'});
SetAnglesMeaning(5, [1 1 1], {'RTrunkFlExt', 'RTrunkLateralFl', 'RTrunkAxialRotation'});

SetAnglesMeaning(6, [1 1 1], {'RH2SAG_Flexion', 'RH2SAG_Abduction', 'RH2SAG_Rotation'});
SetAnglesMeaning(7, [1 1 1], {'RH2FRONT_Abduction', 'RH2FRONT_Flexion', 'RH2FRONT_Rotation'});
SetAnglesMeaning(8, [1 1 1], {'RH1SAG_Flexion', 'RH1SAG_Abduction', 'RH1SAG_Rotation'});
SetAnglesMeaning(9, [1 1 1], {'RH1FRONT_Abduction', 'RH1FRONT_Flexion', 'RH1FRONT_Rotation'});

SetAnglesMeaning(10, [-1 -1 -1], {'LElevationplaneH2', 'LShoulderElevationH2', 'LShoulderRotationH2'});
SetAnglesMeaning(11, [-1 -1 -1], {'LElevationplaneH1', 'LShoulderElevationH1', 'LShoulderRotationH1'});
SetAnglesMeaning(12, [1 0 -1], {'LElbowFlExt', '', 'LElbowProSupination'});
SetAnglesMeaning(13, [-1 -1 1], {'LScapProRetraction', 'LScapRotation', 'LScapTilting'});
SetAnglesMeaning(14, [1 -1 -1], {'LTrunkFlExt', 'LTrunkLateralFl', 'LTrunkAxialRotation'});

SetAnglesMeaning(15, [1 -1 -1], {'LH2SAG_Flexion', 'LH2SAG_Abduction', 'LH2SAG_Rotation'});
SetAnglesMeaning(16, [-1 1 -1], {'LH2FRONT_Abduction', 'LH2FRONT_Flexion', 'LH2FRONT_Rotation'});
SetAnglesMeaning(17, [1 -1 -1], {'LH1SAG_Flexion', 'LH1SAG_Abduction', 'LH1SAG_Rotation'});
SetAnglesMeaning(18, [-1 1 -1], {'LH1FRONT_Abduction', 'LH1FRONT_Flexion', 'LH1FRONT_Rotation'});

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
