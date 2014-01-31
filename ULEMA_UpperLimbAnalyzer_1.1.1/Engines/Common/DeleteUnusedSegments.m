%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function DeleteUnusedSegments(wantedJoints)

% Recall global variables
BodyMechFuncHeader

% Delete unused joints
jointsToDelete = [];
segmentsMaybeToDelete = {};
for i = 1 : length(BODY.JOINT)
    if isempty(findc(wantedJoints,BODY.JOINT(i).Name))
        jointsToDelete(end+1) = i;
        segmentsMaybeToDelete{end+1} = BODY.JOINT(i).ProximalSegmentName;
        segmentsMaybeToDelete{end+1} = BODY.JOINT(i).DistalSegmentName;
    end
end
jointsToDelete = unique(jointsToDelete);
segmentsMaybeToDelete = unique(segmentsMaybeToDelete);
BODY.JOINT(jointsToDelete) = [];

% Getting list of proximal and distal segments remained
necessarySegments = {};
for i = 1 : length(BODY.JOINT)
    necessarySegments{end+1} = BODY.JOINT(i).ProximalSegmentName;
    necessarySegments{end+1} = BODY.JOINT(i).DistalSegmentName;
end
necessarySegments = unique(necessarySegments);

% Check if the anatomical landmarks of the necessary segments are shared
% among other segments. If so, put them in the necessarySegments list
toAddToNecessarySegments = {};
for i = 1 : length(necessarySegments)
    toAddToNecessarySegments = [toAddToNecessarySegments, checkForSharedAL(BODY, necessarySegments{i})];
end
toAddToNecessarySegments = unique(toAddToNecessarySegments);
necessarySegments = [necessarySegments, toAddToNecessarySegments]; 

% Checking if the segments that maybe could be deleted are shared with
% the remaining joints
segmentsToDelete = {};
indexesToKeep = [];
for i = 1 : length(segmentsMaybeToDelete)
    if ~isempty(findc(necessarySegments, segmentsMaybeToDelete{i}))
        indexesToKeep(end+1) = 1;
    else
        indexesToKeep(end+1) = 0;
    end
end
indexesToKeep = find(indexesToKeep == 1);
segmentsToDelete = segmentsMaybeToDelete;
segmentsToDelete(indexesToKeep) = [];

% Before deleting segments, get the index of the markers sequence to remove
markersToDelete = [];
for i = 1 : length(BODY.SEGMENT)
    if ~isempty(findc(segmentsToDelete, BODY.SEGMENT(i).Name))
        markersToDelete = [markersToDelete, BODY.SEGMENT(i).Cluster.MarkerInputFileIndices];
    end
end

% Delete segments and markers
indexesToDelete = [];
for i = 1 : length(BODY.SEGMENT)
    if ~isempty(findc(segmentsToDelete, BODY.SEGMENT(i).Name))
        indexesToDelete(end+1) = 1;
    else
        indexesToDelete(end+1) = 0;
    end
end
indexesToDelete = find(indexesToDelete == 1);
BODY.SEGMENT(indexesToDelete) = [];
BODY.CONTEXT.OrigMyLabelSequence = BODY.CONTEXT.MarkerLabels;  % create a copyc of the original label sequence
BODY.CONTEXT.MarkerLabels(markersToDelete) = [];

% After deleting segments and markers, recalculate the indexes of every 
% technical marker (for every remained segment) and place it to 
% (BODY.SEGMENT(i).Cluster.MarkerInputFileIndices)
for i = 1 : length(BODY.SEGMENT)
    BODY.SEGMENT(i).Cluster.OrigMarkerInputFileIndices = BODY.SEGMENT(i).Cluster.MarkerInputFileIndices;
    BODY.SEGMENT(i).Cluster.MarkerInputFileIndices = getNewMarkerInputFileIndices(BODY.CONTEXT.MarkerLabels, BODY.SEGMENT(i).Cluster.MarkerLabels);
end

if isfield(BODY.CONTEXT.Stylus, 'ToTipFunction')
    % Do the same for the stylus pointer
    StylusMarkerLabels = BODY.CONTEXT.OrigMyLabelSequence(BODY.CONTEXT.Stylus.MarkerInputFileIndices);
    BODY.CONTEXT.Stylus.OrigMarkerInputFileIndices = BODY.CONTEXT.Stylus.MarkerInputFileIndices;
    BODY.CONTEXT.Stylus.MarkerInputFileIndices = getNewMarkerInputFileIndices(BODY.CONTEXT.MarkerLabels, StylusMarkerLabels);
end


%% Subfunctions



function MarkerInputFileIndices = getNewMarkerInputFileIndices(AllMarkerLabels, SegMarkerLabels)
MarkerInputFileIndices = [];
for i = 1 : length(SegMarkerLabels)
    for j = 1 : length(AllMarkerLabels)
        if strcmp(SegMarkerLabels{i}, AllMarkerLabels{j})
            MarkerInputFileIndices(end+1) = j;
        end
    end
end





function toAdd = checkForSharedAL(BODY, necessarySegment)
toAdd = {};
if ~strcmp(necessarySegment,'Global') 
    % search for necessary segment in the BODY.SEGMENT structure
    for i = 1 : length(BODY.SEGMENT)
        if strcmp(BODY.SEGMENT(i).Name,necessarySegment)
            index = i;
            break
        end
    end
    % check for shared landmarks inside necessarySegment
    for i = 1 : length(BODY.SEGMENT(index).AnatomicalLandmark)
        if isfield(BODY.SEGMENT(index).AnatomicalLandmark(i),'SharedWith')
            toAdd = [toAdd, BODY.SEGMENT(index).AnatomicalLandmark(i).SharedWith];
        end
    end
    toAdd = unique(toAdd);
end




