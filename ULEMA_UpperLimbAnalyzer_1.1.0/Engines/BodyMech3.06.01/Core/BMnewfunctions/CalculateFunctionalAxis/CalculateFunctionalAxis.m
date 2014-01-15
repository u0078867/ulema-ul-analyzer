%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function MHA = CalculateFunctionalAxis(MHAList, FullPath)

% CALCULATEFUNCTIONALAXIS [ BodyMech 3.06.01 ]: Calculation of
% functional axis
%
% INPUT
%   MHAList : cell-array M x N where every line has the following columns:
%               MHAList{i,1}: name of the proximal segment
%               MHAList{i,2}: name of the distal segment
%               MHAList{i,3}: this cell can be:
%                   string: name of the c3d file on which to perform the
%                   calculation;
%                   struct: structure containing two fields:
%                       name: name of the c3d file. In this case, FullPath
%                       will be used to locate c3d files to be loaded.
%                       data: struct containing axis data
%               MHAList{i,4}: name of the axis
%               HMAList{i,5}: name of the method to use. Available names:
%               'MHA' (Mean Helical Axis).
%   FullPath : full path of the folder in which the file indicated by 
%   MHAList{i,3} is located, if it is needed to (re)load it.
%
% OUTPUT:
%   MHA: same cell-array as in MHAList, but the following content is replaced:
%               MHA{i,3}: struct containing the following fields:
%                   name: name of the c3d file
%                   data: struct containing marker data
%               HMA{i,4}: struct containing the following fields:
%                   name: name of the functional axis reconstructed
%                   data: data related to axis position, orientation and
%                   reconstruction quality
%
% NOTES:
%   - Body model used to handle the C3D files in MHAList{:,3} has to be the
%   same as the body model used just before the call of this function.
%
% PROCESS
%   Calculation of the functional axis using kinematics about the
%   2 segments connected to the joints.
%   
% OUTPUT
%   GLOBAL BODY.SEGMENT(...).AnatomicalLandmark(...).ClusterFrameCoordinates

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Davide Monari, KUL, Leuven, Belgium. May 2012) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

% Push current global variables into globStruct
globStruct = PushGlobals();

% Initialize the list of the modified/added anatomical landmarks
AnatModifiedList = cell(size(MHAList,1),2);

% Cycle for every functional joint center
MHA = MHAList;
indSegs = [];
for i = 1 : size(MHAList,1)
    if ischar(MHAList{i,3})
        % Read C3D file
        [dummy,ParameterGroup,CollDate,CollTime] = BMimportULC3D_3_AUTO(MHAList{i,3},FullPath);
        freq = getparam(ParameterGroup, 'TRIAL', 'CAMERA_RATE');
    else
        % Recover marker data from the structure
        MARKER_DATA = getMarkersDataFromStruct(MHAList{i,3}.data.points,BODY.CONTEXT.MarkerLabels);
        freq = MHAList{i,3}.data.freq;
        MARKER_TIME_OFFSET = 0.;
        MARKER_TIME_GAIN = []; % unused
    end
    % Clear kinematics
    ClearKinematics('markers');
    % Assign the read marker to the BODY structure
    AssignMarkerDataToBody;
    % Search for proximal and distal segment
    IndSeg1 = strcmp({BODY.SEGMENT.Name},MHAList{i,1});
    IndSeg2 = strcmp({BODY.SEGMENT.Name},MHAList{i,2});
    % Create a cluster reference frame with an origin
    [R1,O1] = CreateFrameFromCluster(BODY.SEGMENT(IndSeg1).Cluster.KinematicsMarkers); % G_R_L, G_O 
    [R2,O2] = CreateFrameFromCluster(BODY.SEGMENT(IndSeg2).Cluster.KinematicsMarkers);
    % Calculate functional axes
    switch MHAList{i,5}
        case 'MHA'
            % Calculate IHA (in proximal reference frame)
            R1flat = zeros(size(R1,3),9);
            R2flat = zeros(size(R2,3),9);
            for t = 1 : size(R1,3)
                R1flat(t,:) = reshape(squeeze(R1(:,:,t)).',1,[]);   % flatten matrix (becomes a row)
                R2flat(t,:) = reshape(squeeze(R2(:,:,t)).',1,[]);   % flatten matrix (becomes a row)
            end
            %[N_IHA,V_IHA,S_IHA]=iha_rel_2(R1flat,R2flat,O1',O2',freq);
            [N_IHA, N_IHATotal, V_IHA, S_IHA, S_IHATotal, P_W_D, P_W_DTotal, nFrame, frameUsed] = IHA_REL_in(R1, O1', R2, O2', freq);
            % Remove nans from output structures 
            nanInd = isnan(N_IHA(:,1));
            N_IHA(nanInd,:) = [];
            S_IHA(nanInd,:) = [];           
            % Calculate MHA (in proximal reference frame)
            [nopt,sopt,deff,chi] = wolihapa(N_IHA',S_IHA');
            % Express MHA in global reference frame
            nopt_G = zeros(size(R2,3),3);
            sopt_G = zeros(size(R2,3),3);
            for t = 1 : size(R1,3)
                nopt_G(t,:) = ( R1(:,:,t) * nopt )';
                sopt_G(t,:) = ( R1(:,:,t) * sopt + O1(:,t) )';
            end
            % Pack the results
            FA.nopt = nopt_G;
            FA.sopt = sopt_G;
            FA.deff = deff;
            FA.chi = chi;
            % Add results to BODY
            if ~isfield(BODY.SEGMENT(IndSeg1), 'FunctionalAxis')
                j = 1;
            else
                j = length(BODY.SEGMENT(IndSeg1).FunctionalAxis) + 1;
            end
            BODY.SEGMENT(IndSeg1).FunctionalAxis(j).Name = MHAList{i,4};
            BODY.SEGMENT(IndSeg1).FunctionalAxis(j).Data.nopt = nopt;
            BODY.SEGMENT(IndSeg1).FunctionalAxis(j).Data.sopt = sopt;
        otherwise
            error(sprintf('BODYMECH:CalculateFunctionalAxis:Line %d in MHA List; MissingMethodError',i),'Method not implemented');
    end
    % Add the indices for all the involved segments 
    indSegs(end+1) = find(IndSeg1);
    % Create output variable
    if ischar(MHAList{i,3})
        MHA{i,3}.name = MHAList{i,3};
    else
        MHA{i,3}.name = MHAList{i,3}.name;
    end
    MHA{i,3}.data.points = AggregateAllPoints(struct(),'AnatomicalLandmarks');
    MHA{i,3}.data.points = AggregateAllPoints(MHA{i,3}.data.points,'TechnicalMarkers');
    MHA{i,3}.data.freq = freq;
    MHA{i,4}.name = MHAList{i,4};
    MHA{i,4}.data = FA;
end
indSegs = unique(indSegs);

% Save the temporary BODY structure
tempBODY = BODY;

% Pop the original global variables
PopGlobals(globStruct);

% Update the popped BODY structure
for i = 1 : length(indSegs)
    for j = 1 : length(tempBODY.SEGMENT(indSegs(i)).FunctionalAxis)
        BODY.SEGMENT(indSegs(i)).FunctionalAxis(j).Name = tempBODY.SEGMENT(indSegs(i)).FunctionalAxis(j).Name;
        BODY.SEGMENT(indSegs(i)).FunctionalAxis(j).Data = tempBODY.SEGMENT(indSegs(i)).FunctionalAxis(j).Data;
    end
end


















