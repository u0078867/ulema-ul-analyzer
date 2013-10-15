%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [filename,pathname]=LoadBodyFile(filename,pathname)
% LOADBODYFILE [ BodyMech 3.06.01 ]: Opens BodyFile (*.BMB) selected by user
% INPUT
%   none
% PROCESS
%   Opens BodyFile selected by user
% OUTPUT
%   filename and ptahname of selected BMB file

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader

if nargin == 2,
    cd(pathname);
    [filename,pathname]=uigetfile(filename,'Open BodyMech-BODY');
elseif nargin==1
    if strncmp(filename,' ',1),
        boxheader=filename;
        [filename,pathname]=uigetfile('*.bmb',['Open BodyMech-BODY',boxheader],400,200);
    else
        [filename,pathname]=uigetfile(filename,'Open BodyMech-BODY');
    end
else
    [filename,pathname]=uigetfile('*.bmb','Open BodyMech-BODY');
end


% read BODY
if filename ~= 0
    ClearBody;
    load([char(pathname),char(filename)], 'BODY', '-mat');
    cd(pathname);
else
    return
end
% ============================================
% END ### LoadBodyFile ###
