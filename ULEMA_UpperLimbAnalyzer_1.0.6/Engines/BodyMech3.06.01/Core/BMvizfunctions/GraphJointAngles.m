%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function GraphJointAngles
% GRAPHJOINTANGLES [ BodyMech 3.06.01 ]: Graphs angular decomposition angles of joints
% INPUT
%   Global: BODY.JOINT.PostureRefKinematics.RotationAngles
%           BODY.JOINT.AnatomyRefKinematics.RotationAngles
% PROCESS
%   Generation of joint-angle graphs
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)
% $ Ver 3.07 FaBeR, Leuven, October 2007 (Ellen Jaspers)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

% PROCESS
Njoints=length(BODY.JOINT);
if Njoints>=1 
    str={BODY.JOINT.Name};
    [JointSelection,ok] = listdlg('PromptString','Select a JOINT:',...
        'SelectionMode','multiple',...
        'ListString',str);
    if ok==1,
        
        NselectedJoints=size(JointSelection,2);
        
        set(0,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');
        
        for iSelJoint=1:NselectedJoints,
            iJoint=JointSelection(iSelJoint);
            if iJoint>=1 & iJoint <=Njoints,
                if ~isempty(BODY.JOINT(iJoint).Name),
                    %%% Added 2in1 plot - MvdK April06
                  
                    if ~isempty(BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles) & ...
                            ~isempty(BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles),
                        
                        h=figure('Name',BODY.JOINT(iJoint).Name,'NumberTitle','off');
                        set(h,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');
                        clf
                        
                        for iDim=1:3
                            subplot(3,1,iDim)
                            plot(BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles(iDim,:),'--','LineWidth',2);hold on
                            plot(BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles(iDim,:),'r'); hold off
                            if iDim==1; graphtitle= char(BODY.JOINT(iJoint).Name, 'Posture Referenced (blue) + Anatomy Referenced (red)');
                            title(graphtitle); end
                            ylabel('degrees')
                        end
                    %%%%
                    elseif ~isempty(BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles),
                                             
                        h=figure('Name',BODY.JOINT(iJoint).Name,'NumberTitle','off');
                        set(h,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');
                        clf
                        subplot(3,1,1)
                        plot(BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles(1,:));
                        graphtitle= char(BODY.JOINT(iJoint).Name, 'Posture Referenced');
                        title(graphtitle);
                        ylabel('joint angle (degrees)')
                        subplot(3,1,2)
                        plot(BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles(2,:));
                        ylabel('degrees')
                        subplot(3,1,3)
                        plot(BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles(3,:));
                        ylabel('degrees')
                    
                     elseif ~isempty(BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles),        % TODO in zelfde plot? subplot 4,5, en 6 ?                        
                        h=figure('Name',BODY.JOINT(iJoint).Name,'NumberTitle','off');
                        set(h,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');
                        clf
                        subplot(3,1,1)
                        plot(BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles(1,:));
                        graphtitle= char(BODY.JOINT(iJoint).Name, 'Anatomy Referenced');
                        ylabel('degrees')
                        title(graphtitle);
                        subplot(3,1,2)
                        plot(BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles(2,:));
                        ylabel('degrees')
                        subplot(3,1,3)
                        plot(BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles(3,:));
                        ylabel('degrees')
                    end
                end
            end
        end % for-loop
        
    end  
end

return
% ============================================ 
% END ### GraphJointAngles ###
