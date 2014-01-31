%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function T=AnatomicalFrameDefinition_VECT(SegmentName,varargin)
% ANATOMICALFRAMEDEFINITION [BodyMech 3.06.01]: calculates anatomical frames 
% INPUT
%   SegmentName : name of the segment:  'Right_Humerus';'Right_Forearm';'Right_Hand';'Right_Acromion';'Sternum'
%                                       'Left_Humerus';'Left_Forearm';'Left_Hand';'Left_Acromion';'Sternum'
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
% $ Ver 3.07 FaBeR, Leuven, June 2007 (Ellen Jaspers)
% $ Ver 3.08 Vumc (Amsterdam) - FaBeR (Leuven), ALLE ACF RECHTSDRAAIEND

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

AnatomicalMarkers = varargin(:);

if strcmp(SegmentName,'right_hand') | strcmp(SegmentName,'Right_Hand')
   % ______anatomical frame definition of the hand right_________
   %                Wu et al. (ISB 2005)
   % nick names
   
   MC3=AnatomicalMarkers{1};  % proc styl MC3
   %MCP2=AnatomicalMarkers(:,); % MC-phalangeal 2
   MCP3=AnatomicalMarkers{2}; % MC-phalangeal 3
   MCP5=AnatomicalMarkers{3}; % MC-phalangeal 5
   % W=0.5*(RS+US);               % wrist joint centre
   
   origin = MC3;                
   QFP = cross(origin-MCP3,origin-MCP5);  % Quasi frontal plane normal vector (pointing ventral)
   y = origin-MCP3;               
   z = cross(QFP,y);              
   x = cross(y,z);                
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);
   
elseif  strcmp(SegmentName,'right_forearm') | strcmp(SegmentName,'Right_Forearm')
   % ______anatomical frame definition forearm right_________
   %                Wu et al. (ISB 2005) 
   %                adaptation to Schmidt et al. (1999), see also Cutti et al. (2005,2006) - mai 2008
   % nick names
   
   RS=AnatomicalMarkers{1}; % radial styloid
   US=AnatomicalMarkers{2}; % ulnar styloid
   EL=AnatomicalMarkers{3}; % lateral epicondyl
   EM=AnatomicalMarkers{4}; % medial epicondyl
   % W=0.5*(US+RS);             % wrist joint centre
   % E=0.5*(EL+EM);             % elbow joint centre
   
   %origin = 0.5*(RS+US); % NOT ISB
   origin = US;         % ISB COMPATIBLE
   QFP = cross(0.5*(EL+EM)-origin,RS-origin); % quasi frontal plane normal vector (pointing ventral)
   y = 0.5*(EL+EM)-origin;                      
   z = cross(QFP,y);                  
   x = cross(y,z);                            
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   
   % y=cross(z,x); 
   % x=cross(y,z);
   
   T = getT(x,y,z,origin);
   

elseif strcmp(SegmentName,'right_humerus') | strcmp(SegmentName,'Right_Humerus')
   % ______anatomical frame definition humerus right_________
   %                Wu et al. (ISB 2005)
   % only if forearm is recorded (second humerus definition ISB 2005)
   % nick names
   
   GHr=AnatomicalMarkers{1};  % GH rotation centre
   EL=AnatomicalMarkers{2};   % lateral epicondyl
   EM=AnatomicalMarkers{3};   % medial epicondyl
   US=AnatomicalMarkers{4};   % ulnar styloid
   RS=AnatomicalMarkers{5};   % radial styloid
   % E=0.5*(EL+EM);             % elbow joint centre
                                    
   origin = GHr;                     
   QSP = cross(origin-0.5*(EL+EM),0.5*(EL+EM)-0.5*(RS+US));   % quasi sagital plane normal vector (pointing lateral)   
   y = origin-0.5*(EL+EM);                      
   x = cross(y,QSP);                  
   z = cross(x,y);                    
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);
   
% elbowflexion+pronation als referentiepositie!! INWERKEN (start dec 2007)
%    R1=[ex ey ez];        % the anatomical coordinate system in cluster axes,
%                         % i.e. the rotation matrix
%    t1=origin;            % the translation vector from cluster origin to anatomical origin
%    T_ref_glo = [R1,t1; 0 0 0 1];  % the transformation matrix
% 
%    KinPose = BODY.SEGMENT(1).Cluster.KinematicsPose(:,:,t);
%    R2 = KinPose(1:3,1:3)';
%    t2 = -KinPose(1:3,4);
%    
%    T_global_frame = [R2,t2; 0 0 0 1];
% 
%    T = T_global_frame * T_ref_glo;

% added march 2009
elseif strcmp(SegmentName,'right_humerus_f') | strcmp(SegmentName,'Right_Humerus_f')
   % Reference frame defined with the functional axis
   
   GHr = AnatomicalMarkers{1};  % GH rotation centre
   EL = AnatomicalMarkers{2};   % lateral epicondyl
   EM = AnatomicalMarkers{3};   % medial epicondyl
   z = AnatomicalMarkers{4};    % F/E functional axis 
   z = z / norm(z);
   E = 0.5 * (EL + EM);         % elbow joint centre
                                    
   origin = GHr;                     
   yt = GHr - E;
   x = cross(yt, z);
   x = x / norm(x);
   y = cross(z, x);
   y = y / norm(y);
   
   T = getT(x,y,z,origin);
   

elseif strcmp(SegmentName,'right_hum1') | strcmp(SegmentName,'Right_Hum1')
   % ______anatomical frame definition first ACF humerus right_________
   %                Wu et al. (ISB 2005)
   % first humerus definition ISB 200
   % nick names
   
   GHr=AnatomicalMarkers{1};  % GH rotation centre
   EL=AnatomicalMarkers{2};   % lateral epicondyl
   EM=AnatomicalMarkers{3};   % medial epicondyl
   % E=0.5*(EL+EM);             % elbow joint centre
                                    
   origin = GHr;                     
   QFP = cross(EL-origin,EM-origin);   % quasi frontal plane normal vector (pointing forward)   
   y = origin-0.5*(EL+EM);                      
   z = cross(QFP,y);                  
   x = cross(y,z);                    
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);

elseif strcmp(SegmentName,'right_acromion') | strcmp(SegmentName,'Right_Acromion')
    % ______anatomical frame definition of the scapula right_________
    %                       Wu et al. (ISB 2005)
    % nick names
    
    AA=AnatomicalMarkers{1}; % ang acromialis
    AI=AnatomicalMarkers{2}; % ang inf
    TS=AnatomicalMarkers{3}; % trig spin scap
    %PC=AnatomicalMarkers(:,); % proc coracoideus

    origin = AA;                      
    QFP = cross(origin-AI,origin-TS); % quasi frontal plane normal vector (pointing ventral)
    z = origin-TS;                    
    y = cross(z,QFP);                 
    x = cross(y,z);                   
    
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);

elseif strcmp(SegmentName,'right_sternum') | strcmp(SegmentName,'Right_Sternum')
   % ______anatomical frame definition trunk_________
   %                Wu et al. (ISB 2005)
   % nick names
   
   C7=AnatomicalMarkers{1}; % proc spin C7
   T8=AnatomicalMarkers{2}; % proc spin T8
   IJ=AnatomicalMarkers{3}; % inc jungularis
   PX=AnatomicalMarkers{4}; % proc xypho�deus
      
   origin = IJ;
   QSP = cross(IJ-C7, IJ-0.5*(PX+T8)); % quasi sagital plane normal vector (pointing right)
   y = 0.5*(IJ+C7)-0.5*(PX+T8);
   x = cross(y,QSP);
   z = cross(x,y);
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);
   
% elseif strcmp(SegmentName,'chair') | strcmp(SegmentName,'Chair')
%    % ______frame definition chair_________
%    % nick names
%    
%    CH1=Markers(:,1);   % technical marker 1
%    CH2=Markers(:,2);   % technical marker 2
%    CH3=Markers(:,3);   % technical marker 3
%                                     
%    origin = (CH1 + CH2 + CH3)/3;                     
%    y = CH1 - origin;                      
%    x = origin - CH2;                  
%    z = cross(x,y);                    
%    
%    % basic relations of a righthanded coordinate system
%    % z=cross(x,y);
%    % y=cross(z,x); 
%    % x=cross(y,z);
%    
%    % normalization
%    ex=x/norm(x);
%    ey=y/norm(y);
%    ez=z/norm(z);
%    
%    R=[ex ey ez];        % the anatomical coordinate system in cluster axes,
%                         % i.e. the rotation matrix
%    t=origin;            % the translation vector from cluster origin to anatomical origin
%    T = [R,t; 0 0 0 1];  % the transformation matrix


% right coordinate systems defined for left UL , z-axis pointing medial (right)

elseif strcmp(SegmentName,'left_hand') | strcmp(SegmentName,'Left_Hand')
   % ______anatomical frame definition of the hand left_________
   %                Wu et al. (ISB 2005)
   % nick names
   
   MC3=AnatomicalMarkers{1};  % caput MC3
   %MCP2=AnatomicalMarkers{2}; % MC-phalangeal 2
   MCP3=AnatomicalMarkers{2}; % MC-phalangeal 3
   MCP5=AnatomicalMarkers{3}; % MC-phalangeal 5
   % W=0.5*(RS+US);             % wrist joint centre
   
%    origin = MC3; 
%    QDP = cross(origin-MCP3,origin-MCP5); % quasi frontal plane normal vector(pointing dorsal)
%    y = origin-MCP3;              
%    z = cross(QDP,y);             
%    x = -cross(y,z);               
   
   origin = MC3;                
   QFP = cross(origin-MCP3,MCP5-origin);  % Quasi frontal plane normal vector (pointing ventral)
   y = origin-MCP3;     % up          
   z = cross(QFP,y);    % medial          
   x = cross(y,z);      % forward
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);
   
elseif strcmp(SegmentName,'left_forearm') | strcmp(SegmentName,'Left_Forearm')
   % ______anatomical frame definition forearm left_________
   %              Wu et al. (ISB 2005)
   % nick names
   
   RS=AnatomicalMarkers{1}; % radial styloid
   US=AnatomicalMarkers{2}; % ulnar styloid
   EL=AnatomicalMarkers{3}; % lateral epicondyl
   EM=AnatomicalMarkers{4}; % medial epicondyl
   % W=0.5*(US+RS);           % wrist joint centre
   % E=0.5*(EL+EM);           % elbow joint centre
   
%    origin = 0.5*(RS+US); % NOT ISB
%    %origin = US;
%    QDP = cross(0.5*(EL+EM)-origin,RS-origin);   % quasi frontal plane normal vector (pointing dorsal)
%    y = 0.5*(EL+EM)-origin;                      
%    z = cross(QDP,y);                  
%    x = -cross(y,z);                    
   
   %origin = 0.5*(RS+US); % NOT ISB
   origin = US;         % ISB COMPATIBLE
   QFP = cross(0.5*(EL+EM)-origin,origin-RS); % quasi frontal plane normal vector (pointing ventral)
   y = 0.5*(EL+EM)-origin; % up                     
   z = cross(QFP,y);       % medial           
   x = cross(y,z);         % forward                   
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);  

elseif strcmp(SegmentName,'left_humerus') | strcmp(SegmentName,'Left_Humerus')
   % ______anatomical frame definition humerus left_________
   %              Wu et al. (ISB 2005)
   % nick names
   
   GHr=AnatomicalMarkers{1};  % GH rotation centre
   EL=AnatomicalMarkers{2};   % lateral epicondyl
   EM=AnatomicalMarkers{3};   % medial epicondyl
   US=AnatomicalMarkers{4};   % ulnar styloid
   RS=AnatomicalMarkers{5};   % radial styoid
   % E=0.5*(EL+EM);             % elbow joint centre
   % W=0.5*(RS+US);             % wrist joint centre
   
%    origin = GHr;                     
%    QSP = cross(origin-0.5*(EL+EM), 0.5*(EL+EM)-0.5*(RS+US));  % quasi sagital plane normal vector (pointing medial)
%    y = origin-0.5*(EL+EM);                      
%    x = cross(y,QSP);                  
%    z = -cross(x,y);                    
   
   origin = GHr;                     
   QSP = cross(origin-0.5*(EL+EM),0.5*(EL+EM)-0.5*(RS+US));   % quasi sagital plane normal vector (pointing medial)   
   y = origin-0.5*(EL+EM);    % up                  
   x = cross(y,QSP);          % forward        
   z = cross(x,y);            % medial  
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);

elseif strcmp(SegmentName,'left_humerus_f') | strcmp(SegmentName,'Left_Humerus_f')
   % Reference frame defined with the functional axis
   
   GHr = AnatomicalMarkers{1};  % GH rotation centre
   EL = AnatomicalMarkers{2};   % lateral epicondyl
   EM = AnatomicalMarkers{3};   % medial epicondyl
   z = AnatomicalMarkers{4};    % F/E functional axis 
   z = z / norm(z);
   E = 0.5 * (EL + EM);         % elbow joint centre
                                    
   origin = GHr;                     
   yt = GHr - E;
   x = cross(yt, z);
   x = x / norm(x);
   y = cross(z, x);
   y = y / norm(y);
   
   T = getT(x,y,z,origin);

elseif strcmp(SegmentName,'left_hum1') | strcmp(SegmentName,'Left_Hum1')
   % ______anatomical frame definition first ACF humerus left_________
   %                Wu et al. (ISB 2005)
   % first humerus definition ISB 200
   % nick names
   
   GHr=AnatomicalMarkers{1};  % GH rotation centre
   EL=AnatomicalMarkers{2};   % lateral epicondyl
   EM=AnatomicalMarkers{3};   % medial epicondyl
   % E=0.5*(EL+EM);             % elbow joint centre
                                    
%    origin = GHr;                     
%    QDP = cross(EL-origin,EM-origin);   % quasi frontal plane normal vector (pointing dorsal)   
%    y = origin-0.5*(EL+EM);                      
%    z = cross(QDP,y);                  
%    x = -cross(y,z);                       
    
   origin = GHr;                     
   QFP = cross(EM-origin,EL-origin);   % quasi frontal plane normal vector (pointing forward)   
   y = origin-0.5*(EL+EM);      % up                
   z = cross(QFP,y);            % medial      
   x = cross(y,z);              % forward      
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);
   
elseif strcmp(SegmentName,'left_acromion') | strcmp(SegmentName,'Left_Acromion')
    % ______anatomical frame definition of the scapula left_________
    %                       Wu et al. (ISB 2005)
    % nick names
    
    AA=AnatomicalMarkers{1}; % ang acromialis
    AI=AnatomicalMarkers{2}; % ang inf
    TS=AnatomicalMarkers{3}; % trig spin scap
    %PC=AnatomicalMarkers(:,); % proc coracoideus

%     origin = AA;                      
%     QDP = cross(origin-AI,origin-TS); % quasi frontal normal plane vector (pointing dorsal)
%     z = origin-TS;                    
%     y = cross(z,QDP);                 
%     x = cross(y,z);                   
    
    origin = AA;                      
    QFP = cross(origin-TS,origin-AI); % quasi frontal plane normal vector (pointing ventral)
    z = TS-origin;      % pointing medial                   
    y = cross(z,QFP);   % pointing up                
    x = cross(y,z);     % pointing ventral 
    
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);

elseif strcmp(SegmentName,'left_sternum') | strcmp(SegmentName,'Left_Sternum')
   % ______anatomical frame definition trunk_________
   %                Wu et al. (ISB 2005)
   % nick names
   
   C7=AnatomicalMarkers{1}; % proc spin C7
   T8=AnatomicalMarkers{2}; % proc spin T8
   IJ=AnatomicalMarkers{3}; % inc jungularis
   PX=AnatomicalMarkers{4}; % proc xypho�deus
      
   origin = IJ;
   QSP = cross(IJ-C7,IJ-0.5*(PX+T8)); % quasi sagital plane normal vector (pointing right)
   y = 0.5*(IJ+C7)-0.5*(PX+T8); % up
   x = cross(y,QSP);            % forward
   z = cross(x,y);              % pointing right
   
   % basic relations of a righthanded coordinate system
   % z=cross(x,y);
   % y=cross(z,x); 
   % x=cross(y,z);
   
    T = getT(x,y,z,origin);   
else
   
   warndlg({'ANATOMICAL_FRAME_DEF_CAMARC';' ';...
      ' no valid segment name';...
      strcat(' no valid segment name: ',SegmentName);...
      },...
      '** BODYMECH WARNING') 

end

return
%======================================================================
% END ### AnatomicalFrameDefCamarc ### 


%% Subfunctions

function T = getT(x,y,z,origin)

T = zeros(4,4,size(x,2));
for i = 1 : size(x,2)
    % normalization
    ex=x(:,i)/norm(x(:,i));
    ey=y(:,i)/norm(y(:,i));
    ez=z(:,i)/norm(z(:,i));

    R=[ex ey ez];        % the anatomical coordinate system in cluster axes,
                        % i.e. the rotation matrix
    t=origin(:,i);            % the translation vector from cluster origin to anatomical origin
    T(:,:,i) = [R,t; 0 0 0 1];  % the transformation matrix
end


