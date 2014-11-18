%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CreateBodyMuscle(MuscleName,MuscleIndex,EmgChannel, SegmentLinks)
% CREATEBODYMUSCLE [ BodyMech 3.06.01 ]: declares a new bodymuscle to BODY.MUSCLE
% INPUT
%   MuscleName  : name of the muscle
%   MuscleIndex : number of channel EMG signal
%   EmgChannel  : number of the column in which the EMGdata can be retrieved 
%				  from the original datafile (e.g. MDF format)
%   SegmentLinks: [segment of Origin (prox); segment of insertion (dist)]
% PROCESS
%   Generation of variable that represent a muscle of the human body
% OUTPUT
%   GLOBAL: BODY.MUSCLE: next cell in the array of muscle names

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, August 1999) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

if nargin < 4
   errordlg({'CREATE_BODYMUSCLE';' ';...
      'wrong input format';...
      ' define name,index,EMGchannel and OIsegments';...
      },...
      '** BODYMECH ERROR') 
   return
end

if size(SegmentLinks)~=[1 2],
   errordlg({'CREATE_BODYMUSCLE';' ';...
      'wrong input format';...
      ' define two linked segments';...
      },...
      '** BODYMECH ERROR') 
   return
end


n_muscles=length(BODY.MUSCLE);


% check if the name already exists
if n_muscles~=0
   for i=1:n_muscles
      if strcmpi(BODY.MUSCLE(i).Name,MuscleName)
         errordlg({'CREATE_BODYMUSCLE';' ';...
               'muscle names must be (case insensitive) unique ';...
               ['duplicate muscle name: ', char(MuscleName)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end
end

MuscleIndex=fix(MuscleIndex); 
   if n_muscles~=0 & MuscleIndex <= n_muscles
      if ~isempty(BODY.MUSCLE(MuscleIndex).Name)
         errordlg({'CREATE_BODYMUSCLE';' ';...
               'muscle index already exists';... 
               ['duplicate muscle index: ', int2str(MuscleIndex)];...
            },...
            '** BODYMECH ERROR') 
         return
      end
   end



% create a new bodymuscle 

% identification 
BODY.MUSCLE(MuscleIndex).Name=MuscleName;
BODY.MUSCLE(MuscleIndex).Segments=SegmentLinks;
BODY.MUSCLE(MuscleIndex).Emg.InputFileIndices=EmgChannel;

% dynamics
BODY.MUSCLE(MuscleIndex).Emg.Signal=[];
BODY.MUSCLE(MuscleIndex).Emg.TimeGain=[]; 
BODY.MUSCLE(MuscleIndex).Emg.TimeOffset=[];
BODY.MUSCLE(MuscleIndex).Emg.Envelope=[];
BODY.MUSCLE(MuscleIndex).Emg.EnvelopeTimeGain=[]; 
BODY.MUSCLE(MuscleIndex).Emg.EnvelopeTimeOffset=[];
BODY.MUSCLE(MuscleIndex).Emg.EnvelopeProcessingFilter=[]; % [netorder direction type netfreq]

% ============================================

BodyMechFuncFooter
return
% ============================================ 
% END ### CreateBodyMuscle ###
