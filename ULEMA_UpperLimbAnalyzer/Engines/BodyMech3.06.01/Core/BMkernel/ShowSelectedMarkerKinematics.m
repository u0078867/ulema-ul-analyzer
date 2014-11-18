%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ShowSelectMarkerKinematics()
% SHOWSELECTEDMARKERKINEMATICS [ BodyMech 3.06.01 ]: user interactive selection of measured marker kinematics
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

pause
close(TimeSelectFigure);  % clear figure

return
% ============================================
% END ### ShowSelectedMarkerKinematics ###
