%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function allAngles = GetAllAngleNames(bodyModel, selJointsInd)

BodyMechFuncHeader
eval(bodyModel)
allJoints = GetAllJoints(bodyModel);
if ischar(selJointsInd) && strcmp(selJointsInd,'-all')
    DeleteUnusedSegments(allJoints);
else
    DeleteUnusedSegments(allJoints(selJointsInd));
end
allAngles = {};
for i = 1 : length(BODY.JOINT)
    for j = 1 : 3
        [t,r] = strtok(BODY.JOINT(i).PostureRefKinematics.AngleNames{j});
        if ~isempty(t)
            allAngles{end+1} = BODY.JOINT(i).PostureRefKinematics.AngleNames{j};
        end
    end
end
