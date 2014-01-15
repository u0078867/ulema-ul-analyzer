%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function SelectMarkerKinematics()
% SELECTMARKERKINEMATICS [ BodyMech 3.06.01 ]: user interactive selection of measured marker kinematics
% INPUT
%   Global: BODY.SEGMENT(i).Cluster.KinematicsMarkers
% PROCESS
%   User selects either time-instance or time-interval
% OUTPUT
%   Global: BODY.SEGMENT(iSegment).Cluster.KinematicsPose

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, July 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

% display marker's visability
TimeSelectFigure=figure;
set(TimeSelectFigure,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');
Nsegments=length(BODY.SEGMENT);
Nextforces=length(BODY.CONTEXT.ExternalForce);
Nplots=(Nsegments+Nextforces);
CurrentAxis=[];

% plot all subplots
if Nsegments~=0,
    NmarkerFrames=size(BODY.SEGMENT(1).Cluster.RecordedMarkers,2);
    for iSegment=1:Nsegments,    % for all bodysegments

        subplot(Nplots,1,iSegment);

        TimeGain=BODY.SEGMENT(iSegment).Cluster.TimeGain;
        TimeOffset=BODY.SEGMENT(iSegment).Cluster.TimeOffset; %
        TimeBase=[TimeOffset:TimeGain:TimeOffset+(NmarkerFrames-1)*TimeGain];

        plot(TimeBase,sum(~isnan(BODY.SEGMENT(iSegment).Cluster.AvailableMarkers),1),'r');
        hold on

        plot(TimeBase,sum(~isnan(BODY.SEGMENT(iSegment).Cluster.RecordedMarkers),1),'b');

        title(BODY.SEGMENT(iSegment).Name);
        CurrentAxis=axis;
        axis([CurrentAxis(1) CurrentAxis(2) 0 6]);
    end
end

if Nextforces~=0,
    subplot(Nplots,1,Nsegments+1);
    for i=1:Nextforces,
        if ~isempty(BODY.CONTEXT.ExternalForce(i).Signals),
            Nsamples=length(BODY.CONTEXT.ExternalForce(i).Signals);
            TimeGain=BODY.CONTEXT.ExternalForce(i).TimeGain;
            TimeOffset=BODY.CONTEXT.ExternalForce(i).TimeOffset; %

            TimeBase=[TimeOffset:TimeGain:TimeOffset+(Nsamples-1)*TimeGain];

            plot(TimeBase,BODY.CONTEXT.ExternalForce(i).Signals(Y,:),'r','LineWidth',2), grid
        end
    end
    title('GRFy');
    ExtForceAxis=axis;
    axis([CurrentAxis(1) CurrentAxis(2) 0 ExtForceAxis(4)]);
end

[x,y]=ginput(2);
StartTime=x(1);StopTime=x(2);
if StartTime>StopTime,
    temp=StartTime;StartTime=StopTime;StopTime=temp;
end
TimeSelected=abs(StartTime-StopTime);
BttnText={[num2str(TimeSelected),' sec. selected, continue?'];...
    '>> this will erase all derived kinematics, if any..'};
button = questdlg(BttnText,...
    'Time interval selection','Yes','No','esc','Yes');
if strcmp(button,'No')
    close(TimeSelectFigure);return
elseif strcmp(button,'esc')
    close(TimeSelectFigure);return
end

% PROCESS
for iSegment=1:length(BODY.SEGMENT),
    if ~isempty( BODY.SEGMENT(iSegment).Name),
        TimeGain=BODY.SEGMENT(iSegment).Cluster.TimeGain;
        TimeOffset=BODY.SEGMENT(iSegment).Cluster.TimeOffset;

        StartIndex=ceil((StartTime-TimeOffset)/TimeGain);
        StopIndex=floor((StopTime-TimeOffset)/TimeGain);
        BODY.SEGMENT(iSegment).Cluster.TimeOffset=TimeOffset+StartIndex*TimeGain; % new offset

        BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers=...
            BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(:,:,StartIndex:StopIndex);
        BODY.SEGMENT(iSegment).Cluster.AvailableMarkers=...
            BODY.SEGMENT(iSegment).Cluster.AvailableMarkers(:,StartIndex:StopIndex);
        BODY.SEGMENT(iSegment).Cluster.RecordedMarkers=...
            BODY.SEGMENT(iSegment).Cluster.RecordedMarkers(:,StartIndex:StopIndex);

        if ~isempty(BODY.SEGMENT(iSegment).Cluster.KinematicsPose),
            BODY.SEGMENT(iSegment).Cluster.KinematicsPose=...
                BODY.SEGMENT(iSegment).Cluster.KinematicsPose(:,:,StartIndex:StopIndex);
        end

        % clear derived kinematics

        BODY.SEGMENT(iSegment).Cluster.PostureRefKinematicsPose=zeros(4,4,0);
        nLandmarks=length(BODY.SEGMENT(iSegment).AnatomicalLandmark);
        for iLandmark=1:nLandmarks,
            BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).Kinematics=zeros(3,0,0);
        end

        nStickmarkers2=length(BODY.SEGMENT(iSegment).StickFigure);
        for iStickmarker=1:nStickmarkers2,
            BODY.SEGMENT(iSegment).StickFigure(iStickmarker).Kinematics=zeros(3,0,0);
        end

        %%%  BODY.SEGMENT(iSegment).StickFigure.Kinematics=zeros(3,0,0);
        BODY.SEGMENT(iSegment).AnatomicalFrame.KinematicsPose=zeros(4,4,0);
    end
end

if ~isempty(BODY.CONTEXT.ExternalForce),
    nForceSensors=size(BODY.CONTEXT.ExternalForce,2);  % # of Forcelates used
    for ForceIndex=1:nForceSensors,
        if ~isempty(BODY.CONTEXT.ExternalForce(ForceIndex).Signals),
            TimeGain=BODY.CONTEXT.ExternalForce(ForceIndex).TimeGain;
            TimeOffset=BODY.CONTEXT.ExternalForce(ForceIndex).TimeOffset;

            StartIndex=ceil((StartTime-TimeOffset)/TimeGain);
            StopIndex=floor((StopTime-TimeOffset)/TimeGain);
            BODY.CONTEXT.ExternalForce(ForceIndex).TimeOffset=...
                TimeOffset+StartIndex*TimeGain; % new offset

            StopIndex2=min(StopIndex,size(BODY.CONTEXT.ExternalForce(ForceIndex).Signals,2));
            BODY.CONTEXT.ExternalForce(ForceIndex).Signals=...
                BODY.CONTEXT.ExternalForce(ForceIndex).Signals(:,StartIndex:StopIndex2);
            BODY.CONTEXT.ExternalForce(ForceIndex).MeasuredSignals=...
                BODY.CONTEXT.ExternalForce(ForceIndex).MeasuredSignals(:,StartIndex:StopIndex2);

            if StopIndex > StopIndex2,
                BODY.CONTEXT.ExternalForce(ForceIndex).Signals(:,StopIndex2+1:StopIndex)=NaN;
                BODY.CONTEXT.ExternalForce(ForceIndex).MeasuredSignals(:,StopIndex2+1:StopIndex)=NaN;
            end
        end
    end
end

if ~isempty(BODY.MUSCLE),
    Nmuscles=length(BODY.MUSCLE);
    for iMuscle=1:Nmuscles,
        if ~isempty(BODY.MUSCLE(iMuscle).Name),
            if ~isempty(BODY.MUSCLE(iMuscle).Emg.Envelope),

                TimeGain=BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeGain;
                TimeOffset=BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeOffset;

                StartIndex=ceil((StartTime-TimeOffset)/TimeGain);
                StopIndex=floor((StopTime-TimeOffset)/TimeGain);
                BODY.MUSCLE(iMuscle).Emg.EnvelopeTimeOffset=...
                    TimeOffset+StartIndex*TimeGain; % new offset

                StopIndex2=min(StopIndex,length(BODY.MUSCLE(iMuscle).Emg.Envelope));
                BODY.MUSCLE(iMuscle).Emg.Envelope=...
                    BODY.MUSCLE(iMuscle).Emg.Envelope(StartIndex:StopIndex2);

                if StopIndex > StopIndex2,
                    BODY.MUSCLE(iMuscle).Emg.Envelope(StopIndex2+1:StopIndex)=NaN;
                end
            end

            if ~isempty(BODY.MUSCLE(iMuscle).Emg.Signal),

                TimeGain=BODY.MUSCLE(iMuscle).Emg.TimeGain;
                TimeOffset=BODY.MUSCLE(iMuscle).Emg.TimeOffset;

                StartIndex=ceil((StartTime-TimeOffset)/TimeGain);
                StopIndex=floor((StopTime-TimeOffset)/TimeGain);
                BODY.MUSCLE(iMuscle).Emg.TimeOffset=...
                    TimeOffset+StartIndex*TimeGain; % new offset

                StopIndex2=min(StopIndex,length(BODY.MUSCLE(iMuscle).Emg.Signal));
                BODY.MUSCLE(iMuscle).Emg.Signal=...
                    BODY.MUSCLE(iMuscle).Emg.Signal(StartIndex:StopIndex2);

                if StopIndex > StopIndex2,
                    BODY.MUSCLE(iMuscle).Emg.Signal(StopIndex2+1:StopIndex)=NaN;
                end
            end
        end
    end
end

close(TimeSelectFigure);  % clear figure

return
% ============================================
% END ### SelectMarkerKinematics ###
