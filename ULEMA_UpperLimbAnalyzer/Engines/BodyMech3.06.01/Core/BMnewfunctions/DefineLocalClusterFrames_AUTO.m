%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function PostureFrameIndex = DefineLocalClusterFrames_AUTO(mode)
% DEFINELOCALCLUSTERFRAMES [ BodyMech 3.06.01 ]: Defines an adhoc cluster frame for each segment
% INPUT
%   mode : either 'static' or 'automatic'
% PROCESS
%   'static' uses LocalReferenceFrame for each BODY.SEGFMENT
%   applies the first frame of ClusterKinematics
%   'automatic' automatically finds for the the first frame in which all
%   markers are visible
% OUTPUT
%   GLOBAL:  BODY.SEGMENT(i).Cluster.MarkerCoordinates
%            BODY.SEGMENT(i).Cluster.PosturePose

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, 1998)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

if nargin <  1,
    mode='static';
end

if strcmp(mode,'static')

    % display marker's visability
    TimeSelectFigure=figure;
    set(TimeSelectFigure,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');
    Nsegments=length(BODY.SEGMENT);
    Nplots=Nsegments;
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

    % select a time instance
    [x,y]=ginput(1);

    Index=ceil((x(1)-TimeOffset)/TimeGain);

    PostureFrameIndex=max(1,Index);

    close(TimeSelectFigure)

    % PROCESS
    ReferencePoseNo=1;

    for i=1:length(BODY.SEGMENT), % for each segment
        if ~isempty( BODY.SEGMENT(i).Name), % that really exists

            StaticPositionClusterMarkers=BODY.SEGMENT(i).Cluster.KinematicsMarkers(:,:,PostureFrameIndex); % in the LabRefFrame
            ValidClusterMarkers= ~isnan(StaticPositionClusterMarkers(X,:));
            % X-coordinate represents 3 dimensions

            if sum(ValidClusterMarkers)==size(ValidClusterMarkers,2) & ... % all (selected) markers are valid in the selected frame
                    sum(ValidClusterMarkers)>=3,

                [BODY.SEGMENT(i).Cluster.MarkerCoordinates...                         % (eq.3 crfMi = /grfMi*grfEx grfMi*Ey grfMi*Ez\)
                    ,BODY.SEGMENT(i).Cluster.PosturePose(:,:,ReferencePoseNo)]...       % (eq.6 zie pag.15 tekst)
                    =LocalReferenceFrame(StaticPositionClusterMarkers);
            else
                warntxt={['Segment no. ',int2str(i),' :  ',BODY.SEGMENT(i).Name],...
                    ['is not succesfully referenced']};
                warndlg(warntxt,'BODYMECH warning');
                BODY.SEGMENT(i).Cluster.MarkerCoordinates=zeros(0,0);
                BODY.SEGMENT(i).Cluster.PosturePose=zeros(4,4,0);
            end
        end
    end

elseif strcmp(mode,'automatic')
    
    Nsegments=length(BODY.SEGMENT);
    % analyse the max number of markers
    if Nsegments~=0,
        AllAvailableMarkers = zeros(1,size(BODY.SEGMENT(1).Cluster.AvailableMarkers,2));
        for iSegment=1:Nsegments,    % for all bodysegments

            TimeGain=BODY.SEGMENT(iSegment).Cluster.TimeGain;
            TimeOffset=BODY.SEGMENT(iSegment).Cluster.TimeOffset; %

            AllAvailableMarkers = AllAvailableMarkers + sum(~isnan(BODY.SEGMENT(iSegment).Cluster.AvailableMarkers),1);

        end
    end
    x = find(AllAvailableMarkers == max(AllAvailableMarkers),1,'first')*TimeGain;

    Index=ceil((x-TimeOffset)/TimeGain);

    PostureFrameIndex=max(1,Index);


    % PROCESS
    ReferencePoseNo=1;

    for i=1:length(BODY.SEGMENT), % for each segment
        if ~isempty( BODY.SEGMENT(i).Name), % that really exists

            StaticPositionClusterMarkers=BODY.SEGMENT(i).Cluster.KinematicsMarkers(:,:,PostureFrameIndex); % in the LabRefFrame
            ValidClusterMarkers= ~isnan(StaticPositionClusterMarkers(X,:));
            % X-coordinate represents 3 dimensions

            if sum(ValidClusterMarkers)==size(ValidClusterMarkers,2) & ... % all (selected) markers are valid in the selected frame
                    sum(ValidClusterMarkers)>=3,

                [BODY.SEGMENT(i).Cluster.MarkerCoordinates...                         % (eq.3 crfMi = /grfMi*grfEx grfMi*Ey grfMi*Ez\)
                    ,BODY.SEGMENT(i).Cluster.PosturePose(:,:,ReferencePoseNo)]...       % (eq.6 zie pag.15 tekst)
                    =LocalReferenceFrame(StaticPositionClusterMarkers);
            else
                warntxt={['Segment no. ',int2str(i),' :  ',BODY.SEGMENT(i).Name],...
                    ['is not succesfully referenced']};
                warndlg(warntxt,'BODYMECH warning');
                BODY.SEGMENT(i).Cluster.MarkerCoordinates=zeros(0,0);
                BODY.SEGMENT(i).Cluster.PosturePose=zeros(4,4,0);
            end
        end
    end
    
elseif strcmp(mode,'dynamic')
    warntxt={['Segment no. ',int2str(i),' :  ',BODY.SEGMENT(i).Name],...
        ['is not succesfully referenced'],...
        [' >> Dynamic calibration is not implemented yet']};
    warndlg(warntxt,'*** BODYMECH warning');
else
    warntxt={['Segment no. ',int2str(i),' :  ',BODY.SEGMENT(i).Name],...
        ['is not succesfully referenced']};
    warndlg(warntxt,'*** BODYMECH warning');
end

BodyMechFuncFooter
return
% ====================================
% END ### DefineLocalClusterFrames ###
