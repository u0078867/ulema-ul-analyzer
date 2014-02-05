%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function AnatCalc_UL_12Segm_Bilat

% ANATCALC_UL_5SEGM_RIGHT [ BodyMech 3.06.01 ]: anatomical calculation file
% INPUT
%    Input : none
% PROCESS
%   Anatomical calculation of upper limb kinematics, based on CAMARC convention (Capozzo et al. 1995). 
%   Calls function 'AnatomicalFrameDefinition' with specific input
% OUTPUT
%   GLOBAL  BODY.SEGMENT(iSegm).AnatomicalFrame.KinematicsPose
%           BODY.SEGMENT(iSegm).StickFigure(iStick).Kinematics
%           BODY.SEGMENT(iSegm).StickFigure(iStick).TimeOffset
%           BODY.SEGMENT(iSegm).StickFigure(iStick).TimeGain

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 
% $ Ver 3.06.02 FaBeR, Leuven, June 2007 (Ellen Jaspers)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

% [nSamples]=size(BODY.SEGMENT(1).Cluster.KinematicsPose,3);  %Number of samples
% nSeg=length(BODY.SEGMENT);                                  %Number of segments

% ####################
% ## INITIALIZATION ##
% ####################

% if nSamples==0, return, end

% for iSeg=1:nSeg
%     nAL=length(BODY.SEGMENT(iSeg).AnatomicalLandmark); % Number of Anatomical Landmarks
%     %BODY.SEGMENT(iSeg).StickFigure=[]; (FC 13/08/2007 uitgecommentarieerd)
%     for iAL=1:nAL
%         BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).Kinematics=[];
%     end
% end

% ####################################################### 
% ## CALCULATE GLOBAL COORDINATES ANATOMICAL LANDMARKS ##
% #######################################################

% for t=1:nSamples % t = iSample
%     for iSeg=1:nSeg
%         nAL=length(BODY.SEGMENT(iSeg).AnatomicalLandmark);
%         for iAL=1:nAL
%             AL_grf=BODY.SEGMENT(iSeg).Cluster.KinematicsPose(:,:,t)*[BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).ClusterFrameCoordinates;1];
%                        % grf_T_crf (for every sample) * x_crf (one constant value)
%             BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).Kinematics(:,t)=AL_grf(1:3); %global coordinates anatomical landmarks
%             BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).TimeGain=BODY.SEGMENT(iSeg).Cluster.TimeGain;
%             BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).TimeOffset=BODY.SEGMENT(iSeg).Cluster.TimeOffset;
%         end
%     end  
 
% #####################################################################
% ## REDEFINE ANATOMICAL LANDMARKS FOR CLEARITY (global coordinates) ##
% #####################################################################

%right humerus
i1 = FindSegmentIndex('Right_Humerus');
if ~isempty(i1)
    REL=BODY.SEGMENT(i1).AnatomicalLandmark(1).Kinematics;  % lateral epicondyl
    REM=BODY.SEGMENT(i1).AnatomicalLandmark(2).Kinematics;  % medial epicondyl
    %GHr=BODY.SEGMENT(i).AnatomicalLandmark(2).Kinematics; % GH rotation centre
end

%right forearm
i2 = FindSegmentIndex('Right_Forearm');
if ~isempty(i2)
    RRS=BODY.SEGMENT(i2).AnatomicalLandmark(1).Kinematics;  % radial styloid
    RUS=BODY.SEGMENT(i2).AnatomicalLandmark(2).Kinematics;  % ulnar styloid
end

%right hand
i3 = FindSegmentIndex('Right_Hand');
if ~isempty(i3)
    RMC3=BODY.SEGMENT(i3).AnatomicalLandmark(1).Kinematics;     % proc styl metacarpal 3
    RMCP2=BODY.SEGMENT(i3).AnatomicalLandmark(2).Kinematics;    % metacarpo-phalangeal 2
    RMCP3=BODY.SEGMENT(i3).AnatomicalLandmark(3).Kinematics;    % metacarpo-phalangeal 3
    RMCP5=BODY.SEGMENT(i3).AnatomicalLandmark(4).Kinematics;    % metacarpo-phalangeal 5
end

%right acromion
i4 = FindSegmentIndex('Right_Acromion');
if ~isempty(i4)
    RAA=BODY.SEGMENT(i4).AnatomicalLandmark(1).Kinematics;  % ang acromialis
    RAI=BODY.SEGMENT(i4).AnatomicalLandmark(2).Kinematics;  % ang inferior
    RTS=BODY.SEGMENT(i4).AnatomicalLandmark(3).Kinematics;  % trig spin scap
    RPC=BODY.SEGMENT(i4).AnatomicalLandmark(4).Kinematics;  % proc coraco�deus
    RAC=BODY.SEGMENT(i4).AnatomicalLandmark(5).Kinematics;  % art acromiocalvicularis
end

%right sternum
i5 = FindSegmentIndex('Right_Sternum');
if ~isempty(i5)
    C7=BODY.SEGMENT(i5).AnatomicalLandmark(1).Kinematics;  % proc spin C7
    T8=BODY.SEGMENT(i5).AnatomicalLandmark(2).Kinematics;  % proc spin T8
    IJ=BODY.SEGMENT(i5).AnatomicalLandmark(3).Kinematics;  % inc jungularis
    PX=BODY.SEGMENT(i5).AnatomicalLandmark(4).Kinematics;  % proc xypho�deus
end

%right humerus 1 (for H1 definition according to ISB)
i6 = FindSegmentIndex('Right_Hum1');
if ~isempty(i6) || ~isempty(i1)
    REL=BODY.SEGMENT(i6).AnatomicalLandmark(1).Kinematics;  % lateral epicondyl
    REM=BODY.SEGMENT(i6).AnatomicalLandmark(2).Kinematics;  % medial epicondyl
end

iRGH = strcmp({BODY.SEGMENT(i4).AnatomicalLandmark.Name},'RGH');
if sum(iRGH) > 0
    RGHr = BODY.SEGMENT(i4).AnatomicalLandmark(iRGH).Kinematics;
else
    RGHr=ghestnew_gert_right_VECT(RPC,RAC,RAA,RTS,RAI); % Glenohumeral rot-centre estimation (Meskers 1998)
    % Adding GH it to the BODY structure
    BODY.SEGMENT(i4).AnatomicalLandmark(end+1).Name = 'RGH';
    BODY.SEGMENT(i4).AnatomicalLandmark(end).Kinematics = RGHr;    
end

%left humerus
i7 = FindSegmentIndex('Left_Humerus');
if ~isempty(i7)
    LEL=BODY.SEGMENT(i7).AnatomicalLandmark(1).Kinematics;  % lateral epicondyl
    LEM=BODY.SEGMENT(i7).AnatomicalLandmark(2).Kinematics;  % medial epicondyl
end

%left forearm
i8 = FindSegmentIndex('Left_Forearm');
if ~isempty(i8)
    LRS=BODY.SEGMENT(i8).AnatomicalLandmark(1).Kinematics;  % radial styloid
    LUS=BODY.SEGMENT(i8).AnatomicalLandmark(2).Kinematics;  % ulnar styloid
end

%left hand
i9 = FindSegmentIndex('Left_Hand');
if ~isempty(i9)
    LMC3=BODY.SEGMENT(i9).AnatomicalLandmark(1).Kinematics;     % proc styl metacarpal 3
    LMCP2=BODY.SEGMENT(i9).AnatomicalLandmark(2).Kinematics;    % metacarpo-phalangeal 2
    LMCP3=BODY.SEGMENT(i9).AnatomicalLandmark(3).Kinematics;    % metacarpo-phalangeal 3
    LMCP5=BODY.SEGMENT(i9).AnatomicalLandmark(4).Kinematics;    % metacarpo-phalangeal 5
end

%left acromion
i10 = FindSegmentIndex('Left_Acromion');
if ~isempty(i10)
    LAA=BODY.SEGMENT(i10).AnatomicalLandmark(1).Kinematics;  % ang acromialis
    LAI=BODY.SEGMENT(i10).AnatomicalLandmark(2).Kinematics;  % ang inferior
    LTS=BODY.SEGMENT(i10).AnatomicalLandmark(3).Kinematics;  % trig spin scap
    LPC=BODY.SEGMENT(i10).AnatomicalLandmark(4).Kinematics;  % proc coraco�deus
    LAC=BODY.SEGMENT(i10).AnatomicalLandmark(5).Kinematics;  % art acromiocalvicularis
end

%left sternum
i11 = FindSegmentIndex('Left_Sternum');
if ~isempty(i11)
    C7=BODY.SEGMENT(i11).AnatomicalLandmark(1).Kinematics;  % proc spin C7
    T8=BODY.SEGMENT(i11).AnatomicalLandmark(2).Kinematics;  % proc spin T8
    IJ=BODY.SEGMENT(i11).AnatomicalLandmark(3).Kinematics;  % inc jungularis
    PX=BODY.SEGMENT(i11).AnatomicalLandmark(4).Kinematics;  % proc xypho�deus
end

%left hum1 (first coordinate system according to ISB)
i12 = FindSegmentIndex('Left_Hum1');
if ~isempty(i12) || ~isempty(i7)
    LEL=BODY.SEGMENT(i12).AnatomicalLandmark(1).Kinematics;  % lateral epicondyl
    LEM=BODY.SEGMENT(i12).AnatomicalLandmark(2).Kinematics;  % medial epicondyl
end

iLGH = strcmp({BODY.SEGMENT(i10).AnatomicalLandmark.Name},'LGH');
if sum(iLGH) > 0
    LGHr = BODY.SEGMENT(i10).AnatomicalLandmark(iLGH).Kinematics;
else
    LGHr=ghestnew_gert_left_VECT(LPC,LAC,LAA,LTS,LAI); % Glenohumeral rot-centre estimation (Meskers 1998)
    % Adding GH it to the BODY structure
    BODY.SEGMENT(i10).AnatomicalLandmark(end+1).Name = 'LGH';
    BODY.SEGMENT(i10).AnatomicalLandmark(end).Kinematics = LGHr;    
end

% ########################################
% ## ACTUAL ANATOMICAL POSE: arf_T_grf  ##
% ########################################

if ~isempty(i1)
    BODY.SEGMENT(i1).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Humerus',RGHr, REL, REM, RUS, RRS);
end
if ~isempty(i2)
    BODY.SEGMENT(i2).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Forearm',RRS, RUS, REL, REM);
end
if ~isempty(i3) 
    BODY.SEGMENT(i3).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Hand',RMC3, RMCP3, RMCP5);
end
if ~isempty(i4)
    BODY.SEGMENT(i4).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Acromion',RAA, RAI, RTS);
end
if ~isempty(i5)
    BODY.SEGMENT(i5).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Sternum',C7, T8, IJ, PX);
end
if ~isempty(i6)
    BODY.SEGMENT(i6).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Hum1',RGHr, REL, REM);
end
if ~isempty(i7)
    BODY.SEGMENT(i7).AnatomicalFrame.KinematicsPose = AnatomicalFrameDefinition_VECT('Left_Humerus', LGHr, LEL, LEM, LUS, LRS);
end
if ~isempty(i8)
    BODY.SEGMENT(i8).AnatomicalFrame.KinematicsPose = AnatomicalFrameDefinition_VECT('Left_Forearm',LRS, LUS, LEL, LEM);
end
if ~isempty(i9)
    BODY.SEGMENT(i9).AnatomicalFrame.KinematicsPose = AnatomicalFrameDefinition_VECT('Left_Hand',LMC3, LMCP3, LMCP5);
end
if ~isempty(i10)
    BODY.SEGMENT(i10).AnatomicalFrame.KinematicsPose = AnatomicalFrameDefinition_VECT('Left_Acromion',LAA, LAI, LTS);
end
if ~isempty(i11)
    BODY.SEGMENT(i11).AnatomicalFrame.KinematicsPose = AnatomicalFrameDefinition_VECT('Left_Sternum',C7, T8, IJ, PX);
end
% added March 2009
if ~isempty(i12)
    BODY.SEGMENT(i12).AnatomicalFrame.KinematicsPose = AnatomicalFrameDefinition_VECT('Left_Hum1',LGHr, LEL, LEM);
end

%###############################################
% DEFINE STICKFIGURE (for visualization only) ##
%###############################################

if ~isempty(i1)
    BODY.SEGMENT(i1).StickFigure(1).Kinematics=REL;
    BODY.SEGMENT(i1).StickFigure(2).Kinematics=REM;
    BODY.SEGMENT(i1).StickFigure(3).Kinematics=RGHr;
    BODY.SEGMENT(i1).StickFigure(4).Kinematics=REL;
    BODY.SEGMENT(i1).StickFigure(1).TimeOffset=BODY.SEGMENT(i1).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i1).StickFigure(1).TimeGain=BODY.SEGMENT(i1).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i2)
    BODY.SEGMENT(i2).StickFigure(1).Kinematics=RRS;
    BODY.SEGMENT(i2).StickFigure(2).Kinematics=RUS;
    BODY.SEGMENT(i2).StickFigure(3).Kinematics=REM;
    BODY.SEGMENT(i2).StickFigure(4).Kinematics=REL;
    BODY.SEGMENT(i2).StickFigure(5).Kinematics=RRS;
    BODY.SEGMENT(i2).StickFigure(1).TimeOffset=BODY.SEGMENT(i2).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i2).StickFigure(1).TimeGain=BODY.SEGMENT(i2).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i3)
    BODY.SEGMENT(i3).StickFigure(1).Kinematics=RMC3;
    BODY.SEGMENT(i3).StickFigure(2).Kinematics=RMCP2;
    BODY.SEGMENT(i3).StickFigure(3).Kinematics=RMCP5;
    BODY.SEGMENT(i3).StickFigure(4).Kinematics=RMC3;
    BODY.SEGMENT(i3).StickFigure(1).TimeOffset=BODY.SEGMENT(i3).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i3).StickFigure(1).TimeGain=BODY.SEGMENT(i3).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i4)
    BODY.SEGMENT(i4).StickFigure(1).Kinematics=RAA;
    BODY.SEGMENT(i4).StickFigure(2).Kinematics=RAI;
    BODY.SEGMENT(i4).StickFigure(3).Kinematics=RTS;
    BODY.SEGMENT(i4).StickFigure(4).Kinematics=RAA;
    BODY.SEGMENT(i4).StickFigure(1).TimeOffset=BODY.SEGMENT(i4).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i4).StickFigure(1).TimeGain=BODY.SEGMENT(i4).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i5)
    BODY.SEGMENT(i5).StickFigure(1).Kinematics=C7;
    BODY.SEGMENT(i5).StickFigure(2).Kinematics=T8;
    BODY.SEGMENT(i5).StickFigure(3).Kinematics=PX;
    BODY.SEGMENT(i5).StickFigure(4).Kinematics=IJ;
    BODY.SEGMENT(i5).StickFigure(1).TimeOffset=BODY.SEGMENT(i5).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i5).StickFigure(1).TimeGain=BODY.SEGMENT(i5).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i7)
    BODY.SEGMENT(i7).StickFigure(1).Kinematics=LEL;
    BODY.SEGMENT(i7).StickFigure(2).Kinematics=LEM;
    BODY.SEGMENT(i7).StickFigure(3).Kinematics=LGHr;
    BODY.SEGMENT(i7).StickFigure(4).Kinematics=LEL;
    BODY.SEGMENT(i7).StickFigure(1).TimeOffset=BODY.SEGMENT(i7).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i7).StickFigure(1).TimeGain=BODY.SEGMENT(i7).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i8)
    BODY.SEGMENT(i8).StickFigure(1).Kinematics=LRS;
    BODY.SEGMENT(i8).StickFigure(2).Kinematics=LUS;
    BODY.SEGMENT(i8).StickFigure(3).Kinematics=LEM;
    BODY.SEGMENT(i8).StickFigure(4).Kinematics=LEL;
    BODY.SEGMENT(i8).StickFigure(5).Kinematics=LRS;
    BODY.SEGMENT(i8).StickFigure(1).TimeOffset=BODY.SEGMENT(i8).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i8).StickFigure(1).TimeGain=BODY.SEGMENT(i8).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i9)
    BODY.SEGMENT(i9).StickFigure(1).Kinematics=LMC3;
    BODY.SEGMENT(i9).StickFigure(2).Kinematics=LMCP2;
    BODY.SEGMENT(i9).StickFigure(3).Kinematics=LMCP5;
    BODY.SEGMENT(i9).StickFigure(4).Kinematics=LMC3;
    BODY.SEGMENT(i9).StickFigure(1).TimeOffset=BODY.SEGMENT(i9).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i9).StickFigure(1).TimeGain=BODY.SEGMENT(i9).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i10)
    BODY.SEGMENT(i10).StickFigure(1).Kinematics=LAA;
    BODY.SEGMENT(i10).StickFigure(2).Kinematics=LAI;
    BODY.SEGMENT(i10).StickFigure(3).Kinematics=LTS;
    BODY.SEGMENT(i10).StickFigure(4).Kinematics=LAA;
    BODY.SEGMENT(i10).StickFigure(1).TimeOffset=BODY.SEGMENT(i10).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i10).StickFigure(1).TimeGain=BODY.SEGMENT(i10).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i11)
    BODY.SEGMENT(i11).StickFigure(1).Kinematics=C7;
    BODY.SEGMENT(i11).StickFigure(2).Kinematics=T8;
    BODY.SEGMENT(i11).StickFigure(3).Kinematics=PX;
    BODY.SEGMENT(i11).StickFigure(4).Kinematics=IJ;
    BODY.SEGMENT(i11).StickFigure(1).TimeOffset=BODY.SEGMENT(i11).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i11).StickFigure(1).TimeGain=BODY.SEGMENT(i11).AnatomicalLandmark(1).TimeGain;
end

% end
%==========================================================
% END ### AnatCalc_UL_6Segm_Right ###
