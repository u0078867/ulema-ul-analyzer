%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function BodyMech
% BODYMECH [ BodyMech 3.06.01 ]: Executes Human Movement Analysis Software BodyMech
% INPUT  
%   no input required
% PROCESS   
%   Creates Global parameters and initializes BodyMech
%   Opens the Graphical User Interface of Bodymech
% OUTPUT
%   GUI of BodyMech

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, April 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

InitBodyMech

h=findobj('Tag','BodyMechControlWindow');
if isempty(h), 
   BodyMechControlWindow
end

ListBodyModel

%========================================================================
% END ### BodyMech ###
