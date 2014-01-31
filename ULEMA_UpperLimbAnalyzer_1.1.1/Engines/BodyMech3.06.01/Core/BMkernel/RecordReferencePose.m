%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function RecordReferencePose(ReferencePoseNo)
% RECORDREFERENCEPOSE [ BodyMech 3.06.01 ]: interactive selection from recoderded marker kinematics
% INPUT
%   Global: BODY.SEGMENT(iSegment).Cluster-fields
% PROCESS
%   Interactive selection from recoderded marker kinematics
% OUTPUT
%   Global: BODY.SEGMENT(iSegment).Cluster.PosturePose

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

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
if nargin==0,
    ReferencePoseNo=1;
end

for iSegment=1:length(BODY.SEGMENT), % for each segment
    if ~isempty( BODY.SEGMENT(iSegment).Name), % that really exists

        NmarkersCluster=size(BODY.SEGMENT(iSegment).Cluster.MarkerCoordinates,2);

        % pose of segment clustermarkers in this reference  position
        ReferencePosition=BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(:,:,PostureFrameIndex); % in the LabRefFrame
        ValidClusterMarkers= ~isnan(ReferencePosition(X,:));      % X-coordinate represents 3 dimensions

        if  sum(ValidClusterMarkers)>=3,
            % find and copy the valid markers from the cluster at PostureFrameIndex
            j=1;
            LocalClusterMarkerCoordinates=zeros(0,0);
            GlobalClusterMarkerCoordinates=zeros(0,0);
            for i=1:NmarkersCluster
                if ~isnan(ReferencePosition(X,i)),
                    LocalClusterMarkerCoordinates(:,j)=BODY.SEGMENT(iSegment).Cluster.MarkerCoordinates(:,i);
                    GlobalClusterMarkerCoordinates(:,j)=ReferencePosition(:,i);
                    j=j+1;
                end
            end
            % pose of segment clustermarkers in this reference  position
            [R,t]= RigidBodyTransformation(LocalClusterMarkerCoordinates,GlobalClusterMarkerCoordinates);
            BODY.SEGMENT(iSegment).Cluster.PosturePose(:,:,ReferencePoseNo)=[R,t;0 0 0 1];
        end
    end
end

return

% =================================================================
% END ### RecordReferencePose ###
