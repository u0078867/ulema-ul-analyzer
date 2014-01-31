%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function UpdateOrthoView
% UPDATEORTHOVIEW [ BodyMech 3.06.01 ]: Updates orthogonal display window
% INPUT
%    Input : global VIZ.ORTHOMODE
%                   VIZ.ORTHOHANDLE
%                   BODY.SEGMENT(i).Cluster.KinematicsMarkers
%                   BODY.SEGMENT(i).Cluster.KinematicsPose
%                   BODY.SEGMENT(i).Cluster.PostureRefKinematicsPose
%                   BODY.SEGMENT(i).AnatomicalFrame.KinematicsPose
%                   BODY.SEGMENT(i).AnatomicalLandmark.Kinematics
%                   BODY.SEGMENT(i).StickFigure.Kinematics
%                   BODY.SEGMENT(1).Cluster.TimeGain
%                   BODY.SEGMENT(1).Cluster.TimeOffset
%                   BODY.CONTEXT.ExternalForce
%                   
% PROCESS
%   Updates orthogonal display window dependent on slider time
% OUTPUT
%

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader
color      = [ 'r' 'g' 'c' 'm' 'b' 'y'];

if VIZ.ORTHOMODE(8)==1, % line thickness
    linewidth = 2;
else
    linewidth = 3;
end

h=findobj('Tag','OrthoSlider');
if ~isempty(h),
    dot=get(h,'value')  % steps from 0:1% over totale deel: 100%
end

% iframe=1+round(dot*(length(BODY.SEGMENT(1).Cluster.KinematicsMarkers)-1));

iTime=dot*((length(BODY.SEGMENT(1).Cluster.KinematicsMarkers)-1)...
    .* BODY.SEGMENT(1).Cluster.TimeGain)+BODY.SEGMENT(1).Cluster.TimeOffset;

iTime=floor(iTime*100)./100;   % to limit display to 1/100 of sec

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

            if iframe>=1 & iframe<=length(BODY.SEGMENT(i).Cluster.KinematicsMarkers),

                markers=BODY.SEGMENT(i).Cluster.KinematicsMarkers(:,:,iframe).*1000.; % meters to mm.

                set(VIZ.ORTHOHANDLE(1,Z,i),'Xdata',markers(X,:),'Ydata',markers(Y,:)); % SideView
                set(VIZ.ORTHOHANDLE(1,X,i),'Xdata',markers(Z,:),'Ydata',markers(Y,:)); % FrontView
                set(VIZ.ORTHOHANDLE(1,Y,i),'Xdata',markers(X,:),'Ydata',markers(Z,:)); % TopView
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

            if iframe>=1 & iframe<=length(BODY.SEGMENT(i).Cluster.KinematicsPose),

                T=BODY.SEGMENT(i).Cluster.KinematicsPose(:,:,iframe);
                origin=T(1:3,4).*1000.; % meters to mm.

                xaxis=[origin origin+T(1:3,1:3)*[250. 0 0]']; %
                yaxis=[origin origin+T(1:3,1:3)*[0 250. 0]']; %
                zaxis=[origin origin+T(1:3,1:3)*[0 0 250.]']; %


                set(VIZ.ORTHOHANDLE(2,Z,i,1),'Xdata',xaxis(X,:),'Ydata',xaxis(Y,:));
                set(VIZ.ORTHOHANDLE(2,Z,i,2),'Xdata',yaxis(X,:),'Ydata',yaxis(Y,:));
                set(VIZ.ORTHOHANDLE(2,Z,i,3),'Xdata',zaxis(X,:),'Ydata',zaxis(Y,:));

                set(VIZ.ORTHOHANDLE(2,X,i,1),'Xdata',xaxis(Z,:),'Ydata',xaxis(Y,:));
                set(VIZ.ORTHOHANDLE(2,X,i,2),'Xdata',yaxis(Z,:),'Ydata',yaxis(Y,:));
                set(VIZ.ORTHOHANDLE(2,X,i,3),'Xdata',zaxis(Z,:),'Ydata',zaxis(Y,:));

                set(VIZ.ORTHOHANDLE(2,Y,i,1),'Xdata',xaxis(X,:),'Ydata',xaxis(Z,:));
                set(VIZ.ORTHOHANDLE(2,Y,i,2),'Xdata',yaxis(X,:),'Ydata',yaxis(Z,:));
                set(VIZ.ORTHOHANDLE(2,Y,i,3),'Xdata',zaxis(X,:),'Ydata',zaxis(Z,:));
            end
        end
    end
end
% ====================================
% VISUALISATION MODE  3
%
% orientation referenced clusterframes
% ====================================
if VIZ.ORTHOMODE(3)==1,  % referenced clusterframes

    for i=1:length(BODY.SEGMENT),
        if (~isempty(BODY.SEGMENT(i).Cluster.PostureRefKinematicsPose)...
                & ~isempty(BODY.SEGMENT(i).Cluster.KinematicsPose) ),

            iframe=1+round((iTime-BODY.SEGMENT(i).Cluster.TimeOffset)/BODY.SEGMENT(i).Cluster.TimeGain);

            if iframe>=1 & iframe<=length(BODY.SEGMENT(i).Cluster.PostureRefKinematicsPose),

                T=BODY.SEGMENT(i).Cluster.KinematicsPose(:,:,iframe);
                origin=T(1:3,4).*1000.; % meters to mm.;
                % ONLY the orientation is referenced
                T=BODY.SEGMENT(i).Cluster.PostureRefKinematicsPose(:,:,iframe);

                xaxis=[origin origin+T(1:3,1:3)*[250. 0 0]']; %
                yaxis=[origin origin+T(1:3,1:3)*[0 250. 0]']; %
                zaxis=[origin origin+T(1:3,1:3)*[0 0 250.]']; %

                set(VIZ.ORTHOHANDLE(2,Z,i,1),'Xdata',xaxis(X,:),'Ydata',xaxis(Y,:));
                set(VIZ.ORTHOHANDLE(2,Z,i,2),'Xdata',yaxis(X,:),'Ydata',yaxis(Y,:));
                set(VIZ.ORTHOHANDLE(2,Z,i,3),'Xdata',zaxis(X,:),'Ydata',zaxis(Y,:));

                set(VIZ.ORTHOHANDLE(2,X,i,1),'Xdata',xaxis(Z,:),'Ydata',xaxis(Y,:));
                set(VIZ.ORTHOHANDLE(2,X,i,2),'Xdata',yaxis(Z,:),'Ydata',yaxis(Y,:));
                set(VIZ.ORTHOHANDLE(2,X,i,3),'Xdata',zaxis(Z,:),'Ydata',zaxis(Y,:));

                set(VIZ.ORTHOHANDLE(2,Y,i,1),'Xdata',xaxis(X,:),'Ydata',xaxis(Z,:));
                set(VIZ.ORTHOHANDLE(2,Y,i,2),'Xdata',yaxis(X,:),'Ydata',yaxis(Z,:));
                set(VIZ.ORTHOHANDLE(2,Y,i,3),'Xdata',zaxis(X,:),'Ydata',zaxis(Z,:));
            end
        end
    end
end

% ====================================
% VISUALISATION MODE  4
%
% anatomical frames
% ====================================
if VIZ.ORTHOMODE(4)==1,

    for i=1:length(BODY.SEGMENT),
        if ~isempty(BODY.SEGMENT(i).AnatomicalFrame.KinematicsPose),

            iframe=1+round((iTime-BODY.SEGMENT(i).Cluster.TimeOffset)/BODY.SEGMENT(i).Cluster.TimeGain);

            if iframe>=1 & iframe<=length(BODY.SEGMENT(i).AnatomicalFrame.KinematicsPose),

                T=BODY.SEGMENT(i).AnatomicalFrame.KinematicsPose(:,:,iframe);
                origin=T(1:3,4).*1000.; % meters to mm.

                xaxis=[origin origin+T(1:3,1:3)*[250. 0 0]']; %
                yaxis=[origin origin+T(1:3,1:3)*[0 250. 0]']; %
                zaxis=[origin origin+T(1:3,1:3)*[0 0 250.]']; %

                set(VIZ.ORTHOHANDLE(4,Z,i,1),'Xdata',xaxis(X,:),'Ydata',xaxis(Y,:));
                set(VIZ.ORTHOHANDLE(4,Z,i,2),'Xdata',yaxis(X,:),'Ydata',yaxis(Y,:));
                set(VIZ.ORTHOHANDLE(4,Z,i,3),'Xdata',zaxis(X,:),'Ydata',zaxis(Y,:));

                set(VIZ.ORTHOHANDLE(4,X,i,1),'Xdata',xaxis(Z,:),'Ydata',xaxis(Y,:));
                set(VIZ.ORTHOHANDLE(4,X,i,2),'Xdata',yaxis(Z,:),'Ydata',yaxis(Y,:));
                set(VIZ.ORTHOHANDLE(4,X,i,3),'Xdata',zaxis(Z,:),'Ydata',zaxis(Y,:));

                set(VIZ.ORTHOHANDLE(4,Y,i,1),'Xdata',xaxis(X,:),'Ydata',xaxis(Z,:));
                set(VIZ.ORTHOHANDLE(4,Y,i,2),'Xdata',yaxis(X,:),'Ydata',yaxis(Z,:));
                set(VIZ.ORTHOHANDLE(4,Y,i,3),'Xdata',zaxis(X,:),'Ydata',zaxis(Z,:));
            end
        end
    end
end
% ====================================
% VISUALISATION MODE  5
%
% cluster markers
% ====================================
if VIZ.ORTHOMODE(5)==1,

    for i=1:length(BODY.SEGMENT),
        if isfield(BODY.SEGMENT(i),'AnatomicalLandmark'),
            if ~isempty(BODY.SEGMENT(i).AnatomicalLandmark(1).Name)
                iLandmark=1;
                iframe=1+round((iTime-BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).TimeOffset)...
                    /BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).TimeGain);
                if ~isempty(BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).Kinematics),
                    if iframe>=1 & iframe<=length(BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).Kinematics),

                        for iLandmark=1:length(BODY.SEGMENT(i).AnatomicalLandmark),
                            markers(:,iLandmark)=BODY.SEGMENT(i).AnatomicalLandmark(iLandmark).Kinematics(:,iframe).*1000.; % meters to mm.
                        end
                        set(VIZ.ORTHOHANDLE(5,Z,i),'Xdata',markers(X,:),'Ydata',markers(Y,:)); % SideView
                        set(VIZ.ORTHOHANDLE(5,X,i),'Xdata',markers(Z,:),'Ydata',markers(Y,:)); % FrontView
                        set(VIZ.ORTHOHANDLE(5,Y,i),'Xdata',markers(X,:),'Ydata',markers(Z,:)); % TopView
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
        if ~isempty(BODY.SEGMENT(i).StickFigure(1).Kinematics),

            iframe=1+round((iTime-BODY.SEGMENT(i).StickFigure(1).TimeOffset)/BODY.SEGMENT(i).StickFigure(1).TimeGain);

            if iframe>=1 & iframe<=length(BODY.SEGMENT(i).StickFigure(1).Kinematics),
                clear stickmarkers
                for iStickmarker=1:length(BODY.SEGMENT(i).StickFigure),
                    stickmarkers(:,iStickmarker)=BODY.SEGMENT(i).StickFigure(iStickmarker).Kinematics(:,iframe).*1000.; % meters to mm.
                end
                set(VIZ.ORTHOHANDLE(6,Z,i),'Xdata',stickmarkers(X,:),'Ydata',stickmarkers(Y,:)); % SideView
                set(VIZ.ORTHOHANDLE(6,X,i),'Xdata',stickmarkers(Z,:),'Ydata',stickmarkers(Y,:)); % FrontView
                set(VIZ.ORTHOHANDLE(6,Y,i),'Xdata',stickmarkers(X,:),'Ydata',stickmarkers(Z,:)); % TopView
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

            if  iframe>=1 & iframe<=length(BODY.CONTEXT.ExternalForce(ef_id).Signals),

                Grf1=BODY.CONTEXT.ExternalForce(ef_id).Signals(:,iframe);
                origin=[Grf1(4) ; 0 ; Grf1(5)].*1000.; % meters to mm.
                ForceVector=[origin  Grf1(1:3)*1.+origin];  % 100 mm = 100 N

                set(VIZ.ORTHOHANDLE(7,Z,1),'Xdata',ForceVector(X,:),'Ydata',ForceVector(Y,:)); % SideView
                set(VIZ.ORTHOHANDLE(7,X,1),'Xdata',ForceVector(Z,:),'Ydata',ForceVector(Y,:)); % FrontView
                set(VIZ.ORTHOHANDLE(7,Y,1),'Xdata',ForceVector(X,:),'Ydata',ForceVector(Z,:)); % TopView
            end
        end
    end
end

return
%==========================================================================
% END ### UpdateOrthoView ###
