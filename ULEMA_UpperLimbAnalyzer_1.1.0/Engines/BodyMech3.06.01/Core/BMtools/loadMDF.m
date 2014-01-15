%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [data,header,datafile] = LoadMDF(name);
% LOADMDF : loads SYBAR data files (*.MDF) from disk
% INPUT
%    Input : 
% PROCESS
%   
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver. 1.0  Creation (Jaap Harlaar, VUmc, Amsterdam, April 2000) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

if nargin==1
   [datafile,datapath] = uigetfile(name, 'open SYBAR file', 40, 40);
else
   [datafile,datapath] = uigetfile('*.mdf', 'open SYBAR file', 40, 40);
end

if datafile ~= 0
   fid=fopen([datapath,datafile]);
   [data,header]=readmdf(datafile,datapath);
   eval(['cd ',datapath]);
else 
   return
end

h=msgbox(header,'MDF content');
uiwait(h)
nLines=size(header,1);

% #########################################
%  get Version Number from header
% #########################################

VersionNo=[];
i=1;
while i<=nLines & isempty(VersionNo),
    line=deblank(header(i,:));
    if ~isempty(strfind(line,'ersion')),
        
        VersionNoIndices=find(48 <= line & line <= 57);  % look for any number characters (ascii(0..9))
        VersionNoIndices=[min(VersionNoIndices):max(VersionNoIndices)];
        VersionNo=str2num(line(VersionNoIndices));
    end
    i=i+1;
end


% #########################################
%  get Sample Frequency from header
% #########################################
Sfreq=[];
i=1;
while i<=nLines & isempty(Sfreq),
    line=deblank(header(i,:));
    if ~isempty(strfind(line,'ersion')),
        
        SfreqIndices=find(48 <= line & line <= 57);  % look for any number characters (ascii(0..9))
        SfreqIndices=[min(SfreqIndices):max(SfreqIndices)];
        Sfreq=str2num(line(SfreqIndices));
    end
    i=i+1;
end

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

if Stop>=Start,
    data=data(Start:Stop,:);    
end

return
% ============================================ 
% END ### LoadMdf ###
