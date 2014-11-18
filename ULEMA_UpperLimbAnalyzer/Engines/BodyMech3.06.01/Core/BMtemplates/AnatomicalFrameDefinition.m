%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function T=AnatomicalFrameDefinition(SegmentName,AnatomicalMarkers)
% ANATOMICALFRAMEDEFINITION [BodyMech 3.06.01]: calculates anatomical frames 
% INPUT
%   SegmentName : name of the segment: 'Pelvis';'Right_Thigh';'Right_Shank';'Right_Foot'
%                                      ;'Left_Thigh';'Left_Shank';'Left_Foot';
%                                      'Right_Hand';'Right_Forearm';'Right_Humerus';'Right_Scapula';'Trunk'
%   AnatomicalMarkers  : coordinates of anatomical landmarks
%                      : NB. segment name, number and order is pre-defined in your AnatomicalCalculationFunction!!!
% PROCESS
%   Generation of anatomical frames according to the Camarc protocol
%   Capozzo et al. (1995)
%   Wu et al. (2005)
% OUTPUT
%   T=anatomical frame (hom. coordinates)

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver. 1.0 Creation (Jaap Harlaar VUmc june 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

if strcmp(SegmentName,'pelvis') | strcmp(SegmentName,'Pelvis')
   % ______anatomical frame definition pelvis_________
   % nick names
   ASISR=AnatomicalMarkers(:,1); % anterior superior iliac spine right
   ASISL=AnatomicalMarkers(:,2); % anterior superior iliac spine left
   PSISR=AnatomicalMarkers(:,3); % posterior superior iliac spine right
   PSISL=AnatomicalMarkers(:,4); % posterior superior iliac spine left
      
   origin = 0.5*(ASISL+ASISR);
   SR = 0.5*(PSISL+PSISR);  % sacral root
   QTP=cross(SR-origin,ASISR-origin);  % Quasi transversal plane normal vector (pointing upward)
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
   z=ASISR-origin;
   x=cross(QTP,z);
   y=cross(z,x);
   
   % normalization
   ex=x/norm(x);
   ey=y/norm(y);
   ez=z/norm(z);
   
   R=[ ex ey ez]; % the anatomical coordinate system in cluster axes,
   % i.e. the rotation matrix
   t=origin;       % the translation vector from cluster origin to anatomical origin
   T = [R,t; 0 0 0 1]; % the transformation matrix
   
elseif strcmp(SegmentName,'right_thigh') | strcmp(SegmentName,'Right_Thigh')
   % ______anatomical frame definition femur right_________
   %                Capozzo et al. (1995)
   % nick names
   FH=AnatomicalMarkers(:,1); % femural head
   LE=AnatomicalMarkers(:,2); % lateral epicondyl
   ME=AnatomicalMarkers(:,3); % medial epicondyl
   
   origin = 0.5*(LE+ME); % (eq 13)
   QFP=cross(FH-origin,LE-origin);  % Quasi frontal plane normal vector (pointing ventral)
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
   % orthogonal righthanded coordinate system
   y=FH-origin;
   z=cross(QFP,y);
   x=cross(y,z);
   
   % normalization
   ex=x/norm(x);
   ey=y/norm(y);
   ez=z/norm(z);
   
   R=[ ex ey ez]; % the anatomical coordinate system in cluster axes,
   % i.e. the rotation matrix
   t=origin;       % the translation vector from cluster origin to anatomical origin
   T = [R,t; 0 0 0 1]; % the transformation matrix
      
elseif  strcmp(SegmentName,'right_shank') | strcmp(SegmentName,'Right_Shank')
   % ______anatomical frame definition tibia right_________
   %                Capozzo et al. (1995)
   % nick names
   CF=AnatomicalMarkers(:,1); % caput fibulae
   TT=AnatomicalMarkers(:,2); % tuber tuberositas
   ML=AnatomicalMarkers(:,3); % malleolus lateralis
   MM=AnatomicalMarkers(:,4); % malleolus medialis 
   
   origin = 0.5*(MM+ML);
   QFP = cross(CF-origin,ML-origin); % Quasi frontal plane normal vector (pointing ventral)
   QSP = cross(QFP,TT-origin) ;      % Quasi Sagittal plane  normal vector (pointing left to right)
   % i.e. lateral for the tibia of the righthanded side of the body
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
   % orthogonal righthanded coordinate system
   y=cross(QSP,QFP);
   z=cross(QFP,y);
   x=cross(y,z);
   
   % normalization
   ex=x/norm(x);
   ey=y/norm(y);
   ez=z/norm(z);
   
   R=[ ex ey ez]; % the anatomical coordinate system in cluster axes,
   % i.e. the rotation matrix
   t=origin;      % the translation vector from cluster origin to anatomical origin
   T = [R,t; 0 0 0 1]; % the transformation matrix
      
elseif  strcmp(SegmentName,'right_foot') | strcmp(SegmentName,'Right_Foot')
   % ______anatomical frame definition of the right foot_________
   %                Capozzo et al. (1995)
   % nick names
   CA=AnatomicalMarkers(:,1); % calcaneus
   M1=AnatomicalMarkers(:,2); % metatarsale I
   M5=AnatomicalMarkers(:,3); % metatarsale V
   M2=(3*M1+2*M5)/5.;
   
   origin = CA; 
   QTP=cross(M5-origin,M1-origin);  % Quasi Transversal Plane normal vector (pointing proximal)
   QSP=cross(M2-origin,QTP);       % Quasi Sagittal plane  normal vector (pointing left to right)
   % i.e. lateral for the foot of the righthanded side of the body
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
   % orthogonal righthanded coordinate system
   x=cross(QTP,QSP);
   z=cross(x,QTP);
   y=cross(z,x);
   
   % normalization
   ex=x/norm(x);
   ey=y/norm(y);
   ez=z/norm(z);
   
   R=[ ex ey ez]; % the anatomical coordinate system in cluster axes,
   % i.e. the rotation matrix
   t=origin;       % the translation vector from cluster origin to anatomical origin
   T = [R,t; 0 0 0 1]; % the transformation matrix
      
elseif strcmp(SegmentName,'left_thigh') | strcmp(SegmentName,'Left_Thigh')
   % ______anatomical frame definition femur left_________
   %              Capozzo et al. (1995)
   % nick names
   FH=AnatomicalMarkers(:,1); % femural head
   LE=AnatomicalMarkers(:,2); % lateral epicondyl
   ME=AnatomicalMarkers(:,3); % medial epicondyl
   
   origin = 0.5*(LE+ME); % (eq 13)
   QFP=-cross(FH-origin,LE-origin);  % Quasi frontal plane normal vector (pointing ventral)
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
   % orthogonal righthanded coordinate system
   y=FH-origin;
   z=cross(QFP,y);
   x=cross(y,z);
   
   % normalization
   ex=x/norm(x);
   ey=y/norm(y);
   ez=z/norm(z);
   
   R=[ ex ey ez]; % the anatomical coordinate system in cluster axes,
   % i.e. the rotation matrix
   t=origin;       % the translation vector from cluster origin to anatomical origin
   T = [R,t; 0 0 0 1]; % the transformation matrix
   
elseif strcmp(SegmentName,'left_shank') | strcmp(SegmentName,'Left_Shank')
   % ______anatomical frame definition tibia left_________
   %              Capozzo et al. (1995)
   % nick names
   CF=AnatomicalMarkers(:,1); % caput fibulae
   TT=AnatomicalMarkers(:,2); % tuber tuberositas
   ML=AnatomicalMarkers(:,3); % malleolus lateralis
   MM=AnatomicalMarkers(:,4); % malleolus medialis 
   
   origin = 0.5*(MM+ML);
   QFP = -cross(CF-origin,ML-origin);   % Quasi frontal plane normal vector (pointing ventral)
   QSP = cross(QFP,TT-origin) ;   % Quasi Sagittal plane  normal vector (pointing left to right) 
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
   % orthogonal righthanded coordinate system
   y=cross(QSP,QFP);
   z=cross(QFP,y);
   x=cross(y,z);
   
   % normalization
   ex=x/norm(x);
   ey=y/norm(y);
   ez=z/norm(z);
   
   R=[ ex ey ez]; % the anatomical coordinate system in cluster axes,
   % i.e. the rotation matrix
   t=origin;      % the translation vector from cluster origin to anatomical origin
   T = [R,t; 0 0 0 1]; % the transformation matrix
   
elseif strcmp(SegmentName,'left_foot') | strcmp(SegmentName,'Left_Foot')
   % ______anatomical frame definition of the left foot_________
   %               Capozzo et al. (1995)
   % nick names
   CA=AnatomicalMarkers(:,1); % calcaneus 
   M1=AnatomicalMarkers(:,2); % metatarsale I
   M5=AnatomicalMarkers(:,3); % metatarsale V
   M2=(3*M1+2*M5)/5.;
   
   origin = CA; 
   QTP=-cross(M5-origin,M1-origin);  % Quasi Transversal Plane normal vector (pointing proximal)
   QSP=cross(M2-origin,QTP);       % Quasi Sagittal plane  normal vector (pointing left to right)
   % i.e. medial for the foot of the lefthanded side of the body
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
   % orthogonal righthanded coordinate system
   x=cross(QTP,QSP);
   z=cross(x,QTP);
   y=cross(z,x);
   
   % normalization
   ex=x/norm(x);
   ey=y/norm(y);
   ez=z/norm(z);
   
   R=[ ex ey ez]; % the anatomical coordinate system in cluster axes,
   % i.e. the rotation matrix
   t=origin;       % the translation vector from cluster origin to anatomical origin
   T = [R,t; 0 0 0 1]; % the transformation matrix
   
elseif strcmp(SegmentName,'right_hand') | strcmp(SegmentName,'Right_Hand')
    % ______anatomical frame definition of the Right Hand________
    %                   adapted from Wu et al. (2005)
    % nick names
    MC3=AnatomicalMarkers(:,1); % basis MC III
    MCP2=AnatomicalMarkers(:,2); % MCP II
    MCP3=AnatomicalMarkers(:,3); % MCP III
    MCP5=AnatomicalMarkers(:,4); % MCP V
        
    origin=MC3;
    QFP=cross(origin-MCP3,origin-MCP5);  % Quasi frontal plane normal vector (pointing ventral)
                                         % or x_temp   
    y=origin-MCP3 ;
    z=cross(QFP,y);
    x=cross(y,z);
      
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    % normalization
    ex=x/norm(x);
    ey=y/norm(y);
    ez=z/norm(z);

    R=[ex ey ez];  % the anatomical coordinate system in cluster axes,
    % i.e. the rotation matrix
    t=origin;       % the translation vector from cluster origin to anatomical origin
    T = [R,t; 0 0 0 1]; % the transformation matrix

elseif strcmp(SegmentName,'right_forearm') | strcmp(SegmentName,'Right_Forearm')
    % ______anatomical frame definition of the Right Forearm_________
    %                           Wu et al (2005)
    % nick names

    PU=AnatomicalMarkers(:,1); % processus styloideus ulnae
    PR=AnatomicalMarkers(:,2); % processus styloideus radii
    EM=AnatomicalMarkers(:,3); % mediale epicondyl
    EL=AnatomicalMarkers(:,4); % lateral epicondyl
    
    origin=PU;
    EB=0.5*(EM+EL); % Elbow
    QFP=cross(EB-origin,PR-origin); 
    
    y=EB-origin;
    z=cross(QFP,y);
    x=cross(y,z);
    
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    % normalization
    ex=x/norm(x);
    ey=y/norm(y);
    ez=z/norm(z);

    R=[ex ey ez];  % the anatomical coordinate system in cluster axes,
    % i.e. the rotation matrix  
    t=origin;       % the translation vector from cluster origin to anatomical origin
    T = [R,t; 0 0 0 1]; % the transformation matrix

elseif strcmp(SegmentName,'right_humerus') | strcmp(SegmentName,'Right_Humerus')
    % ______anatomical frame definition of the Right Humerus_________
    %                           Wu et al (2005)
    %nick names
    EM=AnatomicalMarkers(:,1); % mediale epicondyl
    EL=AnatomicalMarkers(:,2); % lateral epicondyl
    GHJ=AnatomicalMarkers(:,3); % glenohumeral rotation center
    EB=0.5*(EM+EL); % Elbow
    
    origin=GHJ;
    QFP=cross(origin-EL,origin-EB);
    y=origin-EB;
    z=cross(QFP,y);
    x=cross(y,z);
    
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    % normalization
    ex=x/norm(x);
    ey=y/norm(y);
    ez=z/norm(z);

    R=[ex ey ez];  % the anatomical coordinate system in cluster axes,
    % i.e. the rotation matrix
    t=origin;       % the translation vector from cluster origin to anatomical origin
    T = [R,t; 0 0 0 1]; % the transformation matrix

% elseif strcmp(SegmentName,'right_humerus') | strcmp(SegmentName,'Right_Humerus')
%     % ______anatomical frame definition of the Right Humerus_________
%     % alternative (better) option when forearm is recorded, Wu et al (2005) 
%     %nick names
%     EM=AnatomicalMarkers(:,1); % medial epicondyl
%     EL=AnatomicalMarkers(:,2); % lateral epicondyl
%     GHJ=AnatomicalMarkers(:,3); % glenohumeral rotation center
%     PU=AnatomicalMarkers(:,4); % processus styloideus ulnae
% 
%     EB=0.5*(EM+EL); % Elbow
%     origin=GHJ;
%     QFP=cross(origin-EB,EB-PU); %EB-PU is y axis of forearm
%     y=origin-EB;
%     x=cross(y,QFP);
%     z=cross(x,y);
%     
%    % basic relations of a righthanded coordinate system
%    % z=cross(x,y);
%    % y=cross(z,x); 
%    % x=cross(y,z);
%    
%     % normalization
%     ex=x/norm(x);
%     ey=y/norm(y);
%     ez=z/norm(z);
% 
%     R=[ex ey ez];  % the anatomical coordinate system in cluster axes,
%     % i.e. the rotation matrix
%     t=origin;       % the translation vector from cluster origin to anatomical origin
%     T = [R,t; 0 0 0 1]; % the transformation matrix

elseif strcmp(SegmentName,'right_scapula') | strcmp(SegmentName,'Right_Scapula')
    % ______anatomical frame definition of the Right Scapula_________
    %                       Wu et al. (2005)
    % nick names
    TS=AnatomicalMarkers(:,1); % trigonum spinae scapulae
    AI=AnatomicalMarkers(:,2); % angulus inferior
    AA=AnatomicalMarkers(:,3); % angulus acromialis
    PC=AnatomicalMarkers(:,4); % processus coracoideus

    origin=AA;
    QFP=cross(origin-AI,origin-TS);
    z=origin-TS;
    y=cross(z,QFP);
    x=cross(y,z);
    
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    % normalization
    ex=x/norm(x);
    ey=y/norm(y);
    ez=z/norm(z);

    R=[ex ey ez];  % the anatomical coordinate system in cluster axes,
    % i.e. the rotation matrix
    t=origin;       % the translation vector from cluster origin to anatomical origin
    T = [R,t; 0 0 0 1]; % the transformation matrix
         
elseif strcmp(SegmentName,'trunk') | strcmp(SegmentName,'Trunk')
    % ______anatomical frame definition of the trunk_________
    %                   Wu et al. (2005)
    % nick names

    IJ=AnatomicalMarkers(:,1); % incisura jugularis
    PX=AnatomicalMarkers(:,2); % processus xiphoideus
    C7=AnatomicalMarkers(:,3); % processus spinosus C7
    Th8=AnatomicalMarkers(:,4); % processus spinosus T8

    origin = IJ;
    y=0.5*(IJ+C7)-0.5*(PX+Th8);
    QFP=cross(IJ-C7,IJ-0.5*(PX+Th8));
    x=cross(y,QFP);
    z=cross(x,y);
  
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    % normalization
    ex=x/norm(x);
    ey=y/norm(y);
    ez=z/norm(z);

    R=[ex ey ez];  % the anatomical coordinate system in cluster axes,
    % i.e. the rotation matrix
    t=origin;       % the translation vector from cluster origin to anatomical origin
    T = [R,t; 0 0 0 1]; % the transformation matrix

else
   
   warndlg({'ANATOMICAL_FRAME_DEF_CAMARC';' ';...
      ' no valid segment name';...
      },...
      '** BODYMECH WARNING') 

end

return
%======================================================================
% END ### AnatomicalFrameDefCamarc ### 
