%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function StylusTip=NDprobe06138(InputData)
% NDPROBE06138 [ BodyMech 3.06.01 ]: calculates the tip coordinates of the stylus
% INPUT
%   InputData : actual global stylus marker coordinates
% PROCESS
%   uses: a stylus specific calculation
% OUTPUT
%   StylusTip=global coordinates of the stylus tip 

% AUTHOR(S) AND VERSION-HISTORY
% $ Creation Jaap Harlaar, VUmc, Amsterdam, May 2001
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

% the following holds for Northern Digital Probe no. RB-06117
% Last calibration April 12, 2001
% Previous calibration unknown

LocalProbeMarkerCoordinates = ...
   [  -3 -65 -59 ; ...
      -4 -40 -78 ; ...
      -11 -67 -113 ; ...
      -13 -94 -148 ; ...
      -9 -119 -130 ; ...
      -6 -92 -95]'...% [n_coordinates n_markers]
   ./1000.; 							    % in meters


LocalProbeTipCoordinates=[ 0 0 0 1]; % probe tip is the origin of the cluster reference frame
                                  % follows from the optotrak calibration procedure

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
GlobalProbeMarkerCoordinates=(InputData); % [n_space=3,n_markers]          
[R,t]= ...              
   RigidBodyTransformation(LocalProbeMarkerCoordinates,GlobalProbeMarkerCoordinates);
ProbePose=[R,t;0 0 0 1];

% anatomical location
GlobalProbeTipCoordinates=ProbePose*LocalProbeTipCoordinates';

% OUTPUT
StylusTip=GlobalProbeTipCoordinates;

return
% ============================================ 
% END ### NDprobe06138 ###
