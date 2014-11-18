%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function allMarkers = GetAllMarkers(bodyModel, selJointsInd)

% This function returns all the used points (technical + ALs) necessary to
% compute the joint angles with indeces in vector selJointsAll 

BodyMechFuncHeader
eval(bodyModel);
allJoints = GetAllJoints(bodyModel);
if ischar(selJointsInd) && strcmp(selJointsInd,'-all')
    DeleteUnusedSegments(allJoints);
else
    DeleteUnusedSegments(allJoints(selJointsInd));
end
allMarkers = BODY.CONTEXT.MarkerLabels;
for i =  1 : length(BODY.SEGMENT)
    for j = 1 : length(BODY.SEGMENT(i).AnatomicalLandmark)
        allMarkers = [allMarkers, BODY.SEGMENT(i).AnatomicalLandmark(j).Name];
    end
end
allMarkers = unique(allMarkers);

