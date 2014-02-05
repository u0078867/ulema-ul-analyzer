%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ListBodyModel
% LISTBODYMODEL [ BodyMech 3.06.01 ]: lists the BodyMech BODY model to the screen
% INPUT
%   global: BODY
% PROCESS
%   lists all current active segments, joints and muscles on the screen
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, August 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

a=exist('BODY');
if a~=1, ListNoModel, return, end;
if ~isstruct(BODY), ListNoModel, return, end;

if isfield(BODY,'SEGMENT'),
    Nsegments=length(BODY.SEGMENT);
else
    Nsegments=0;
end
if isfield(BODY,'MUSCLE'),
    Nmuscles=length(BODY.MUSCLE);
else
    Nmuscles=0;
end
if isfield(BODY,'JOINT'),
    Njoints=length(BODY.JOINT);
else
    Njoints=0;
end

if Nsegments==0 & Njoints==0 & Nmuscles==0, ListNoModel, return, end;

% ============================================

h=findobj('Tag','BodyMechControlWindow');
if isempty('h'),
    disp('BODYMECH MODEL WINDOW IS OPENED FOR DISPLAY')
    BodyMechMainFigure
end

BodyModelList={'CURRENT BODYMECH BODY MODEL'};
BodyModelList=cat(2,BodyModelList,{' '});

if Nsegments~=0,
    for i=1:Nsegments,
        if ~isempty(BODY.SEGMENT(i).Name),

            %  MODEL STATUS
            % =============
            if ~isempty(BODY.SEGMENT(i).Cluster.MarkerCoordinates)...
                    & sum(sum(isnan(BODY.SEGMENT(i).Cluster.MarkerCoordinates)))==0,
                ClusterStatus=' C';
            else
                ClusterStatus=' c';
            end
            if ~isempty(BODY.SEGMENT(i).Cluster.PosturePose)...
                    & sum(sum(isnan(BODY.SEGMENT(i).Cluster.PosturePose)))== 0,
                ReferenceStatus='R';
            else
                ReferenceStatus='r';
            end
            if ~isempty(BODY.SEGMENT(i).AnatomicalLandmark)
                if ~isempty(BODY.SEGMENT(i).AnatomicalLandmark(1).ClusterFrameCoordinates),
                    AnatomicalStatus='A';
                else
                    AnatomicalStatus='a';
                end
            end
            ModelStatus=[ClusterStatus,ReferenceStatus,AnatomicalStatus];

            %  KINEMATICS STATUS
            % ==================
            if ~isempty(BODY.SEGMENT(i).Cluster.KinematicsMarkers),
                MarkerKinematicsStatus= ' M';
            else
                MarkerKinematicsStatus= ' m';
            end

            if ~isempty(BODY.SEGMENT(i).Cluster.KinematicsPose),
                ClusterKinematicsStatus= 'C';
            else
                ClusterKinematicsStatus= 'c';
            end
            if ~isempty(BODY.SEGMENT(i).Cluster.PostureRefKinematicsPose),
                PostureRefKinematicsStatus= 'P';
            else
                PostureRefKinematicsStatus= 'p';
            end
            if ~isempty(BODY.SEGMENT(i).AnatomicalFrame.KinematicsPose),
                AnatomicalKinematicsStatus= 'A';
            else
                AnatomicalKinematicsStatus= 'a';
            end
            KinematicsStatus=[MarkerKinematicsStatus,...
                ClusterKinematicsStatus,...
                PostureRefKinematicsStatus,...
                AnatomicalKinematicsStatus];

            %  VIZUALISATION STATUS
            % =====================
            if ~isempty(BODY.SEGMENT(i).AnatomicalLandmark),
                if ~isempty(BODY.SEGMENT(i).AnatomicalLandmark(1).Kinematics),
                    AnatomVizKinematicsStatus= ' A';
                else
                    AnatomVizKinematicsStatus= ' a';
                end
            end
            if ~isempty(BODY.SEGMENT(i).StickFigure(1).Kinematics),
                StickVizKinematicsStatus= 'S';
            else
                StickVizKinematicsStatus= 's';
            end
            VizStatus=[AnatomVizKinematicsStatus,StickVizKinematicsStatus];

            BodyModelList=cat(2,BodyModelList,...
                {[...
                'S',num2str(i),' = ',char(BODY.SEGMENT(i).Name),...
                '    m#: ',num2str(BODY.SEGMENT(i).Cluster.MarkerInputFileIndices),...
                ' |||||  M=',ModelStatus,...
                '  K=',KinematicsStatus,...
                '  V=',VizStatus,...
                ]});

        end
    end
end
BodyModelList=cat(2,BodyModelList,{'--'});

if Njoints~=0
    for i=1:Njoints,
        if ~isempty(BODY.JOINT(i).Name),
            BodyModelList=cat(2,BodyModelList,...
                {['J',num2str(i),' = ',char(BODY.JOINT(i).Name)]});
        end
    end
end

BodyModelList=cat(2,BodyModelList,{'--'});

if Nmuscles~=0
    for i=1:Nmuscles,
        if ~isempty(BODY.MUSCLE(i).Name),
            BodyModelList=cat(2,BodyModelList,...
                {['M',num2str(i),' = ',char(BODY.MUSCLE(i).Name),...
                ]});
        end
    end
end
BodyModelList=cat(2,BodyModelList,{''});
BodyModelList=cat(2,BodyModelList,{'-----------------------------------------','||||| BODY.HEADER info |||||'});

BodyHeaderInfo=ListBodyHeader;
for i=1:size(BodyHeaderInfo,1),
    BodyModelList=cat(2,BodyModelList,BodyHeaderInfo(i));
end

h2=findobj('Tag','BodyMechModelInfoWindow');
set(h2,'string',BodyModelList);
set(h2,'BackgroundColor',[1 1 1]);

% NB NB NB NB NB NB NB
% BodyMechFuncFooter is NOT called here, to prevent infinite looping
return

% ============================================
function ListNoModel

h=findobj('Tag','BodyMechControlWindow');
if  isempty('h'),
    disp('NO BODY MODEL ACTIVE')
else
    h2=findobj('Tag','BodyMechModelInfoWindow');
    set(h2,'string','NO BODY MODEL ACTIVE');
    set(h2,'BackgroundColor',[1 1 1]);
end
return
% ============================================
% END ### ListBodyModel ###
