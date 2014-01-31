%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function SetAnglesMeaning(JointIndex,RevSet,Names)
% REVERTJOINTANGLES [ BodyMech 3.06.01 ]: set some futher info to jointangles
% INPUT
%   JointIndex: a priori joint number
%   RevSet: 1 x 3 array of multiplying factor for the 3 joint angles, usually +1 or -1.
%   Names: 1 x 3 cell-array of strings. Angles with empty names will not be saved 
% PROCESS
%   Generation of variable that represent a joint of the human body
% OUTPUT
%   GLOBAL: BODY.JOINT: new cell in the array of joint names

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Davide Monari, Pellenberg Kliniek, Leuven, October 2011) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

% Posture referenced kinematics
BODY.JOINT(JointIndex).PostureRefKinematics.AnglesMult=RevSet;
BODY.JOINT(JointIndex).PostureRefKinematics.AngleNames=Names;

% Anatomy referenced kinematics
BODY.JOINT(JointIndex).AnatomyRefKinematics.AnglesMult=RevSet;
BODY.JOINT(JointIndex).AnatomyRefKinematics.AngleNames=Names;


return
% ============================================ 
% END ### RevertJointAngles ###
