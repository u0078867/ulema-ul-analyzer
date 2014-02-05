%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function UpdateVizOrthoMode
% UPDATEVIZORTHOMODE [ BodyMech 3.06.01 ]: Updates orthogonal visualization modes
% INPUT
%    Input :none
% PROCESS 
%   Updates orthogonal visualization modes
% OUTPUT
%   GLOBAL VIZ.ORTHOMODE

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader

% h=findobj('Tag','Ortho display');

h=findobj('Tag','ClusterMarkerCheck');
VIZ.ORTHOMODE(1)=get(h, 'Value');

h=findobj('Tag','SegmentFrameCheck');
VIZ.ORTHOMODE(2)=get(h, 'Value');

h=findobj('Tag','ReferencedFrameCheck');
VIZ.ORTHOMODE(3)=get(h, 'Value');

h=findobj('Tag','AnatomicalFrameCheck');
VIZ.ORTHOMODE(4)=get(h, 'Value');

h=findobj('Tag','AnatomicalMarkerCheck');
VIZ.ORTHOMODE(5)=get(h, 'Value');

h=findobj('Tag','StickFigureCheck');
VIZ.ORTHOMODE(6)=get(h, 'Value');

h=findobj('Tag','GroundReactionForceCheck');
VIZ.ORTHOMODE(7)=get(h, 'Value');

h=findobj('Tag','BoldLineCheck');
VIZ.ORTHOMODE(8)=get(h, 'Value');

h=findobj('Tag','KeepStickHistory');
VIZ.ORTHOMODE(9)=get(h, 'Value');


% ========================================

axes(findobj('Tag','SideView'));cla
axes(findobj('Tag','FrontView'));cla
axes(findobj('Tag','TopView'));cla

% ============================================================
color      = [ 'r' 'g' 'c' 'm' 'b' 'y'];
white=[1 1 1];
black=[ 0 0 0];

if VIZ.ORTHOMODE(8)==1
    linewidth = 3; % use thick lines
else
    linewidth = 2;
end
if VIZ.ORTHOMODE(9)==1
    StickEraseMode='none'; % don't erase former sticks
else
    StickEraseMode='xor'; % default
end

h=findobj('Tag','OrthoSlider');
dot=get(h,'value');

iTime=dot*((size(BODY.SEGMENT(1).Cluster.KinematicsMarkers,3)-1)...
    .* BODY.SEGMENT(1).Cluster.TimeGain)+BODY.SEGMENT(1).Cluster.TimeOffset;

set(findobj('Tag','TimeDisplay'),'String',num2str(iTime));


% ====================================
% VISUALISATION MODE  1
%
% cluster markers
% ====================================

if VIZ.ORTHOMODE(1)==1,

    for i=1:length(BODY.SEGMENT),

        if ~isempty(BODY.SEGMENT(i).Cluster.KinematicsMarkers),

            iframe=1+round((iTime-BODY.SEGMENT(i).Cluster.TimeOffset)/BODY.SEGMENT(i).Cluster.TimeGain);

            if iframe>=1 & iframe<=size(BODY.SEGMENT(i).Cluster.KinematicsMarkers,3),

                markers=BODY.SEGMENT(i).Cluster.KinematicsMarkers(:,:,iframe).*1000.; % m to mm

                icolor=mod(i-1,length(color))+1;

                axes(findobj('Tag','SideView'));
                VIZ.ORTHOHANDLE(1,Z,i)=...
                    line(...
                    markers(X,:),...
                    markers(Y,:),...
                    'Marker','.',...
                    'LineStyle','none',...
                    'Color',color(icolor),...
                    'EraseMode','background');

                axes(findobj('Tag','FrontView'));
                VIZ.ORTHOHANDLE(1,X,i)=...
                    line(...
                    markers(Z,:),...
                    markers(Y,:),...
                    'Marker','.',...
                    'LineStyle','none',...
                    'Color',color(icolor),...
                    'EraseMode','background');

                axes(findobj('Tag','TopView'));
                VIZ.ORTHOHANDLE(1,Y,i)=...
                    line(...
                    markers(X,:),...
                    markers(Z,:),...
                    'Marker','.',...
                    'LineStyle','none',...
                    'Color',color(icolor),...
                    'EraseMode','background');
            end
        end
    end
end

% ====================================
% VISUALISATION MODE  2
%
% (technical) cluster frames
% ====================================

if VIZ.ORTHOMODE(2)==1,

    for i=1:length(BODY.SEGMENT),
        if ~isempty(BODY.SEGMENT(i).Cluster.KinematicsPose),

            iframe=1+round((iTime-BODY.SEGMENT(i).Cluster.TimeOffset)/BODY.SEGMENT(i).Cluster.TimeGain);

            if iframe>=1 & iframe<=size(BODY.SEGMENT(i).Cluster.KinematicsPose,3),

                T=BODY.SEGMENT(i).Cluster.KinematicsPose(:,:,iframe);
                origin=T(1:3,4).*1000.; %

                xaxis=[origin origin+T(1:3,1:3)*[250. 0 0]']; %
                yaxis=[origin origin+T(1:3,1:3)*[0 250. 0]']; %
                zaxis=[origin origin+T(1:3,1:3)*[0 0 250.]']; %

                axes(findobj('Tag','SideView'));
                VIZ.ORTHOHANDLE(2,Z,i,1)=line(xaxis(X,:),xaxis(Y,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,Z,i,2)=line(yaxis(X,:),yaxis(Y,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,Z,i,3)=line(zaxis(X,:),zaxis(Y,:),'Color','b','EraseMode','xor');

                axes(findobj('Tag','FrontView'));
                VIZ.ORTHOHANDLE(2,X,i,1)=line(xaxis(Z,:),xaxis(Y,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,X,i,2)=line(yaxis(Z,:),yaxis(Y,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,X,i,3)=line(zaxis(Z,:),zaxis(Y,:),'Color','b','EraseMode','xor');

                axes(findobj('Tag','TopView'));
                VIZ.ORTHOHANDLE(2,Y,i,1)=line(xaxis(X,:),xaxis(Z,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,Y,i,2)=line(yaxis(X,:),yaxis(Z,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,Y,i,3)=line(zaxis(X,:),zaxis(Z,:),'Color','b','EraseMode','xor');
            end
        end
    end
end

% ====================================
% VISUALISATION MODE  3
%
% orientation referenced clusterframes
% ====================================
if VIZ.ORTHOMODE(3)==1,

    for i=1:length(BODY.SEGMENT),
        if (~isempty(BODY.SEGMENT(i).Cluster.PostureRefKinematicsPose)...
                & ~isempty(BODY.SEGMENT(i).Cluster.KinematicsPose) ),

            iframe=1+round((iTime-BODY.SEGMENT(i).Cluster.TimeOffset)/BODY.SEGMENT(i).Cluster.TimeGain);

            if iframe>=1 & iframe<=size(BODY.SEGMENT(i).Cluster.PostureRefKinematicsPose,3),

                T=BODY.SEGMENT(i).Cluster.KinematicsPose(:,:,iframe);
                origin=T(1:3,4).*1000.; % translation is not referenced

                T=BODY.SEGMENT(i).Cluster.PostureRefKinematicsPose(:,:,iframe);
                xaxis=[origin origin+T(1:3,1:3)*[250. 0 0]']; %
                yaxis=[origin origin+T(1:3,1:3)*[0 250. 0]']; %
                zaxis=[origin origin+T(1:3,1:3)*[0 0 250.]']; %

                axes(findobj('Tag','SideView'));
                VIZ.ORTHOHANDLE(2,Z,i,1)=line(xaxis(X,:),xaxis(Y,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,Z,i,2)=line(yaxis(X,:),yaxis(Y,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,Z,i,3)=line(zaxis(X,:),zaxis(Y,:),'Color','b','EraseMode','xor');

                axes(findobj('Tag','FrontView'));
                VIZ.ORTHOHANDLE(2,X,i,1)=line(xaxis(Z,:),xaxis(Y,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,X,i,2)=line(yaxis(Z,:),yaxis(Y,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,X,i,3)=line(zaxis(Z,:),zaxis(Y,:),'Color','b','EraseMode','xor');

                axes(findobj('Tag','TopView'));
                VIZ.ORTHOHANDLE(2,Y,i,1)=line(xaxis(X,:),xaxis(Z,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,Y,i,2)=line(yaxis(X,:),yaxis(Z,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(2,Y,i,3)=line(zaxis(X,:),zaxis(Z,:),'Color','b','EraseMode','xor');
            end
        end
    end
end

% ====================================
% VISUALISATION MODE  4
%
% anatomical frames
% ====================================

if VIZ.ORTHOMODE(4)==1,  % anatomical frames

    for i=1:length(BODY.SEGMENT),
        if ~isempty(BODY.SEGMENT(i).AnatomicalFrame.KinematicsPose),

            iframe=1+round((iTime-BODY.SEGMENT(i).Cluster.TimeOffset)/BODY.SEGMENT(i).Cluster.TimeGain);

            if iframe>=1 & iframe<=size(BODY.SEGMENT(i).AnatomicalFrame.KinematicsPose,3),

                T=BODY.SEGMENT(i).AnatomicalFrame.KinematicsPose(:,:,iframe);
                origin=T(1:3,4).*1000.; %

                xaxis=[origin origin+T(1:3,1:3)*[250. 0 0]']; %
                yaxis=[origin origin+T(1:3,1:3)*[0 250. 0]']; %
                zaxis=[origin origin+T(1:3,1:3)*[0 0 250.]']; %

                axes(findobj('Tag','SideView'));
                VIZ.ORTHOHANDLE(4,Z,i,1)=line(xaxis(X,:),xaxis(Y,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(4,Z,i,2)=line(yaxis(X,:),yaxis(Y,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(4,Z,i,3)=line(zaxis(X,:),zaxis(Y,:),'Color','b','EraseMode','xor');

                axes(findobj('Tag','FrontView'));
                VIZ.ORTHOHANDLE(4,X,i,1)=line(xaxis(Z,:),xaxis(Y,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(4,X,i,2)=line(yaxis(Z,:),yaxis(Y,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(4,X,i,3)=line(zaxis(Z,:),zaxis(Y,:),'Color','b','EraseMode','xor');

                axes(findobj('Tag','TopView'));
                VIZ.ORTHOHANDLE(4,Y,i,1)=line(xaxis(X,:),xaxis(Z,:),'Color','r','EraseMode','xor');
                VIZ.ORTHOHANDLE(4,Y,i,2)=line(yaxis(X,:),yaxis(Z,:),'Color','g','EraseMode','xor');
                VIZ.ORTHOHANDLE(4,Y,i,3)=line(zaxis(X,:),zaxis(Z,:),'Color','b','EraseMode','xor');
            end
        end
    end
end

% ====================================
% VISUALISATION MODE  5
%
% anatomical markers
% ====================================

if VIZ.ORTHOMODE(5)==1,
    for i=1:length(BODY.SEGMENT),
        if isfield(BODY.SEGMENT(i),'AnatomicalLandmark'),
            if ~isempty(BODY.SEGMENT(i).AnatomicalLandmark(1).Name)
                iLandmark=1;
                iframe=1+round((iTime-BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).TimeOffset)...
                    /BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).TimeGain);
                if ~isempty(BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).Kinematics),

                    if iframe>=1 & iframe<=size(BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).Kinematics,2),
                        clear markers
                        for iLandmark=1:length(BODY.SEGMENT(i).AnatomicalLandmark),
                            markers(:,iLandmark)=BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).Kinematics(:,iframe).*1000.; % meters to mm.
                        end

                        icolor=mod(i-1,length(color))+1;

                        axes(findobj('Tag','SideView'));
                        VIZ.ORTHOHANDLE(5,Z,i)=...
                            line(...
                            markers(X,:),...
                            markers(Y,:),...
                            'Marker','.',...
                            'LineStyle','none',...
                            'Color',color(icolor),...
                            'EraseMode','background');

                        axes(findobj('Tag','FrontView'));
                        VIZ.ORTHOHANDLE(5,X,i)=...
                            line(...
                            markers(Z,:),...
                            markers(Y,:),...
                            'Marker','.',...
                            'LineStyle','none',...
                            'Color',color(icolor),...
                            'EraseMode','background');

                        axes(findobj('Tag','TopView'));
                        VIZ.ORTHOHANDLE(5,Y,i)=...
                            line(...
                            markers(X,:),...
                            markers(Z,:),...
                            'Marker','.',...
                            'LineStyle','none',...
                            'Color',color(icolor),...
                            'EraseMode','background');
                    end
                end
            end
        end
    end
end

% ====================================
% VISUALISATION MODE  6
%
% stick diagram
% ====================================
if VIZ.ORTHOMODE(6)==1,

    for i=1:length(BODY.SEGMENT),
        if ~isempty(BODY.SEGMENT(i).StickFigure(i)),
            if ~isempty(BODY.SEGMENT(i).StickFigure(1).Kinematics),

                iframe=1+round((iTime-BODY.SEGMENT(i).StickFigure(1).TimeOffset)/BODY.SEGMENT(i).StickFigure(1).TimeGain);

                if iframe>=1 & iframe<=size(BODY.SEGMENT(i).StickFigure(1).Kinematics,2),
                    clear stickmarkers
                    for iStickmarker=1:length(BODY.SEGMENT(i).StickFigure),
                        stickmarkers(:,iStickmarker)=BODY.SEGMENT(i).StickFigure(iStickmarker).Kinematics(:,iframe).*1000.; % meters to mm.
                    end

                    icolor=mod(i-1,length(color))+1;
                    stick_color=color(icolor);
                    % stick_color=white;

                    axes(findobj('Tag','SideView'));
                    VIZ.ORTHOHANDLE(6,Z,i)=...
                        line(...
                        stickmarkers(X,:),...
                        stickmarkers(Y,:),...
                        'Marker','.',...
                        'Color',stick_color,...
                        'LineWidth',linewidth,...
                        'EraseMode',StickEraseMode);

                    axes(findobj('Tag','FrontView'));
                    VIZ.ORTHOHANDLE(6,X,i)=...
                        line(...
                        stickmarkers(Z,:),...
                        stickmarkers(Y,:),...
                        'Marker','.',...
                        'Color',stick_color,...
                        'LineWidth',linewidth,...
                        'EraseMode',StickEraseMode);

                    axes(findobj('Tag','TopView'));
                    VIZ.ORTHOHANDLE(6,Y,i)=...
                        line(...
                        stickmarkers(X,:),...
                        stickmarkers(Z,:),...
                        'Marker','.',...
                        'Color',stick_color,...
                        'LineWidth',linewidth,...
                        'EraseMode',StickEraseMode);
                end
            end
        end
    end
end
% ====================================
% VISUALISATION MODE  7
%
% ground reaction force
% ====================================
if VIZ.ORTHOMODE(7)==1,

    if length(BODY.CONTEXT.ExternalForce)>=1,
        ef_id=1; % maximally one forceplate implemented
        if length(BODY.CONTEXT.ExternalForce(ef_id).Signals)~=0,

            iframe=1+round((iTime-BODY.CONTEXT.ExternalForce(ef_id).TimeOffset)...
                /BODY.CONTEXT.ExternalForce(ef_id).TimeGain);

            if  iframe>=1 & iframe<=size(BODY.CONTEXT.ExternalForce(ef_id).Signals,2),


                Grf1=BODY.CONTEXT.ExternalForce(ef_id).Signals(:,iframe);
                origin=[Grf1(4) ; 0 ; Grf1(5)].*1000.; % meters to mm.
                ForceVector=[origin  -Grf1(1:3)*1.+origin];  % 100 mm = 100 N

                axes(findobj('Tag','SideView'));
                VIZ.ORTHOHANDLE(7,Z,1)=...
                    line(...
                    ForceVector(X,:),...
                    ForceVector(Y,:),...
                    'Color','w',...
                    'LineWidth',linewidth,...
                    'EraseMode',StickEraseMode);

                axes(findobj('Tag','FrontView'));
                VIZ.ORTHOHANDLE(7,X,1)=...
                    line(...
                    ForceVector(Z,:),...
                    ForceVector(Y,:),...
                    'Color','w',...
                    'LineWidth',linewidth,...
                    'EraseMode',StickEraseMode);

                axes(findobj('Tag','TopView'));
                VIZ.ORTHOHANDLE(7,Y,1)=...
                    line(...
                    ForceVector(X,:),...
                    ForceVector(Z,:),...
                    'Color','w',...
                    'LineWidth',linewidth,...
                    'EraseMode',StickEraseMode);
            end
        end
    end
end
% ===============================================
return
%================================================
% END ### UpdateVizOrthoMode ###
