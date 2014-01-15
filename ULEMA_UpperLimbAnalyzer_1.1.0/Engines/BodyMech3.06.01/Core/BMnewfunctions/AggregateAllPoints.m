%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function points = AggregateAllPoints(points, markerGroup)

if ~isstruct(markerGroup)
    
    % Set global variables
    BodyMechFuncHeader;

    % Add anatomical landmarks
    if strcmp(markerGroup,'AnatomicalLandmarks') 
        for i = 1 : length(BODY.SEGMENT)
            for j = 1 : length(BODY.SEGMENT(i).AnatomicalLandmark)
                points.(BODY.SEGMENT(i).AnatomicalLandmark(j).Name) = BODY.SEGMENT(i).AnatomicalLandmark(j).Kinematics';
            end
        end
    end

    % Add technical points
    if strcmp(markerGroup,'TechnicalMarkers') 
        for i = 1 : length(BODY.SEGMENT)
            for j = 1 : length(BODY.SEGMENT(i).Cluster.MarkerLabels)
                points.(BODY.SEGMENT(i).Cluster.MarkerLabels{j}) = squeeze(BODY.SEGMENT(i).Cluster.KinematicsMarkers(:,j,:))';    
            end
        end
    end

    % Add pointer markers
    if strcmp(markerGroup,'PointerMarkers')
        StylusMarkerNumbers = BODY.CONTEXT.Stylus.MarkerInputFileIndices;
        StylusMarkerNames = BODY.CONTEXT.MarkerLabels(StylusMarkerNumbers);
        for i = 1 : length(StylusMarkerNumbers)
            points.(StylusMarkerNames{i}) = squeeze(MARKER_DATA(:,StylusMarkerNumbers(i),:))';
        end
    end
    
    % Add MHA markers 
    if strcmp(markerGroup,'MHAMarkers')
        for i = 1 : length(BODY.SEGMENT)
            if isfield(BODY.SEGMENT(i), 'FunctionalAxis') %&& ~isempty(BODY.SEGMENT(i).FunctionalAxis) 
                for j = 1 : length(BODY.SEGMENT(i).FunctionalAxis)
                    points.(BODY.SEGMENT(i).FunctionalAxis(j).Marker1.Name) = BODY.SEGMENT(i).FunctionalAxis(j).Marker1.Kinematics';
                    points.(BODY.SEGMENT(i).FunctionalAxis(j).Marker2.Name) = BODY.SEGMENT(i).FunctionalAxis(j).Marker2.Kinematics';
                end
            end
        end
    end
    
    % Add additional markers, if not already present
    if strcmp(markerGroup,'AdditionalMarkers')
        for i = 1 : length(BODY.CONTEXT.MarkerLabels)
            if ~isfield(points, BODY.CONTEXT.MarkerLabels{i})
                points.(BODY.CONTEXT.MarkerLabels{i}) = squeeze(MARKER_DATA(:,i,:))';
            end
        end
    end

else
    
    newMarkers = fieldnames(markerGroup);
    for i = 1 : length(newMarkers)
        points.(newMarkers{i}) = markerGroup.(newMarkers{i});
    end
    
end