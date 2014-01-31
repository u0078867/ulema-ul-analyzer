%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [data,names,Sfreq,datafile] = loadTMS(name);
% LOADTMS : loads PORTI data files (*.S??) from disk
% INPUT:
% PROCESS
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver. 1.0  Creation (Jaap Harlaar, VUmc, Amsterdam, April 2003 ) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

if nargin==1
   [datafile,datapath] = uigetfile(name, 'open PORTI file', 40, 40);
else
   [datafile,datapath] = uigetfile('*.S??', 'open PORTI file', 40, 40);
end

if datafile ~= 0
   [data,Sfreq,names] = ReadTMS([datapath,datafile])
   eval(['cd ',datapath]);
else 
   return
end

h=msgbox(names,'SignalName');
uiwait(h)

return
% ============================================ 
% END ### loadTMS ###
