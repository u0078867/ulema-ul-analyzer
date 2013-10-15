%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function InitBodyMech
% INITBODYMECH [ BodyMech 3.06.01 ]: initializes BodyMech status of variables
% PROCESS
%   Initialization of BodyMech global variables
% OUTPUT
%   GLOBAL: MARKER_DATA, MARKER_TIME_GAIN, MARKER_TIME_OFFSET
%           ANSIGNAL_DATA, ANSIGNAL_TIME_GAIN, ANSIGNAL_TIME_OFFSET
%           X=1	Y=2	Z=3	U=4
%           VIZ.ORTHOMODE, VIZ.ORTHOHANDLE
%           VIZ.DDDMODE, VIZ.DDDHANDLE
%           BODYSTATUS

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

warning off

BodyMechFuncHeader % declare global variables

% GLOBAL VARIABLES INITIALIZATION: 
ClearBodyProjectModel;

MARKER_DATA=zeros(0);
MARKER_TIME_GAIN=zeros(0);
MARKER_TIME_OFFSET=zeros(0);
ANSIGNAL_DATA=zeros(0);
ANSIGNAL_TIME_GAIN=zeros(0);
ANSIGNAL_TIME_OFFSET=zeros(0);

X=1;	Y=2;	Z=3;	U=4;

VIZ.ORTHOMODE=[0 0 0 0 0 0 0 0 0]; 
% 1= markers
% 2= cluster frames
% 3= orientation referenced cluster frames
% 4= anatomical frmaes
% 5= anatomical markers
% 6= stick figures
% 7= external reaction forces
VIZ.ORTHOHANDLE=ones(0,0,0);

VIZ.DDDMODE=[0 0 0 0 0 0 0 0 0]; 
VIZ.DDDHANDLE=ones(0,0); 

VizTime=-1;

BODYSTATUS=[];

%=============================================================
% END ### InitBodyMech ###
