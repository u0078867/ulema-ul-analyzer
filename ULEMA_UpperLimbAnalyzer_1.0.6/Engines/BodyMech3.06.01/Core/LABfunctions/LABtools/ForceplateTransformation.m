%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [motionanalysis_to_lab,forceplate_to_lab]=ForcePlateTransformation(FPident,FPcornersMAS)
% FORCEPLATETRANSFORMATION [ BodyMech 3.06.01 ]: Calculates calibration of laboratory equipment setup
% INPUT
%   FPcornersMAS=[c1_mas c2_mas c3_mas c4_mas];
%   (To be generated with eg: ProbeForcePlateCorners.m)
%   default is the 1999 calibration of VUmc laboratory
% PROCESS
%   calculates transformation based on factory calibrations 
% OUTPUT
%   motionanalysis_To_lab = transformation matrix 
%   forceplate_To_lab = transformation matrix 

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

% ================================================
% CALIBRATION OF THE MOTION ANALYSIS COORDINATE SYSTEM 

% the geometrical centre of the force plate is definied as the origin of the
% laboratory coordinate system
% the principal axis of the laboratory coordinate system are aligned with the gravitational
% force and the longitudinal axis of the walkway
% 
% adapting the ISB recommendations for standardization in the reporting of kinematic data,
% the Y axis points upward and parallel with the field of gravity
% which is perpendicular to the laboratory-floor,  
% the X axis points in the direction of the walkway (from left to right) 
% as a consequence (in a right handed coordinate system), the Z axis points away from the wall
% 

% Coordinates of the corners of the force plate in the laboratory coordinate system
% starting with the nearby left corner when next to the walkway in front of the forceplate
% facing the wall, subsequent corners clock-wise

% dimensions of the AMTI OR6-5  forceplate:
fp_length=.508; % in m
fp_width=.464;  

c1_lab = [ -fp_width/2. ; 0 ;  fp_length/2.];
c2_lab = [ -fp_width/2. ; 0 ; -fp_length/2.];
c3_lab = [  fp_width/2. ; 0 ; -fp_length/2.];
c4_lab = [  fp_width/2. ; 0 ;  fp_length/2.];

fp_corners_lab=[ c1_lab c2_lab c3_lab c4_lab ];

% The Optotrak KUBE calibration frame is used to calibrate the 3D motion analysis sensors to a common
% motion analysis coordinate system
% kube placed in the nearby left corner when next to the walkway in front of the forceplate, facing the wall
%
% after calibration, digitization of the corners of the forceplate at November 5, 1999 yielded:
c1_kub = [-10.3 ; -.5   ; 119.6]./1000.; % in meters
c2_kub = [499.3 ; 2.7   ; 119.6]./1000.;
c3_kub = [496.1 ; 466.3 ; 118.7]./1000.;
c4_kub = [-11.3 ; 464.1 ; 118.5]./1000.;

fp_corners_kub=[ c1_kub c2_kub c3_kub c4_kub ];

% For other calibrations:
% FPcornersMAS must be passed as input 

if nargin<1
    fp_corners_mas=fp_corners_kub;
else
    fp_corners_mas=FPcornersMAS;
end

% transformation
[R,t]=RigidBodyTransformation(fp_corners_mas,fp_corners_lab);

motionanalysis_to_lab=[R,t; 0 0 0 1];

% ================================================
% CALIBRATION OF THE FORCE PLATE COORDINATE SYSTEM 

% In the laboratory of human movement analysis of the department of Rehabilitation medicine
% of the Free University Hospital the aligment of the force plate is such that standing
% in front of the walkway, the connector is in front of the force plate, this means that:
% the X axis points from right to left
% the Y axis points away, towards the wall
% (as a consequence in a right handed coord.system) the Z- axis points down  

% the forceplate (OR6-5-1000 serialnr. 3509 bought in 1994):
% has the origin of the mechanical coordinate system with respect to the geometrical center
% of the surface of the forceplate (factory provided calibration)

xmech_offset=0.;
ymech_offset=-0.68/1000.;
zmech_offset=41/1000.;

% the force-plate is covered with linoleum that is 3 mm. thick 
zmech_offset=zmech_offset+.003;

% transformation
fp_geometrical_to_fp_mechanical= ...
   [eye(3),[xmech_offset ymech_offset zmech_offset]' ; 0 0 0 1];

% the geometrical forceplate towards laboratory: X_lab=-X_fp ; Y_lab=-Z_fp Z_lab=-Y_fp : 
fp_geometrical_to_lab= [ -1  0  0  0 ;...
                          0  0 -1  0 ;...
                          0 -1  0  0 ;...
                          0  0  0  1 ];
                    
forceplate_to_lab=fp_geometrical_to_lab*inv(fp_geometrical_to_fp_mechanical);

return

% ============================================ 
% END ### ForceplateTransformation ###
