%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% BODYMECHFUNCHEADER [ BodyMech 3.06.01 ]: is called in each BodyMech Function to initialize global variables
% INPUT
%    none
% PROCESS
%    makes BodyMech global varables available in BodyMech Functions
% OUTPUT
%   none

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% main datastructure
global BODY

% intermediate storage variables for experimental data input
global MARKER_DATA
global MARKER_TIME_GAIN
global MARKER_TIME_OFFSET
global iP

global ANSIGNAL_DATA
global ANSIGNAL_TIME_GAIN
global ANSIGNAL_TIME_OFFSET

% general constants
global X Y Z U

% vizualisation handles
global ORTHO_DISPLAY_MODE
global DDD_DISPLAY_MODE
global VIZ
global VizTime

% dataflow control 
global BODYSTATUS

%====================================================================
% END ### BodyMechFuncHeader ###
