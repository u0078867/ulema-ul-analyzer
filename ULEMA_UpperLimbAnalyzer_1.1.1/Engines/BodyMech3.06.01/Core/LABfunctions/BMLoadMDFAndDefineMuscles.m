%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [datafile,datapath] = BMLoadMDFAndDefineMuscles(filename);
% BMLOADMDFANDDEFINEMUSCLES [ BodyMech 3.06.01 ]: loads SYBAR data files (*.MDF) from disk
% INPUT 
%   Optional: name of the file
%   Global: ANSIGNAL_DATA
%           ANSIGNAL_TIME_GAIN
%           ANSIGNAL_TIME _OFFSET
% PROCESS
%   Load the files and selects synchronized part
% OUTPUT
%   Global: BODY.MUSCLE

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0  Creation (Jaap Harlaar, VUmc, Amsterdam, April 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader
global IMPORT_MDF_DIR

if ~isempty(IMPORT_MDF_DIR),
    cd(IMPORT_MDF_DIR);
end

if nargin==1
   [datafile,datapath] = uigetfile(filename, 'open SYBAR file', 40, 40);
else
   [datafile,datapath] = uigetfile('*.mdf', 'open SYBAR file', 40, 40);
end

if datafile ~= 0
   fid=fopen([datapath,datafile]);
   [data,header]=readmdf(datafile,datapath);
   IMPORT_MDF_DIR=datapath;
else 
   return
end



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
    VITC=data(Start:Stop,1); 
    ANSIGNAL_DATA=data(Start:Stop,2:15);  
end

% ============================================================
% ==== user feedback===
%

firstVITC=VITC(1);  % global 
lastVITC=VITC(length(VITC));

[hour, minute, second, frame]=vitc2time(firstVITC);
firstVITCtxt=['first VITC : ',int2str(firstVITC),' = ', int2str(hour),':',...
      int2str(minute),':',int2str(second),':',int2str(frame),' (hh:mm:ss:ff)' ];

[hour, minute, second, frame]=vitc2time(lastVITC);
lastVITCtxt=['last VITC : ',int2str(lastVITC),' = ', int2str(hour),':',...
      int2str(minute),':',int2str(second),':',int2str(frame),' (hh:mm:ss:ff)' ];

header=str2mat(header,firstVITCtxt);
header=str2mat(header,lastVITCtxt);

h=msgbox(header,datafile);
uiwait(h)

% ============================================================


button = questdlg('Do you need a 17 uV correction ?','EMG Level adjustment','No');
if strcmp(button,'Yes')
    ANSIGNAL_DATA(:,1:8)=ANSIGNAL_DATA(:,1:8)+17.;  
end

% ============================================================
% ==== define BODY.MUSCLE model ===
%

nLinesHeader=size(header,1);

iMuscle=0;
iChannel=0;
for iLine=1:nLinesHeader,
    line=deblank(header(iLine,:));
    if ~isempty(findstr('EMG',line)),
        iChannel=iChannel+1;
        if isempty(findstr('nop',line))
            
            MdfMuscleName=line(10:length(line));
            Index=findstr(MdfMuscleName,'_');
            if ~isempty(Index),
                BodySide=MdfMuscleName(Index+1);
                MuscleName=MdfMuscleName(1:Index-1);
            else
                MuscleName=MdfMuscleName;
                BodySide='U'; % unknown
            end
            
            MuscleName=StandardizeMuscleName(MuscleName);
            
            if findstr(BodySide,'R') |  findstr(BodySide,'r');
                MuscleNameAndSide=[num2str(MuscleName),'-R' ];
            elseif findstr(BodySide,'L') |  findstr(BodySide,'l');
                MuscleNameAndSide=[num2str(MuscleName),'-L' ];
            else
                MuscleNameAndSide=[num2str(MuscleName)];
            end
            
            iMuscle=iMuscle+1;
            CreateBodyMuscleNew(MuscleNameAndSide,iMuscle,iChannel);
            BODY.MUSCLE(iMuscle).LongName=[];
            BODY.MUSCLE(iMuscle).Side=BodySide;

        end
    end
end

BodyMechFuncFooter

return
% ============================================ 
% END % ### BMLoadMdfAndDefineMuscles


function [hour, minute, second, frame]=vitc2time(vitcode,framerate);
% conversion of videoframe counter to HMSF time

if (nargin==1), framerate=25;end

hour=floor(vitcode/(60*60*framerate));
   minute=floor((vitcode-hour*(60*60*framerate))/(60*framerate));
   second=floor((vitcode-hour*(60*60*framerate)-minute*(60*framerate))/framerate);
   frame=vitcode-hour*(60*60*framerate)-minute*(60*framerate)-second*framerate;
   return
% ==============================
% END function vitc2time
% ==============================
%=========================================================================
% END ### BMLoadMDFAndDefineMuscles ###
