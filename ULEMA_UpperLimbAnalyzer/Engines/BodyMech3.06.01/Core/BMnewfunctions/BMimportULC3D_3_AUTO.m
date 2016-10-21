%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [datafile,ParameterGroup,CollDate,CollTime]=BMimportULC3D_3_AUTO(datafile,datapath)
% BMIMPORTULC3D [ BodyMech 3.06.01 ]: Import measurement from C3D file
% voor het project Ellen Jaspers (leuven)
% INPUT
%   FileExtension
%   WindowHeader
% PROCESS
%   ## Read data from c3d file (Readc3d_mhs.m)
% OUTPUT
%   GLOBAL: MARKER_DATA
%           MARKER_TIME_OFFSET
%           MARKER_TIME_GAIN

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar & Ellen Jaspers , Faber - Leuven, 2007)
% $ Ver 1.1 Update (Davide Monari, Pellenberg Kliniek, Leuven, October 2011)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader
global IMPORT_C3D_DIR
% global ParameterGroup
% global MyLabelSequence

% if ~isempty(IMPORT_C3D_DIR),
%     cd(IMPORT_C3D_DIR);
% end
% if nargin < 2,
%     datapath=IMPORT_C3D_DIR;
% end
% 
% if nargin < 1,
%     WindowHeader='open C3D (Vicon) file';
%     FileExtension='*.c3d';
%     % == invoke the filebrowser
%     [datafile,datapath] = ...
%         uigetfile(FileExtension,WindowHeader);
% end

a = dir(fullfile(datapath,datafile));


if datafile ~= 0
    % == read the data from file

    [Markers,VideoFrameRate,AnalogSignals,AnalogFrameRate,Event,ParameterGroup,CameraInfo,ResidualError]=...
        readC3D_mhs(fullfile(datapath,datafile));
    Markers(Markers==0) = NaN;

    %groupnames = [ParameterGroup.name];         % array of strings of groupnames
    %pointindex = strcmp(groupnames, 'POINT');   % find the index for the 'POINT'group
    %parameternames = [ParameterGroup(pointindex).Parameter.name];
    %labelindex = strcmp(parameternames, 'LABELS');
    %LabelSequence = ParameterGroup(pointindex).Parameter(labelindex).data;   % array of strings markernames
    LabelSequence = getparam(ParameterGroup, 'POINT', 'LABELS');
% 
%     %   MyLabelSequence = {'UA1' 'UA2' 'UA3' 'UA4' 'LA1' 'LA2' 'LA3' 'LA4' 'H1' 'H2' 'H3' 'ACR1' 'ACR2' 'ACR3' 'ST1' 'ST2' 'ST3' 'CH1' 'CH2' 'CH3' 'P1' 'P2' 'P3' 'P4'};
%     %    %first MyLabelSequence is for data collected with workstation
% 
%         MyLabelSequence = {'UA1' 'UA2' 'UA3' 'UA4' 'LA1' 'LA2' 'LA3' 'LA4' 'ACR1' 'ACR2' 'ACR3' 'TR1' 'TR2' 'TR3' 'P1' 'P2' 'P3' 'P4'};
%         % second MyLabelSequence is for nexus

%         MyLabelSequence = {'LUA1' 'LUA2' 'LUA3' 'LUA4' 'LLA1' 'LLA2' 'LLA3' 'LLA4' 'LACR1' 'LACR2' 'LACR3' 'RUA1' 'RUA2' 'RUA3' 'RUA4' 'RLA1' 'RLA2' 'RLA3' 'RLA4' 'RACR1' 'RACR2' 'RACR3' 'ST1' 'ST2' 'ST3' 'P1' 'P2' 'P3' 'P4'};
    % Third  MyLabelSequence is for bilateral measurements
    
    % Fourth version: MyLabelSequence is automatically retrieved by the
    % field CONTEXT.MarkerLables in BODY global structure
      
    MyLabelSequence = BODY.CONTEXT.MarkerLabels;
    nMarkers=length(MyLabelSequence);
    [nDim, M, nFrames]  = size(Markers);
    MyMarkers = nan(nDim, length(MyLabelSequence), nFrames);
    for i = 1:nMarkers,
%        j = strmatch(MyLabelSequence{1,i},LabelSequence,'exact'); % captured in workstation
        j = strmatch_label(MyLabelSequence{i},LabelSequence); % nexus
        if length(j) == 2    % 2 instances, one with model name as prefix 
            if length(LabelSequence{j(1)}) > length(LabelSequence{j(2)})    % give priority to the name with the model prefix
                j = j(1);
            else
                j = j(2);
            end
        elseif length(j) > 2
            %error('the marker %s appears with different model name prefixes!', MyLabelSequence{i});
            j = j(1);   % just take the first one, supposing they are all have the same content
        end
        if sum(j) ~= 0
%             MyLabelSequence{i}
%             size(MyMarkers(:,i,:))
%             size(Markers(:,j,:))
            MyMarkers(:,i,:) = Markers(:,j,:);
%         elseif
%             MyMarkers(:,i,:) = 
        else
            MyMarkers(:,i,:) = ones(nDim,1,nFrames)*NaN;
        end
    end

    % MARKER_DATA=MyMarkers./1000; % mm. to m.
    MARKER_DATA=MyMarkers;
    MARKER_TIME_OFFSET=0.;
    MARKER_TIME_GAIN=1./VideoFrameRate;
    
    % --- Emulate a marker gap (for testing gap filler)
%     freq = getparam(ParameterGroup, 'TRIAL', 'CAMERA_RATE');
%     eventTimes = sort(getparam(ParameterGroup, 'EVENT', 'TIMES'));
%     if ~isempty(eventTimes)
%         eventFrames = sort(ceil(eventTimes(2,:) * freq));
%         N = 10; % Create a gap for N frames
%         gapFrames = eventFrames(1) : eventFrames(1) + N; 
%         MARKER_DATA(:,1,gapFrames) = NaN;
%     end
    % ---
    
    CollDate=a.date(1:11);
    CollTime=a.date(13:20);

    % [n_coordinates,n_markers,n_samples]=size(MARKER_DATA);

    % == set path for subsequent file-access
    IMPORT_C3D_DIR=datapath;

else
    return
end

BodyMechFuncFooter
return
% ============================================ 
%% END ## BMimportULC3D ##
