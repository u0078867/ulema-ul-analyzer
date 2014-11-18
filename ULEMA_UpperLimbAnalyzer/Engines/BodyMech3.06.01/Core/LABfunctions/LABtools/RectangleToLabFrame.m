%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ma2lab=RectangleToLabFrame(RectCornersMAS)
% RECTANGLETOLABFRAME [ BodyMech 3.06.01 ]: Calculates calibration of laboratory frame by equipment setup
% INPUT
%   RectCornersMAS = [ 3 x 4 ] matrix
%   Coordinates of the 4 corners of the rectangle - that is assumed to be
%   level - given in the coordinate system of the Movement analysis system
%   NB the sequence of the corners c1--c4 (see below) is critical
%   Tip: Taking the corners of the forceplate is quite convenient
% PROCESS
%   Calibratin of the motion analysis coordinate system towards a standard
%   labsystem: 
% ================================================
%   the geometrical centre of the rectangle is definied as the origin of the
%   laboratory coordinate system
% 
%   adapting the ISB recommendations for standardization in the reporting of kinematic data,
%   the Y axis points upward and parallel with the field of gravity
%   which is perpendicular to the laboratory-floor,  
%   the X axis points in the direction of the walkway (assumed from left to right) 
%   Zaxis follows as a consequence (in a right handed coordinate system), 
%
%   TOP VIEW
%                c2 --------------------- c3
%                  |                     |
%                  |                     |
%                  |          o--------------> X
%                  |          |          |
%                  |          |          |
%                c1 ----------|---------- c4 
%                             |
%                             | 
%                            \ /
%                             Z
%
%
% OUTPUT
%   ma2lab= (4x4) transformation matrix 

% AUTHOR(S) AND VERSION-HISTORY
% $ Creation (Jaap Harlaar, VUmc, AMsterdam, November 2003)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

c1=RectCornersMAS(:,1)';
c2=RectCornersMAS(:,2)';
c3=RectCornersMAS(:,3)';
c4=RectCornersMAS(:,4)';


Origin=mean([c1 c2 c3 c4]);

RectLenght=mean([norm(c3-c2); norm(c4-c1)]);
RectWidth=mean([norm(c1-c2); norm(c4-c3)]);

c1_lab = [ -RectLenght/2. ; 0 ;  RectWidth/2.];
c2_lab = [ -RectLenght/2. ; 0 ; -RectWidth/2.];
c3_lab = [  RectLenght/2. ; 0 ; -RectWidth/2.];
c4_lab = [  RectLenght/2. ; 0 ;  RectWidth/2.];

RectCornersLab=[ c1_lab c2_lab c3_lab c4_lab ];


[R,t]=RigidBodyTransformation(RectCornersMAS,RectCornersLab);

ma2lab=[R,t; 0 0 0 1];

return

% ============================================ 
% END ### RectangleToLabFrame ###
