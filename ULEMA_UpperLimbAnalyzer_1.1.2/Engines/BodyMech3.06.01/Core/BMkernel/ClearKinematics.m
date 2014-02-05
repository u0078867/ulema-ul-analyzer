%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ClearKinematics(scope)
% CLEARKINEMATICS [ BodyMech 3.06.01 ]: Clear relevant fields in BODY.SEGMENT and BODY.JOINT
% INPUT
%   scope : 'markers';'segments';'jonts'
% PROCESS
%   clears kinematics fields in BODY.SEGMENT and BODY.JOINT
% OUTPUT
%   GLOBAL: BODY.SEGMENT (all segments); BODY.JOINT (all segments) : kinematic
%   fields cleared

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, July 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

if nargin < 1
    errordlg({'CLEAR_KINEMATICS';' ';...
        'scope not defined';...
        },...
        '** BODYMECH ERROR **')

    return
end

Nsegments=length(BODY.SEGMENT);
if Nsegments==0
    errordlg({'CLEAR_KINEMATICS';' ';...
        'no_body defined';...
        },...
        '** BODYMECH ERROR **')
    return
else
    for iSegment=1:Nsegments
        if ~isempty(BODY.SEGMENT(iSegment).Name)
            if strcmp(scope,'markers')
                BODY.SEGMENT(iSegment).Cluster.TimeGain=[];
                BODY.SEGMENT(iSegment).Cluster.TimeOffset=[];
                BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers=zeros(3,0,0);
                BODY.SEGMENT(iSegment).Cluster.RecordedMarkers=zeros(0,0);
                BODY.SEGMENT(iSegment).Cluster.AvailableMarkers=zeros(0,0);
                BODY.SEGMENT(iSegment).Cluster.KinematicsPose=zeros(4,4,0);
                BODY.SEGMENT(iSegment).Cluster.PostureRefKinematicsPose=zeros(4,4,0);

                for iLandmark=1:length(BODY.SEGMENT(iSegment).AnatomicalLandmark),
                    BODY.SEGMENT(iSegment).AnatomicalLandmark(iLandmark).Kinematics=zeros(3,0);
                end

                nStickmarkers2=length(BODY.SEGMENT(iSegment).StickFigure);
                for iStickmarker=1:nStickmarkers2,
                    BODY.SEGMENT(iSegment).StickFigure(iStickmarker).Kinematics=zeros(3,0,0);
                end

                BODY.SEGMENT(iSegment).AnatomicalFrame.KinematicsPose=zeros(4,4,0);

            elseif strcmp(scope,'segments')
                BODY.SEGMENT(iSegment).Cluster.PostureRefKinematicsPose=zeros(4,4,0);
                BODY.SEGMENT(iSegment).AnatomicalLandmark.Kinematics=zeros(3,0,0);
                BODY.SEGMENT(iSegment).StickFigure.Kinematics=zeros(3,0,0);
                BODY.SEGMENT(iSegment).AnatomicalFrame.KinematicsPose=zeros(4,4,0);

            elseif strcmp(scope,'joints')
                % nil

            else
                errordlg({'CLEAR_KINEMATICS';' ';...
                    'scope not recognized';...
                    },...
                    '** BODYMECH ERROR')
                return
            end
        end
    end
end

Njoints=length(BODY.JOINT);
if Nsegments ~=0
    for iJoint=1:Njoints
        if ~isempty(BODY.JOINT(iJoint).Name)
            BODY.JOINT(iJoint).PostureRefKinematics.Pose=zeros(4,4,0);
            BODY.JOINT(iJoint).AnatomyRefKinematics.Pose=zeros(4,4,0);
            BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles=zeros(3,0);
            BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles=zeros(3,0);
        end
    end
end


BodyMechFuncFooter
return

% ==============================
% END ### ClearKinematics ###
