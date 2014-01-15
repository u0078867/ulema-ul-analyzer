%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function StylusTip=NDprobe06117(InputData)
% NDPROBE06117 [ BodyMech 3.06.01 ]: calculates the tip coordinates of the stylus
% INPUT
%   Input: actual global stylus marker coordinates
% PROCESS
%   uses: a stylus specific calculation
% OUTPUT
%   StylusTip=global coordinates of the stylus tip 

% AUTHOR(S) AND VERSION-HISTORY
% Creation Jaap Harlaar, VUmc, Amsterdam, December 2000
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader
BODY.CONTEXT.Stylus.CalibrationDate='March 7, 2005' ;


% the following holds for Northern Digital Probe no. RB-06117
% Last calibration -- May 2005 -
% Previous calibration march 2003

LocalProbeMarkerCoordinates = ... 
[                 4.1240      -15.5703      -76.2055   ; ...
                  -1.5281      15.3343      -76.4282   ; ...
                  0.7759       15.5950     -120.7892   ; ...
                  2.3586       15.7716     -165.5278   ; ...
                  8.2066      -15.2442     -165.2263   ; ...
                  6.1804      -15.5707     -120.7250    ]'/1000.;
			  
 % [n_coordinates n_markers]
 % in meters

LocalProbeTipCoordinates=[ 0 0 0 1]; % probe tip is the origin of the cluster reference frame
                                  % follows from the optotrak calibration procedure
StylusTip=[NaN ; NaN ; NaN]; % default output

% INPUT checks
if nargin<1,
   errordlg({'no input data'; 'StylusToTip'},...
      '** BODYMECH ERROR')
   return
elseif InputData==0 
   errordlg({'no input data'; 'StylusToTip'},...
      '** BODYMECH ERROR') 
   return
end

% PROCESS
% pose of the probe
GlobalProbeMarkerCoordinates=(InputData); 
% [n_space=3,n_markers]  

Vind=find(~isnan(GlobalProbeMarkerCoordinates(1,:))); % find valid indices

if length(Vind) < 3,
   errordlg({'not enough visible markers on Stylus'; 'StylusToTip'},...
      '** BODYMECH ERROR')
return
end
        
[R,t]= ...              
   RigidBodyTransformation(LocalProbeMarkerCoordinates(:,Vind),GlobalProbeMarkerCoordinates(:,Vind));
ProbePose=[R,t;0 0 0 1];

% anatomical location
GlobalProbeTipCoordinates=ProbePose*LocalProbeTipCoordinates';

% OUTPUT
StylusTip=GlobalProbeTipCoordinates(1:3);

return
% ============================================ 
% END ### NDprobe06117 ###
