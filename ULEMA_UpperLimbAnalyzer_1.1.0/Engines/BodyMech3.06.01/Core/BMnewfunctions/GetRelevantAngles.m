%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function angles = GetRelevantAngles(iJointsAbs, absAngRefPos)

% Set global variables
BodyMechFuncHeader;

% Extract only relevant angles (that is, the ones selected in the GUI)
msg = [];
for i = 1 : length(BODY.JOINT)
    ind = find(iJointsAbs == i, 1, 'first');
    if ~isempty(ind)
        toUseAbs = 1;
    else
        toUseAbs = 0;
    end
    for j = 1 : 3
        name = BODY.JOINT(i).PostureRefKinematics.AngleNames{j};
        if ~isempty(name)
            if toUseAbs == 1    % the angles of the current joint are actually absolute to ref posture or lab ref frame
                if absAngRefPos == 0 
                    % Fictitious anatomy based -> lab reference frame based
                    angles.(name) = BODY.JOINT(i).AnatomyRefKinematics.AnglesMult(j) * BODY.JOINT(i).AnatomyRefKinematics.RotationAngles(j,:)';
                else
                    % Reference based
                    angles.(name) = BODY.JOINT(i).PostureRefKinematics.AnglesMult(j) * BODY.JOINT(i).PostureRefKinematics.RotationAngles(j,:)';
                    msg = [msg, ', ', name];
                end
            else
                % Anatomy based
                angles.(name) = BODY.JOINT(i).AnatomyRefKinematics.AnglesMult(j) * BODY.JOINT(i).AnatomyRefKinematics.RotationAngles(j,:)';
            end
        end
    end
end
if ~isempty(msg)
    fprintf('\n     (%s reference based)', msg(3:end));
end


