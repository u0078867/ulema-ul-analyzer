%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ClearBody()
% CLEARBODY [ BodyMech 3.06.01 ]: Clears (global) BODY content of All ModelType Fields form BODY
% INPUT
%   none
% PROCESS
%   Clears all BODY fields contents
% OUTPUT
%   GLOBAL BODY (empty fields)

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

global BODY
BODY.SEGMENT=ones(0);
BODY.JOINT=ones(0);
BODY.MUSCLE=ones(0);
BODY.HEADER=ones(0);
BODY.CONTEXT=ones(0);
BODY.CONTEXT.ExternalForce=[];
BODY.CONTEXT.Stylus=[];

% ==========================================================
% END ### ClearBody ###
