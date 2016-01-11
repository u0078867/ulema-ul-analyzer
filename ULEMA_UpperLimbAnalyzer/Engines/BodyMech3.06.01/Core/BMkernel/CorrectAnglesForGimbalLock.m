%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CorrectAnglesForGimbalLock()

BodyMechFuncHeader

for iJoint = 1 : length(BODY.JOINT)
    for jPlane = 1 : 3
        if size(BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles, 2) == 0
            BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles(jPlane,:) = CorrectAngleForGimbalLock(...
                BODY.JOINT(iJoint).AnatomyRefKinematics.RotationAngles(jPlane,:)...
            );
        else
            BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles(jPlane,:) = CorrectAngleForGimbalLock(...
                BODY.JOINT(iJoint).PostureRefKinematics.RotationAngles(jPlane,:)...
            );
        end
    end
end





function angle = CorrectAngleForGimbalLock(angle)
jump = 200;
for i = 1 : length(angle)
    if i == 1
        angleRef = 0;
    else
        angleRef = angle(i-1);
    end
    if ~isnan(angle(i)) && ~isnan(angleRef) && abs(angle(i) - angleRef) > jump
         if sign(angleRef - angle(i)) == 1 
            angle(i:end) = angle(i:end) + 360; 
         else  
            angle(i:end) = angle(i:end) - 360; 
         end
    end
end




