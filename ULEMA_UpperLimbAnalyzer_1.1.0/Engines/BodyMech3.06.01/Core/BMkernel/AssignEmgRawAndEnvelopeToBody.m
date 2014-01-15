%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function   AssignEmgRawAndEnvelopeToBody
% ASSIGNEMGRAWANDENVELOPETOBODY [ BodyMech 3.06.01 ]: assigns measured data in the BODY.MUSCLE-fields
% INPUT   
%   ForceThreshold (optional) in Newton
%   GLOBAL : ANSIGNAL_DATA
%            ANSIGNAL_TIME_GAIN
%            ANSIGNAL_TIME_OFFSET
%            BODY.MUSCLE(..).Emg.InputFileIndices 
% PROCESS
%   Reads the AnalogSignals into BODY.MUSCLE-fields
% OUTPUT  
%   GLOBAL : BODY.MUSCLE(..).Emg.Signal
%            BODY.MUSCLE(iMuscleIndex).Emg.TimeGain 
%            BODY.MUSCLE(iMuscleIndex).Emg.TimeOffset 

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

Nmuscles=length(BODY.MUSCLE);

for iMuscle=1:Nmuscles,   
   if ~isempty(BODY.MUSCLE(iMuscle).Name),
      EmgChannel=BODY.MUSCLE(iMuscle).Emg.InputFileIndices;
   
      BODY.MUSCLE(iMuscle).Emg.Signal = ANSIGNAL_DATA(:,EmgChannel);
      BODY.MUSCLE(iMuscle).Emg.TimeGain = ANSIGNAL_TIME_GAIN;         
      BODY.MUSCLE(iMuscle).Emg.TimeOffset = ANSIGNAL_TIME_OFFSET;          
	  % nicknames to prepare for envelopes
	  Sfreq=1./BODY.MUSCLE(iMuscle).Emg.TimeGain;
	  EMGdata=BODY.MUSCLE(iMuscle).Emg.Signal;
      EMGdata=EMGdata-mean(EMGdata);
	  % high pass filter to remove artefacts (3rd order at 20 Hz)
	  SEMGdata=removeartefact(EMGdata,Sfreq,20); % SampleFreq=1000; Cut-offFreq=20
     % rectify  
  	  SREMGdata=abs(SEMGdata);
      % smoothed EMG one way at 2 Hz
   	  SSREMGdata=smooth(SREMGdata,Sfreq,2,0); % 
	  BODY.MUSCLE(iMuscle).Emg.Envelope=SSREMGdata;
	  BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeGain=ANSIGNAL_TIME_GAIN; 
	  BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeOffset=ANSIGNAL_TIME_OFFSET;
	  BODY.MUSCLE(iMuscle).Emg.EnvelopeProcessingFilter=[2 0 1 2]; % [netorder direction type netfreq]

	  clear EMGdata SEMGdata SREMGdata SSREMGdata
	  
  end
end

BodyMechFuncFooter
return
% ============================================ 
% END ### AssignEmgDataToBody ###
