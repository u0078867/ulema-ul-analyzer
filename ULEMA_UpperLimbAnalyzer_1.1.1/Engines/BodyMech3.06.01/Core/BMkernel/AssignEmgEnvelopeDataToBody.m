%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function   AssignEmgEnvelopeDataToBody
% ASSIGNEMGENVELOPEDATATOBODY [ BodyMech 3.06.01 ]: Assigns measured data in the appropriate BODY fields
% INPUT
%   ForceThreshold (optional) in Newton
%   GLOBAL : ANSIGNAL_DATA
%            ANSIGNAL_TIME_GAIN
%            ANSIGNAL_TIME_OFFSET
%            BODY.MUSCLE(..).Emg.InputFileIndices 
% PROCESS
%   Reads the AnalogSignals into BODY.MUSCLE-fields
% OUTPUT
%   GLOBAL : BODY.MUSCLE(..).Emg.Envelope
%            BODY.MUSCLE(iMuscleIndex).Emg.EnvelopeTimeGain 
%            BODY.MUSCLE(iMuscleIndex).Emg.EnvelopeTimeOffset 

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
      BODY.MUSCLE(iMuscle).Emg.Envelope=ANSIGNAL_DATA(:,EmgChannel);
      BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeGain=ANSIGNAL_TIME_GAIN;
      BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeOffset=ANSIGNAL_TIME_OFFSET;
   end
end

BodyMechFuncFooter
return
% ============================================ 
% END ### AssignEmgEnvelopeDataToBody ###
