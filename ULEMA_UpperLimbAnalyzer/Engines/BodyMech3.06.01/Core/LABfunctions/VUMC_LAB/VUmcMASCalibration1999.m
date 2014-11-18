%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ForcePlateCornersMAS=VUmcMASCalibration1999
%  VUMCMASCALIBRATION1999 [ BodyMech 3.06.01 ]: provides
%  forceplatecorner-coordinates used in 1999 at the LAB VUmc
% INPUT
%   no variables
%   the 1999 calibration of Forceplate in the VUmc laboratory is documented
%   here 
% PROCESS
%   calculates corners
% OUTPUT
%    ForcePlateCornersMAS = [3 x 4] matrix of the MAS coordinates of each corner 

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Created  (Jaap Harlaar, VUmc, Amsterdam, December 2005)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% Coordinates of the corners of the force plate in the laboratory coordinate system
% starting with the nearby left corner when next to the walkway in front of the forceplate
% facing the wall, subsequent corners clock-wise

% The Optotrak KUBE calibration frame is used to calibrate the 3D motion analysis sensors to a common
% motion analysis coordinate system
% kube placed in the nearby left corner when next to the walkway in front of the forceplate, facing the wall
%
% after calibration, digitization of the corners of the forceplate at November 5, 1999 yielded:
c1_mas = [-10.3 ; -.5   ; 119.6]./1000.; % in meters
c2_mas = [499.3 ; 2.7   ; 119.6]./1000.;
c3_mas = [496.1 ; 466.3 ; 118.7]./1000.;
c4_mas = [-11.3 ; 464.1 ; 118.5]./1000.;

ForcePlateCornersMAS=[ c1_mas c2_mas c3_mas c4_mas ];

return

% ================================================================= 
% END ### VUMCMASCalibration1999 ###
