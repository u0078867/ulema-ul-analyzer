%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CreateBodyContext(ContextName)
% CREATEBODYCONTEXT [ BodyMech 3.06.01 ]: declares the CONTEXT variables of BODY
% INPUT
%   ContextName : name of the experimental location (usually a lab)
% PROCESS
%   Generation of a substructure to the global variable BODY
%   that houses contextual information to a movement study.
% OUTPUT
%   GLOBAL: BODY.CONTEXT 

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

BODY.CONTEXT.Name=ContextName;

BODY.CONTEXT.MotionCaptureToLab=eye(4); % 4x4 transformation matrix from MotionCaptureFrame to labFrame

BODY.CONTEXT.ExternalForce=[];

BODY.CONTEXT.Stylus=[];

BODY.CONTEXT.AnatomicalCalculationFunction='';

BODY.CONTEXT.EVENTS=[];

BODY.CONTEXT.RESULTS=[];

return
% ============================================ 
% END ### CreateBodyContext ###
