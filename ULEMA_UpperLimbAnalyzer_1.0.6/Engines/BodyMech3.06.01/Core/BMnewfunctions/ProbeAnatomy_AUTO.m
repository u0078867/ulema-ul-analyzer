%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function calib = ProbeAnatomy_AUTO(inputData, prefix)
% PROBEANATOMY [ BodyMech 3.06.01 ]: Calculates coordinates of bony landmarks in CRF
% INPUT
%   Global: BODY.SEGMENT.Cluster-fields
%   inputData: this variable can be:
%       string: indicates the full path from which to load the c3d files;
%               in this case, "prefix" will be used
%       struct: structure array containing the following fields:
%               - name: string indicating the name of the calibration file
%               - data: structure containing marker data
%   prefix: the prefix string that every probe file must have (e.g 'cal'),
%           in case of the data is loaded from file.
%
% PROCESS
%   Calculates coordinates of bony landmarks in cluster frame coordinates
%   and a transformation matrix of the global to the local (cluster) frame.
% OUTPUT
%   calib:  see datapathOrMarkerdata (struct)
%   Global: BODY.SEGMENT(iSegment).AnatomicalLandmark.ClusterFrameCoordinates
%           BODY.SEGMENT(iSegment).AnatomicalLandmark.ProbingPose
%           BODY.CONTEXT.Stylus.TipPosition

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% ======================================================
% probing the anatomical marks
% ======================================================
BodyMechFuncHeader
global BACKUP  % temporarily stores fields that are used in the probing procedures
% which might contain information to survive the probing procedure

for iSegment=1:length(BODY.SEGMENT),
    BACKUP(iSegment).Cluster.KinematicsPose=BODY.SEGMENT(iSegment).Cluster.KinematicsPose;
    BACKUP(iSegment).Cluster.PostureRefKinematicsPose=BODY.SEGMENT(iSegment).Cluster.PostureRefKinematicsPose;
    BACKUP(iSegment).Cluster.KinematicsMarkers=BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers;
    BACKUP(iSegment).Cluster.RecordedMarkers=BODY.SEGMENT(iSegment).Cluster.RecordedMarkers;
    BACKUP(iSegment).Cluster.AvailableMarkers=BODY.SEGMENT(iSegment).Cluster.AvailableMarkers;
    BACKUP(iSegment).Cluster.TimeGain=BODY.SEGMENT(iSegment).Cluster.TimeGain;
    BACKUP(iSegment).Cluster.TimeOffset=BODY.SEGMENT(iSegment).Cluster.TimeOffset;
    %[TimeGain TimeOffset];
end

calib = struct([]); % output initialization
for iSegment=1:length(BODY.SEGMENT),                              % for all BODY segments

    nLandmarks=length(BODY.SEGMENT(iSegment).AnatomicalLandmark);

    for iLandmark=1:nLandmarks % each probing position
        if ~isempty(BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).Name),

            name = BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).Name;

            BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).ProbingPose=[];             % clear all previous anatomical calibrations
            datafile = [prefix, BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).Name,'.c3d'];

            if ischar(inputData)
                datapath = inputData;
                [datafile,ParameterGroup,CollDate,CollTime]=BMimportULC3D_3_AUTO(datafile,datapath);
            else
                ind = strcmp({inputData.name}, name);
                if sum(ind) == 0
                    error(sprintf('BODYMECH:ProbeAnatomy_AUTO:Landmark %s; MissingDataError',name),'Data not found');
                end
                MarkerData = inputData(ind).data;
                MARKER_DATA = getMarkersDataFromStruct(MarkerData,BODY.CONTEXT.MarkerLabels);
                MARKER_TIME_OFFSET = 0.;
                MARKER_TIME_GAIN = []; % unused
                datafile = 1;   % to enter in the following if
            end

            if datafile ~= 0
                % [n_coordinates,n_markers,n_samples]=size(MARKER_DATA);
                AssignMarkerDataToBody;
                Nsamples=size(BODY.SEGMENT(iSegment).Cluster.RecordedMarkers,2);
                NmarkersCluster=size(BODY.SEGMENT(iSegment).Cluster.MarkerCoordinates,2);

                AssignMarkerDataToStylus;
                NmarkersProbe=size(BODY.CONTEXT.Stylus.KinematicsMarkers,2);


                for iSample=1:Nsamples, % fill ListNmarkers=[iSample,NclusterMarkers,NprobeMarkers]
                    if iSample==1,
                        ListNmarkers=[sum(~isnan(BODY.SEGMENT(iSegment).Cluster.RecordedMarkers(:,iSample))),...
                            sum(~isnan(BODY.CONTEXT.Stylus.KinematicsMarkers(1,:,iSample)))];
                    else
                        ListNmarkers=cat(1,ListNmarkers,...
                            [sum(~isnan(BODY.SEGMENT(iSegment).Cluster.RecordedMarkers(:,iSample))),...
                            sum(~isnan(BODY.CONTEXT.Stylus.KinematicsMarkers(1,:,iSample)))]);
                    end
                end
                ind01=find(ListNmarkers(:,1)>=3 & ListNmarkers(:,2)>=3);
                if ~isempty(ind01),

                    % find the iSample with the most (total number of) markers visible
                    ListNmarkers(:,3)=ListNmarkers(:,1)+ListNmarkers(:,2);
                    MaxListmarkers=max(ListNmarkers(ind01,3));
                    ind02=find(ListNmarkers(ind01,3)==MaxListmarkers);

                    iSample=ind01(ind02(1)); % this must the (first) iSample with the most markers visible

                    % find and copy the valid markers from the cluster at iSample
                    j=1;
                    LocalClusterMarkerCoordinates=zeros(0,0);
                    GlobalClusterMarkerCoordinates=zeros(0,0);
                    for i=1:NmarkersCluster
                        if ~isnan(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,i,iSample)),
                            LocalClusterMarkerCoordinates(:,j)=BODY.SEGMENT(iSegment).Cluster.MarkerCoordinates(:,i);
                            GlobalClusterMarkerCoordinates(:,j)=BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(:,i,iSample);
                            j=j+1;
                        end
                    end
                    % pose of segment clustermarkers in this reference  position
                    [R,t]= RigidBodyTransformation(LocalClusterMarkerCoordinates,GlobalClusterMarkerCoordinates);
                    BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).ProbingPose=[R,t;0 0 0 1];

                    % StylusTipCalculation
                    ProbeTipGrf=feval(BODY.CONTEXT.Stylus.ToTipFunction, ...
                        BODY.CONTEXT.Stylus.KinematicsMarkers(:,:,iSample),BODY.CONTEXT.Stylus.StylusGeometryParams); % time-averaged value

                    BODY.CONTEXT.Stylus.TipPosition=ProbeTipGrf;

                    % SHOWTIP
                    % tip-coordinates in target cluster frame
                    grf2crf=inv(BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).ProbingPose(:,:));
                    if size(ProbeTipGrf,1)==4,
                        AnatomicalLandmark=grf2crf*ProbeTipGrf; % (eq.12)
                    else
                        AnatomicalLandmark=grf2crf*[ProbeTipGrf;1]; % make homogeneous coordinates
                    end
                    BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).ClusterFrameCoordinates=AnatomicalLandmark(1:3);

                    % Update output
                    calib(end+1).name = name;
                    calib(end).data = AggregateAllPoints(struct(),'PointerMarkers');
                    calib(end).data = AggregateAllPoints(calib(end).data,'TechnicalMarkers');
                    calib(end).clusterFrameCoordinates = AnatomicalLandmark(1:3);
                else
                    h=errordlg({'ProbeAnatomy';...
                        'too many occluded markers during probing'},...
                        '** BODYMECH ERROR **');
                    waitforbuttonpress;
                    close(h)

                    BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).ProbingPose=NaN*ones(4);
                    BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).ClusterFrameCoordinates=[NaN NaN NaN]';
                end

            else

                BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).ProbingPose=NaN*ones(4);
                BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).ClusterFrameCoordinates=[NaN NaN NaN]';
                
            end
                    
        end
    end
end

% RESTORE BACKUP.fields into BODY
for iSegment=1:length(BODY.SEGMENT),
    BODY.SEGMENT(iSegment).Cluster.KinematicsPose=BACKUP(iSegment).Cluster.KinematicsPose;
    BODY.SEGMENT(iSegment).Cluster.PostureRefKinematicsPose=BACKUP(iSegment).Cluster.PostureRefKinematicsPose;
    BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers=BACKUP(iSegment).Cluster.KinematicsMarkers;
    BODY.SEGMENT(iSegment).Cluster.RecordedMarkers=BACKUP(iSegment).Cluster.RecordedMarkers;
    BODY.SEGMENT(iSegment).Cluster.AvailableMarkers=BACKUP(iSegment).Cluster.AvailableMarkers;
    BODY.SEGMENT(iSegment).Cluster.TimeGain=BACKUP(iSegment).Cluster.TimeGain;
    BODY.SEGMENT(iSegment).Cluster.TimeOffset=BACKUP(iSegment).Cluster.TimeOffset;
    BODY.SEGMENT(iSegment).Cluster.TimeGain=BACKUP(iSegment).Cluster.TimeGain;
    BODY.SEGMENT(iSegment).Cluster.TimeOffset=BACKUP(iSegment).Cluster.TimeOffset;
end
clear global BACKUP

return
% ============================================
% END ### ProbeAnatomy ###
