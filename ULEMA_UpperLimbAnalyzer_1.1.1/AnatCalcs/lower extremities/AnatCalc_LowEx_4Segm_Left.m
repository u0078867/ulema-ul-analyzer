%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function AnatCalc_LowEx_4Segm_Left

% ANATCALC_LOWEX_4SEGM_LEFT [ BodyMech 3.06.01 ]: anatomical calculation file (template)
% INPUT
%    Input : none
% PROCESS
%   Anatomical calculation of lower leg kinematics, based on CAMARC convention (Capozzo et al. 1995). 
%   Calls function
%    AnatomicalFrameDefinition with specific input
% OUTPUT
%   GLOBAL  BODY.SEGMENT(iSegm).AnatomicalFrame.KinematicsPose
%           BODY.SEGMENT(iSegm).StickFigure(iStick).Kinematics
%           BODY.SEGMENT(iSegm).StickFigure(iStick).TimeOffset
%           BODY.SEGMENT(iSegm).StickFigure(iStick).TimeGain

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader

[nSamples]=size(BODY.SEGMENT(1).Cluster.KinematicsPose,3);  %Number of samples
nSeg=length(BODY.SEGMENT);                                  %Number of segments

%##################
% INITIALIZATION ##
%##################

if nSamples==0, return, end

for iSeg=1:nSeg
    nAL=length(BODY.SEGMENT(iSeg).AnatomicalLandmark); % Number of Anatomical Landmarks
    BODY.SEGMENT(iSeg).StickFigure=[];
    for iAL=1:nAL
        BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).Kinematics=[];
    end
end

%##################################################### 
% CALCULATE GLOBAL COORDINATES ANATOMICAL LANDMARKS ##
%#####################################################

for t=1:nSamples % t = iSample
    for iSeg=1:nSeg
        nAL=length(BODY.SEGMENT(iSeg).AnatomicalLandmark);
        for iAL=1:nAL
            AL_grf=BODY.SEGMENT(iSeg).Cluster.KinematicsPose(:,:,t)*[BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).ClusterFrameCoordinates;1];
                       % grf_T_crf (for every sample) * x_crf (one constant value)
            BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).Kinematics(:,t)=AL_grf(1:3); %global coordinates anatomical landmarks
            BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).TimeGain=BODY.SEGMENT(iSeg).Cluster.TimeGain;
            BODY.SEGMENT(iSeg).AnatomicalLandmark(iAL).TimeOffset=BODY.SEGMENT(iSeg).Cluster.TimeOffset;
        end
    end  
 
%###################################################################
% REDEFINE ANATOMICAL LANDMARKS FOR CLEARITY (global coordinates) ##
%###################################################################

%Left foot
CA=BODY.SEGMENT(1).AnatomicalLandmark(1).Kinematics(:,t); %Calcaneus
MI=BODY.SEGMENT(1).AnatomicalLandmark(2).Kinematics(:,t); %Metatarsale I
MV=BODY.SEGMENT(1).AnatomicalLandmark(3).Kinematics(:,t); %Metatarsale V

%Left shank
CF=BODY.SEGMENT(2).AnatomicalLandmark(1).Kinematics(:,t); %Caput fibulae
TT=BODY.SEGMENT(2).AnatomicalLandmark(2).Kinematics(:,t); %Tuber tuberositas
ML=BODY.SEGMENT(2).AnatomicalLandmark(3).Kinematics(:,t); %Malleolus lateralis
MM=BODY.SEGMENT(2).AnatomicalLandmark(4).Kinematics(:,t); %Malleolus medialis

%Left thigh
TM=BODY.SEGMENT(3).AnatomicalLandmark(1).Kinematics(:,t); %Trochanter major
EL=BODY.SEGMENT(3).AnatomicalLandmark(2).Kinematics(:,t); %Lateral epicondyl
EM=BODY.SEGMENT(3).AnatomicalLandmark(3).Kinematics(:,t); %Medial epicondyl

%Pelvis
ASISR=BODY.SEGMENT(4).AnatomicalLandmark(1).Kinematics(:,t); %Anterior superior iliac spine right
ASISL=BODY.SEGMENT(4).AnatomicalLandmark(2).Kinematics(:,t); %Anterior superior iliac spine left
PSISR=BODY.SEGMENT(4).AnatomicalLandmark(3).Kinematics(:,t); %Posterior superior iliac spine right
PSISL=BODY.SEGMENT(4).AnatomicalLandmark(4).Kinematics(:,t); %Posterior superior iliac spine left

%#####################################################################
% Estimate FHR and FHL: Femoral Head Right and Left (Leardini 1999) ##
%#####################################################################

ASISR_crf=BODY.SEGMENT(4).AnatomicalLandmark(1).ClusterFrameCoordinates;
ASISL_crf=BODY.SEGMENT(4).AnatomicalLandmark(2).ClusterFrameCoordinates;
PSISR_crf=BODY.SEGMENT(4).AnatomicalLandmark(3).ClusterFrameCoordinates;
PSISL_crf=BODY.SEGMENT(4).AnatomicalLandmark(4).ClusterFrameCoordinates;

PO = 0.5*(ASISL_crf+ASISR_crf); % pelvis origin
SR = 0.5*(PSISL_crf+PSISR_crf);  % sacral root
pelvic_width = norm(ASISR_crf-ASISL_crf);
pelvic_depth = norm(PO-SR);
%leg_length = norm(ASISL-ML); %LeftLeg-length in GRF
leg_length=norm(BODY.SEGMENT(4).Cluster.PosturePose*[BODY.SEGMENT(4).AnatomicalLandmark(2).ClusterFrameCoordinates;1]-...
    BODY.SEGMENT(2).Cluster.PosturePose*[BODY.SEGMENT(2).AnatomicalLandmark(3).ClusterFrameCoordinates;1]);
%leg_length = .800 ; % (meter)
   
FHR_arf=[-0.31*pelvic_depth;...
         -0.096*leg_length;...
          0.38*pelvic_width;1];  
FHL_arf=[-0.31*pelvic_depth;...
         -0.096*leg_length;...
         -0.38*pelvic_width;1]; % femoral head estimation by regression (Leardini 1999)
                                % Hom.coordinates in the anatomical frame of the pelvis

arf_T_crf=AnatomicalFrameDefinition('Pelvis',[ASISR_crf ASISL_crf PSISR_crf PSISL_crf]);
FHR_crf=arf_T_crf*FHR_arf; 
FHL_crf=arf_T_crf*FHL_arf; 

FHR_grf=BODY.SEGMENT(4).Cluster.KinematicsPose(:,:,t)*FHR_crf; % segment # pelvis
FHL_grf=BODY.SEGMENT(4).Cluster.KinematicsPose(:,:,t)*FHL_crf; % segment # pelvis

FHR=FHR_grf(1:3);
FHL=FHL_grf(1:3);

%######################################
%  ACTUAL ANATOMICAL POSE: arf_T_grf ##
%######################################

BODY.SEGMENT(1).AnatomicalFrame.KinematicsPose(:,:,t)=AnatomicalFrameDefinition('Left_Foot',[CA MI MV]);
BODY.SEGMENT(2).AnatomicalFrame.KinematicsPose(:,:,t)=AnatomicalFrameDefinition('Left_Shank',[CF TT ML MM]);
BODY.SEGMENT(3).AnatomicalFrame.KinematicsPose(:,:,t)=AnatomicalFrameDefinition('Left_Thigh',[FHL EL EM]);
BODY.SEGMENT(4).AnatomicalFrame.KinematicsPose(:,:,t)=AnatomicalFrameDefinition('Pelvis',[ASISR ASISL PSISR PSISL]);

%###############################################
% DEFINE STICKFIGURE (for visualization only) ##
%###############################################

BODY.SEGMENT(1).StickFigure(1).Kinematics(:,t)=CA;
BODY.SEGMENT(1).StickFigure(2).Kinematics(:,t)=MI;
BODY.SEGMENT(1).StickFigure(3).Kinematics(:,t)=MV;
BODY.SEGMENT(1).StickFigure(4).Kinematics(:,t)=CA;
BODY.SEGMENT(1).StickFigure(1).TimeOffset=BODY.SEGMENT(1).AnatomicalLandmark(1).TimeOffset;
BODY.SEGMENT(1).StickFigure(1).TimeGain=BODY.SEGMENT(1).AnatomicalLandmark(1).TimeGain;

BODY.SEGMENT(2).StickFigure(1).Kinematics(:,t)=CF;
BODY.SEGMENT(2).StickFigure(2).Kinematics(:,t)=ML;
BODY.SEGMENT(2).StickFigure(3).Kinematics(:,t)=MM;
BODY.SEGMENT(2).StickFigure(4).Kinematics(:,t)=TT;
BODY.SEGMENT(2).StickFigure(5).Kinematics(:,t)=CF;
BODY.SEGMENT(2).StickFigure(1).TimeOffset=BODY.SEGMENT(2).AnatomicalLandmark(1).TimeOffset;
BODY.SEGMENT(2).StickFigure(1).TimeGain=BODY.SEGMENT(2).AnatomicalLandmark(1).TimeGain;

BODY.SEGMENT(3).StickFigure(1).Kinematics(:,t)=FHL;
BODY.SEGMENT(3).StickFigure(2).Kinematics(:,t)=EL;
BODY.SEGMENT(3).StickFigure(3).Kinematics(:,t)=EM;
BODY.SEGMENT(3).StickFigure(4).Kinematics(:,t)=FHL;
BODY.SEGMENT(3).StickFigure(1).TimeOffset=BODY.SEGMENT(3).AnatomicalLandmark(1).TimeOffset;
BODY.SEGMENT(3).StickFigure(1).TimeGain=BODY.SEGMENT(3).AnatomicalLandmark(1).TimeGain;

BODY.SEGMENT(4).StickFigure(1).Kinematics(:,t)=ASISR;
BODY.SEGMENT(4).StickFigure(2).Kinematics(:,t)=ASISL;
BODY.SEGMENT(4).StickFigure(3).Kinematics(:,t)=PSISL;
BODY.SEGMENT(4).StickFigure(4).Kinematics(:,t)=PSISR;
BODY.SEGMENT(4).StickFigure(5).Kinematics(:,t)=ASISR;
BODY.SEGMENT(4).StickFigure(1).TimeOffset=BODY.SEGMENT(4).AnatomicalLandmark(1).TimeOffset;
BODY.SEGMENT(4).StickFigure(1).TimeGain=BODY.SEGMENT(4).AnatomicalLandmark(1).TimeGain;

end
%==========================================================================
% END ### AnatCalc_LowEx_4Segm_Left ###
