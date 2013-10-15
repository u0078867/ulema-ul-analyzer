%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ProbeForcePlateCorners;
% PROBEFORCEPLATECORNERS [ BodyMech 3.06.01 ]: probing the forceplate corners
% INPUT
%    Input : 
% PROCESS
%   
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, AMsterdam, November 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

ClearBody

CreateBodyHeader('Probe');

% context 
% ==============================================
CreateBodyContext('lab_rehab_VU_amsterdam');

BODY.CONTEXT.MotionCaptureToLab=eye(4);

CreateStylus('Stylus1',1,[1 2 3 4 5 6],'NDprobe06117');

% ======================================================

c1_mas=loadprobing('corner1'); % corner 1 in the MAS: motion analysis system
c2_mas=loadprobing('corner2');
c3_mas=loadprobing('corner3');
c4_mas=loadprobing('corner4');

fp_corners_mas=[c1_mas c2_mas c3_mas c4_mas];

[filename,pathname]=uiputfile('*.mat','Save Forceplate_corners');
    
save([char(pathname),char(filename)], 'fp_corners_mas');

%=========================================================================
% END ### ProbeForcePLateCorners ###
