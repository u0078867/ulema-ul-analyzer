%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function allSegments = GetAllSegments(bodyModel, selJointsInd)

% This function returns all the used segments necessary to
% compute the joint angles with indeces in vector selJointsAll 

BodyMechFuncHeader
eval(bodyModel);
allJoints = GetAllJoints(bodyModel);
if ischar(selJointsInd) && strcmp(selJointsInd,'-all')
    DeleteUnusedSegments(allJoints);
else
    DeleteUnusedSegments(allJoints(selJointsInd));
end
allSegments = {};
for i =  1 : length(BODY.SEGMENT)
    allSegments = [allSegments, BODY.SEGMENT(i).Name];
end
allSegments = unique(allSegments);

