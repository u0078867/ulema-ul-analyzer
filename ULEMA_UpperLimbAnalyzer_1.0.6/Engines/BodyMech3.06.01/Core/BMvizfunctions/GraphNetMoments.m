%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function GraphNetMoments
% GRAPHNETMOMENTS [ BodyMech 3.06.01 ]: Graphs angular decomposition angles of joints
% INPUT
%   Global: BODY.JOINT.NetMoment
% PROCESS
%   Generation of moment-angle graphs
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader
TimeGainOT=BODY.SEGMENT(1).Cluster.TimeGain;
KinematicTimeSpan=((size(BODY.SEGMENT(1).Cluster.KinematicsMarkers,3)-1).* BODY.SEGMENT(1).Cluster.TimeGain);
KinematicTimeOffSet=BODY.SEGMENT(1).Cluster.TimeOffset; 
TimeBase=KinematicTimeOffSet:TimeGainOT:KinematicTimeOffSet+KinematicTimeSpan;

% PROCESS
Njoints=length(BODY.JOINT);
if Njoints>=1 
    str={BODY.JOINT.Name};
    [JointSelection,ok] = listdlg('PromptString','Select a segment:',...
        'SelectionMode','multiple',...
        'ListString',str);
    if ok==1,
        
        NselectedJoints=size(JointSelection,2);
        
        set(0,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');
        
        for iSelJoint=1:NselectedJoints,
            iJoint=JointSelection(iSelJoint);
            if iJoint>=1 & iJoint <=Njoints,
                if ~isempty( BODY.JOINT(iJoint).Name),
                    
                     h=figure('Name',BODY.JOINT(iJoint).Name,'NumberTitle','off');
                        set(h,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');
                        clf
                    
                    if ~isempty(BODY.JOINT(iJoint).NetMoment),
                        subplot(3,1,1)
                        plot(TimeBase,BODY.JOINT(iJoint).NetMoment(1,:));
                        graphtitle= char(BODY.JOINT(iJoint).Name);
                        title(graphtitle);
						ylabel(' Net Moment in frontal plane');
                        subplot(3,1,2)
                        plot(TimeBase,BODY.JOINT(iJoint).NetMoment(2,:));
				        	ylabel(' Net Moment in horizontal plane');
                        subplot(3,1,3)
                        plot(TimeBase,BODY.JOINT(iJoint).NetMoment(3,:));
						ylabel(' Net Moment in sagittal plane');
						xlabel(' Time (s)')
					end
                end
            end
        end % for-loop
        
    end  
end

return
% ============================================ 
% END ### GraphNetMoments ###
