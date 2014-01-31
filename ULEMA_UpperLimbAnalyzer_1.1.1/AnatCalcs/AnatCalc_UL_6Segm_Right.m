%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function AnatCalc_UL_6Segm_Right

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
    EL=BODY.SEGMENT(i1).AnatomicalLandmark(1).Kinematics;  % lateral epicondyl
    EM=BODY.SEGMENT(i1).AnatomicalLandmark(2).Kinematics;  % medial epicondyl
    %GHr=BODY.SEGMENT(i).AnatomicalLandmark(2).Kinematics; % GH rotation centre
end

%right forearm
i2 = FindSegmentIndex('Right_Forearm');
if ~isempty(i2)
    RS=BODY.SEGMENT(i2).AnatomicalLandmark(1).Kinematics;  % radial styloid
    US=BODY.SEGMENT(i2).AnatomicalLandmark(2).Kinematics;  % ulnar styloid
end

%right hand
i3 = FindSegmentIndex('Right_Hand');
if ~isempty(i3)
    MC3=BODY.SEGMENT(i3).AnatomicalLandmark(1).Kinematics;     % proc styl metacarpal 3
    MCP2=BODY.SEGMENT(i3).AnatomicalLandmark(2).Kinematics;    % metacarpo-phalangeal 2
    MCP3=BODY.SEGMENT(i3).AnatomicalLandmark(3).Kinematics;    % metacarpo-phalangeal 3
    MCP5=BODY.SEGMENT(i3).AnatomicalLandmark(4).Kinematics;    % metacarpo-phalangeal 5
end

%right acromion
i4 = FindSegmentIndex('Right_Acromion');
if ~isempty(i4)
    AA=BODY.SEGMENT(i4).AnatomicalLandmark(1).Kinematics;  % ang acromialis
    AI=BODY.SEGMENT(i4).AnatomicalLandmark(2).Kinematics;  % ang inferior
    TS=BODY.SEGMENT(i4).AnatomicalLandmark(3).Kinematics;  % trig spin scap
    PC=BODY.SEGMENT(i4).AnatomicalLandmark(4).Kinematics;  % proc coraco�deus
    AC=BODY.SEGMENT(i4).AnatomicalLandmark(5).Kinematics;  % art acromiocalvicularis
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
    EL=BODY.SEGMENT(i6).AnatomicalLandmark(1).Kinematics;  % lateral epicondyl
    EM=BODY.SEGMENT(i6).AnatomicalLandmark(2).Kinematics;  % medial epicondyl
end

iRGH = strcmp({BODY.SEGMENT(i4).AnatomicalLandmark.Name},'RGH');
if sum(iRGH) > 0
    GHr = BODY.SEGMENT(i4).AnatomicalLandmark(iRGH).Kinematics;
else
    GHr=ghestnew_gert_right_VECT(PC,AC,AA,TS,AI); % Glenohumeral rot-centre estimation (Meskers 1998)
    % Adding GH it to the BODY structure
    BODY.SEGMENT(i4).AnatomicalLandmark(end+1).Name = 'RGH';
    BODY.SEGMENT(i4).AnatomicalLandmark(end).Kinematics = GHr;    
end

% ########################################
% ## ACTUAL ANATOMICAL POSE: arf_T_grf  ##
% ########################################

if ~isempty(i1)
    BODY.SEGMENT(i1).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Humerus',GHr, EL, EM, US, RS);
end
if ~isempty(i2)
    BODY.SEGMENT(i2).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Forearm',RS, US, EL, EM);
end
if ~isempty(i3) 
    BODY.SEGMENT(i3).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Hand',MC3, MCP3, MCP5);
end
if ~isempty(i4)
    BODY.SEGMENT(i4).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Acromion',AA, AI, TS);
end
if ~isempty(i5)
    BODY.SEGMENT(i5).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Sternum',C7, T8, IJ, PX);
end
% added March 2009
if ~isempty(i6)
    BODY.SEGMENT(i6).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Right_Hum1',GHr, EL, EM);
end
%BODY.SEGMENT(7).AnatomicalFrame.KinematicsPose=AnatomicalFrameDefinition_VECT('Chair',CH1, CH2, CH3);

%###############################################
% DEFINE STICKFIGURE (for visualization only) ##
%###############################################

if ~isempty(i1)
    BODY.SEGMENT(i1).StickFigure(1).Kinematics=EL;
    BODY.SEGMENT(i1).StickFigure(2).Kinematics=EM;
    BODY.SEGMENT(i1).StickFigure(3).Kinematics=GHr;
    BODY.SEGMENT(i1).StickFigure(4).Kinematics=EL;
    BODY.SEGMENT(i1).StickFigure(1).TimeOffset=BODY.SEGMENT(i1).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i1).StickFigure(1).TimeGain=BODY.SEGMENT(i1).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i2)
    BODY.SEGMENT(i2).StickFigure(1).Kinematics=RS;
    BODY.SEGMENT(i2).StickFigure(2).Kinematics=US;
    BODY.SEGMENT(i2).StickFigure(3).Kinematics=EM;
    BODY.SEGMENT(i2).StickFigure(4).Kinematics=EL;
    BODY.SEGMENT(i2).StickFigure(5).Kinematics=RS;
    BODY.SEGMENT(i2).StickFigure(1).TimeOffset=BODY.SEGMENT(i2).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i2).StickFigure(1).TimeGain=BODY.SEGMENT(i2).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i3)
    BODY.SEGMENT(i3).StickFigure(1).Kinematics=MC3;
    BODY.SEGMENT(i3).StickFigure(2).Kinematics=MCP2;
    BODY.SEGMENT(i3).StickFigure(3).Kinematics=MCP5;
    BODY.SEGMENT(i3).StickFigure(4).Kinematics=MC3;
    BODY.SEGMENT(i3).StickFigure(1).TimeOffset=BODY.SEGMENT(i3).AnatomicalLandmark(1).TimeOffset;
    BODY.SEGMENT(i3).StickFigure(1).TimeGain=BODY.SEGMENT(i3).AnatomicalLandmark(1).TimeGain;
end

if ~isempty(i4)
    BODY.SEGMENT(i4).StickFigure(1).Kinematics=AA;
    BODY.SEGMENT(i4).StickFigure(2).Kinematics=AI;
    BODY.SEGMENT(i4).StickFigure(3).Kinematics=TS;
    BODY.SEGMENT(i4).StickFigure(4).Kinematics=AA;
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

% end
%==========================================================
% END ### AnatCalc_UL_6Segm_Right ###
