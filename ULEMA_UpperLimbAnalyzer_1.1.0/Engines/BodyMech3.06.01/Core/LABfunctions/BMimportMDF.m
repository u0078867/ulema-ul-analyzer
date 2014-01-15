%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function datafile = BMimportMDF(name);
% BMIMPORTMDF [ BodyMech 3.06.01 ]: Import analog data from Sybar data file (*.Mdf)
% INPUT
%   name of file
% PROCESS
%   Load the files and selects synchronized part
% OUTPUT
%   GLOBAL: ANSIGNAL_DATA
%           ANSIGNAL_TIME_OFFSET
%           ANSIGNAL_TIME_GAIN

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, April 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader
global IMPORT_MDF_DIR

if ~isempty(IMPORT_MDF_DIR),
    cd(IMPORT_MDF_DIR);
end

if nargin==1
   [datafile,datapath] = uigetfile(name, 'open SYBAR file');
else
   [datafile,datapath] = uigetfile('*.mdf', 'open SYBAR file');
end

if datafile ~= 0
   fid=fopen([datapath,datafile]);
   [data,header]=readMdf(datafile,datapath);
   IMPORT_MDF_DIR=datapath;
   
else 
   return
end

h=msgbox(header,'MDF content');
uiwait(h)

% track sfreq from header
line=deblank(header(3,:));
SfreqInd=find(48 <= line & line <= 57);  % look for any number characters (ascii(0..9))
Sfreq=str2num(line(SfreqInd));
ANSIGNAL_TIME_GAIN=1./Sfreq;

ANSIGNAL_DATA=NaN*zeros(0,0);

if size(data,2)==16   
   SYNC=data(:,16);
   SynchroWithOT=find(SYNC==1); 
   if ~isempty(SynchroWithOT),
      Start=SynchroWithOT(1);
      Stop=SynchroWithOT(length(SynchroWithOT));
   end
else
   Start=1;Stop=size(data,1); % no SYNC channel, take all the data
end

ANSIGNAL_TIME_OFFSET=0.;

if Stop>=Start,
    ANSIGNAL_DATA=data(Start:Stop,1:15);    
end

BodyMechFuncFooter
return
% ============================================ 
% END ### BMimpostMDF ###
