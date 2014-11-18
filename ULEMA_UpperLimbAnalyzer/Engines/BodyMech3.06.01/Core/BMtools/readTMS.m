%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [Signal,Sfreq,SignalName] = readTMS(name)
% READTMS : reads a file which holds a measurement from the TMS porti system
% dicrimates between: Poly5 format 9(ee TMS POLY 5 technical reference guide, page 179)
% The later TMS32 format, necessary to read large signals. 
% INPUT
% name = name of the file (including path and extension)
% OUTPUT
% Signal [Nsamples, Nchannels] : matrix of measured data (TMS32: floatingpoint; poly5: integer)
% Sfreq : 1/intersample_interval (integer number)
% SignalName [Nchannels] : cell array of channel names

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver. 1.0  Creation (for Poly5 format: poly5read.m) Idsart Kingma (3-11-1997)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% =======================================
% initialize

Signal = [];
Sfreq = [];
SignalName={};

% =======================================
% openfile

fid=fopen(name,'r');
if fid == -1;
  disp([name ' not found']); return
end;

% =======================================
% check version

n=0; ch ='x';		% char field has diff size for diff POLY versions.
while ch ~= 10											
   ch = fread(fid,1,'char');
   n=n+1;
   ver(n) = ch;
end


if fread(fid,1,'char')~=26
   disp([name ' is not a PORTI data file']); return
end

version = fread(fid,1,'int16');
if ~any(version==[203; 204])
   disp (['New version of POLY: ',num2str(version)])
end

% ===================================================
% read header

mname = fread(fid,81,'char')';					% read measurement name (pascal format)
measurementname = char(mname(2:mname(1)+1));	% and convert to characters
Sfreq = fread(fid,1,'int16');              		% read sample frequency
storagerate = fread(fid,1,'int16');             % read sample frequency
storagetype = fread(fid,1,'int8');              % 0= in Hz; 1 = in Hz exp(-1)
Nsignals = fread(fid,1,'int16');               	% read number of signals
startsamplerecordcount = fread(fid,1,'int64');
samplerecordcount = startsamplerecordcount;
datetime = fread(fid,7,'int16');            	% year, month, day, weekday (0=sunday),hour, minute, second
ndatablocks = fread(fid,1, 'int32');
nsamplerecordsperblock = fread(fid,1,'uint16');

datablocksize = fread(fid,1, 'uint16');
if nsamplerecordsperblock ~= datablocksize/(2*Nsignals) | ~(Nsignals > 0 )
    disp('Header block:')
    disp('--------------------------------')
    disp(['samplefreq      = ' num2str(Sfreq)])
    disp(['storagerate     = ' num2str(storagerate)])
    disp(['storagetype     = ' num2str(storagetype)])
    disp(['nsignals        = ' num2str(Nsignals)])
    disp(['datetime        = ' num2str(datetime')])
    disp('--------------------------------')
    error('ERROR IN FILE READING: inconsistent number of samples per block; probably compressed data');
end;

datacompression = fread(fid,1,'uint16');
rommel = char(fread(fid,64, 'char'))';

% ===================================================
% Determine data-format and read signal names

NameId = fread(fid,136,'char');  % NameId(1) holds actual length

if char(NameId(2:5)')== '(Lo)',  % if prefix present: TMS32 floating format is used
    datatype = 'float32';
    Nsignals = Nsignals / 2;
    
    NameId = fread(fid,136,'char'); % Name with prefix '(Hi)' 
    SignalName{1} =char(NameId(6:NameId(1)+1))';  % signalname without prefix '(Hi)' 
    Isignal=1;
    while Isignal < Nsignals;  
        Isignal=Isignal+1;
        NameId = fread(fid,136,'char'); % Name with prefix '(Lo)'
        NameId = fread(fid,136,'char'); % Name with prefix '(Hi)'
        SignalName{Isignal} =char(NameId(6:NameId(1)+1))'; % signalname without prefix '(Hi)'
    end  
    
else
    datatype = 'int16'; % no prefix: poly5 format is used
    
    SignalName{1} =char(NameId(2:NameId(1)+1))';
    Isignal=1;
    while Isignal < Nsignals;  
        Isignal=Isignal+1;
        NameId = fread(fid,136,'char'); 
        SignalName{Isignal} =char(NameId(2:NameId(1)+1))';
    end  
end

% ===================================================
% read signals from the data-blocks

Signal = [];

for i = 1:ndatablocks;
    samplerecordsequence =  fread(fid,1,'int64'); %sample number of first sample in this block 
    % starts counting at 0 !!
    datetime = fread(fid,7,'int16'); % year, month, day, weekday (0=sunday),
    % hour, minute, second
    rommel = fread(fid,64,'char'); % reserved bytes
    
    if i<ndatablocks;
        data = fread(fid,nsamplerecordsperblock*Nsignals,datatype); %read data block
        data = reshape(data,Nsignals,nsamplerecordsperblock)';     
        samplerecordcount = samplerecordcount - nsamplerecordsperblock;
    else
        if ~ (samplerecordsequence + samplerecordcount == startsamplerecordcount); %counter starts counting at 1 !!
            error ('error counting number of samples in file');
        end
        
        data = fread(fid,samplerecordcount*Nsignals,datatype); % read data block
        data = reshape(data,Nsignals,samplerecordcount)';     
    end      
    Signal = [Signal; data]; % add data block to output
end


fclose(fid);
return
%==========================================================================
% END ### readTMS ###
