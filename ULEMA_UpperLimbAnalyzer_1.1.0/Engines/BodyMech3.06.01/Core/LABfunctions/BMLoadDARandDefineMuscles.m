%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [DarFilename,datapath]=BMLoadDARandDefineMuscles(DarFilename,datapath)
% BMLOADDARANDDEFINEMUSCLES [ BodyMech 3.06.01 ]: loads Dar files 
% INPUT 
%   Optional: name of the file
% PROCESS
%   - read data from DICOM structured files (using ReadDar4BM)
%   - select a synchronized part with associated OptoTrakFile
% OUTPUT
%   Global: ANSIGNAL_DATA
%           ANSIGNAL_TIME_OFFSET
%           ANSIGNAL_TIME_GAIN

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0  Creation (Jaap Harlaar, VUmc, Amsterdam, April 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

% invoke the windows-file-browser when no input is given:
if nargin < 1,
   [DarFilename,datapath] = uigetfile('*.dar', 'open DAR file',40,40);
   cd(datapath);
elseif nargin < 2,
    datapath=cd;
end

if DarFilename ~= 0
   DarData=ReadDar4BM(DarFilename);
else
   return
end

ANSIGNAL_DATA=[];
ANSIGNAL_TIME_OFFSET=[];
ANSIGNAL_TIME_GAIN=[];


% FFE: warning to user if name already exists
BODY.HEADER.Trial.MarkerDataFile=char(DarData.OptoTrakFileID);

% nicknames 
Nchannels=DarData.NumberOfWaveformChannels; 
Nsamples=DarData.NumberOfWaveformSamples;

% init
ANSIGNAL_DATA=NaN*ones(size(DarData.WaveformData))';

for iChannel=1:Nchannels,
   ANSIGNAL_DATA(:,iChannel)=(...
      (DarData.WaveformData(iChannel,:).*...
         DarData.ChannelSensitivity(iChannel))-...
      DarData.ChannelBaseline(iChannel)...
      )';
end

ANSIGNAL_TIME_OFFSET=0.;  % see remark below
ANSIGNAL_TIME_GAIN=1./DarData.SamplingFrequency; 


% ============================================================
% ==== selection synchronized part (with associated OT file)===
%
for iChannel=1:Nchannels,
    if findstr(char(DarData.ChannelLabel(iChannel)),'OT_active'),
        OTactive=ANSIGNAL_DATA(:,iChannel);
        
        % check when OptoTrak acquisition was active 
        OTactiveIndices=find(OTactive>=1);
        
        if ~isempty(OTactiveIndices),
            Start=OTactiveIndices(1);
            Stop=Nsamples;
        else
            Start=1; % no SYNC info, take all the data
            Stop=Nsamples;   
        end
        if Stop>=Start,
            ANSIGNAL_DATA=ANSIGNAL_DATA(Start:Stop,:);
            % NB this selection does not affect ANSIGNAL_TIME_OFFSET
            % since this is ZERO per definition at start 
        end
        break % no need to look further
    end
end


for iChannel=1:Nchannels,
    if findstr(char(DarData.ChannelLabel(iChannel)),'longitudinal_timecode '),
       VITC=(DarData.WaveformData(iChannel,:)+DarData.ChannelBaseline(iChannel))';
       % NB. Baseline is not included in the signal but is subtracted from the signal
       % at acquisition time, so it is  ADDED here. 
    end
end

% ============================================================
% ==== define BODY.MUSCLE model ===
%

iMuscle=0;
for iChannel=1:Nchannels,
    if findstr(char(DarData.ChannelLabel(iChannel)),'EMG'),
        if findstr(char(DarData.ChannelAnatomicalLabelLong(iChannel)),'m'),
            
            MuscleName=char(DarData.ChannelAnatomicalLabelShort(iChannel));
            
            MuscleName=StandardizeMuscleName(MuscleName);
            
            
            BodySide=char(DarData.ChannelBodySide(iChannel));
            if findstr(BodySide,'R') |  findstr(BodySide,'r');
                MuscleNameAndSide=[num2str(MuscleName),'-R' ];
            elseif findstr(BodySide,'L') |  findstr(BodySide,'l');
                MuscleNameAndSide=[num2str(MuscleName),'-L' ];
            else
                MuscleNameAndSide=[num2str(MuscleName)];
            end
            
            iMuscle=iMuscle+1;
            CreateBodyMuscleNew(MuscleNameAndSide,iMuscle,iChannel);
            BODY.MUSCLE(iMuscle).LongName=char(DarData.ChannelAnatomicalLabelLong(iChannel));
            BODY.MUSCLE(iMuscle).Side=char(DarData.ChannelBodySide(iChannel));

        end
    end
end

BodyMechFuncFooter

return
% ============================================ 
% END ### BMLoadDARandDefineMuscles ###
