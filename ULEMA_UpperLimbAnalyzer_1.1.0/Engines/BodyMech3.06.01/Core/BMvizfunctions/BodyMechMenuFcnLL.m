%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function BodyMechMenuFcn(FunctionDescription)
% BODYMECHMENUFCN [ BodyMech 3.06.01 ]: calling interface to common BodyMech functions from the menu system
% INPUT
%       FunctionDescription: character string
%       this string must be (case sensitive!) identical to the used
%       callback string-variable in the menu system (via BodyMechControlWindow.m)
% PROCESS
%       calls the appropiate BodyMech function
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, December 1999) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

% initialisation

% INPUT checks
if nargin==0
    errordlg({'BodyMechMenuFcn';...
        'no menucommand'},...
        '** BODYMECH ERROR **')
    return

    % #############
    % ## BUTTONS ##
    % #############

elseif strcmp(FunctionDescription,'list_body_model'),
    ListBodyModel;

elseif strcmp(FunctionDescription,'load_bmb'),
    LoadBodyFile;
    global BODY
    ListBodyModel;

elseif strcmp(FunctionDescription,'kinematic_window'),
    h=findobj('Tag','OrthoDisplay');
    if isempty(h),
        OrthoView([-1400 1400 0 2000 -600 600]);
        VIZ.ORTHOMODE=[0 0 0 0 0 0 0 0];
        VIZ.ORTHOHANDLE=ones(1,3,1);
    else
        figure(h);
    end

    % ##################
    % ## menu PROJECT ##
    % ##################

elseif strcmp(FunctionDescription,'load_project_file')
    LoadBodyFile;
    global BODY
   
    % start with ProjectModel
elseif strcmp(FunctionDescription,'edit_newprojectmodel')
    EditNewProjectModel

elseif strcmp(FunctionDescription,'run_projectmodel')
    RunProjectModel    % run BodyDefinitionFunction
    ListBodyModel;

    %% TODO
    % edit AnatCalcFucntion from template
elseif strcmp(FunctionDescription,'edit_newanatcalcfunction')
    EditNewAnatCalcFunction

elseif strcmp(FunctionDescription,'run_projectmodel')
    RunProjectModel    % run BodyDefinitionFunction
    ListBodyModel;

elseif strcmp(FunctionDescription,'clear_all')
    InitBodyMech;

elseif strcmp(FunctionDescription,'update_projectheader')
    UpdateBodyHeader('Project');

elseif strcmp(FunctionDescription,'save_projectmodel')
    if exist('BODY')==1,
        BODY.HEADER.ModelType = '<Project>';
        SaveAsBodyFile;
    end

    % ##################
    % ## menu SESSION ##
    % ##################

elseif strcmp(FunctionDescription,'load_session_file')
    LoadBodyFile;
    global BODY

elseif strcmp(FunctionDescription,'clear_session')
   ClearSessionModel;
  
elseif strcmp(FunctionDescription,'update_sessionheader')
    UpdateBodyHeader('Session');

elseif strcmp(FunctionDescription,'import_static_trial')
    NDFile=BMimportNdf;
    if NDFile ~= 0,
        ClearKinematics('markers');
        AssignMarkerDataToBody;
        BODY.HEADER.Session.MarkerDataFile=NDFile;
    end

elseif strcmp(FunctionDescription,'define_markerclusters')
    DefineLocalClusterFrames;

elseif strcmp(FunctionDescription,'define_referenceposture')
    RecordReferencePose;

elseif strcmp(FunctionDescription,'define_anatomical_marks')
    ProbeAnatomy;


elseif strcmp(FunctionDescription,'save_sessionmodel')
    if exist('BODY')==1,
        BODY.HEADER.ModelType = '<Session>' ;
        SaveAsBodyFile;
    end


    % ################
    % ## menu TRIAL ##
    % ################

elseif strcmp(FunctionDescription,'load_trial_file')
    LoadBodyFile;
    global BODY
    if isfield(BODY.HEADER,'version'),
        if strcmp(BODY.HEADER.version,'1.1');
            msgbox('The old 1.1 definition is converted to 2.0','BodyMech Message');
            updateBMdef;
        end
        if strcmp(BODY.HEADER.version,'2.0') | strcmp(BODY.HEADER.version,'1.2');
            msgbox('The old 1.2 / 2.0 definition is converted to 3.0','BodyMech Message');
            Convert2summerversion;  % i.e the summer of 2004
        end
    end

elseif strcmp(FunctionDescription,'clear_trial')
      ClearTrialModel   

elseif strcmp(FunctionDescription,'update_trialheader')
    UpdateBodyHeader('Trial');

elseif strcmp(FunctionDescription,'import_NDF')
    NDFile=BMimportNdf;
    if NDFile ~= 0,
        ClearKinematics('markers');
        AssignMarkerDataToBody;
        BODY.HEADER.Trial.MarkerDataFile=NDFile;
    end

elseif strcmp(FunctionDescription,'import_MDF')
    MDFile = BMimportMdf;
    if MDFile ~= 0
        BODY.HEADER.Trial.AnalogDataFile=MDFile;
        AssignForceDataToBody; % optional input [ForceIndex, ForceThreshold]; default: ForceIndex=1; Threshold =10;
        AssignEmgEnvelopeDataToBody;
    end

elseif strcmp(FunctionDescription,'import_C3D')
    % TODO
    %        C3Dfile = BMimportC3D;
    %        if C3Dfile ~= 0
    %            BODY.HEADER.AnalogDataFile=C3Dfile;
    %            ClearKinematics('markers');
    %            AssignMarkerDataToBody;
    %            AssignForceDataToBody;
    %            AssignEmgEnvelopeDataToBody;
    %            UpdateBodyHeader('Trial');
    %        end

elseif strcmp(FunctionDescription,'import_ASCII')
    % TODO
    %        ASCIIfile = BMimportASCII;
    %        if ASCIIfile ~= 0
    %            BODY.HEADER.AnalogDataFile=ASCIIfile;
    %            AssignForceDataToBody;
    %            AssignEmgEnvelopeDataToBody;
    %            UpdateBodyHeader('Trial');
    %        end

elseif strcmp(FunctionDescription,'import_TMS')
    TMSfile = BMimportTMS;
    if TMSfile ~= 0
        BODY.HEADER.Trial.AnalogDataFile=TMSfile;
        AssignEmgRawAndEnvelopeToBody;
    end

elseif strcmp(FunctionDescription,'import_DAR')
    BODY.HEADER.Trial.OTfileID='n.i.';
    DARfile = BMimportDAR;
    if DARfile ~= 0
        BODY.HEADER.Trial.AnalogDataFile=DARfile;
        AssignForceDataToBody;
        AssignEmgRawAndEnvelopeToBody;
    end

elseif strcmp(FunctionDescription,'CorrectForceOffset')
        % select ForceIndex for sequential FP used (e.g. ForceIndex=1 for
        % 1st Forceplate used) and use as input e.g.  % CorrectOffsetForceSignals(ForceIndex);
        CorrectOffsetForceSignals;  % default ForceIndex = 1
   
elseif strcmp(FunctionDescription,'kinematicscalculation')

    InterpolateMarkerKinematics;

    for Si=1:length(BODY.SEGMENT), % for each segment
        if ~isempty( BODY.SEGMENT(Si).Name),
            CalculateClusterKinematics(Si);  %  eq.10
        end
    end
    CalculatePostureRefKinematics;
    CalculateVirtualMarkers;
    CalculateDefaultStickFigure;
    CalculateJointKinematics('ReferenceBased');

elseif strcmp(FunctionDescription,'save_trialmodel')
    if exist('BODY')==1,
        BODY.HEADER.ModelType = '<Trial>';
        SaveAsBodyFile;
    end


    % #####################################
    % ## MENU KinematicscalculationSteps ##
    % #####################################

elseif strcmp(FunctionDescription,'selectmarkerkinematics')
    SelectMarkerKinematics;

elseif strcmp(FunctionDescription,'interpolatemarkers')
    InterpolateMarkerKinematics;

elseif strcmp(FunctionDescription,'calculate_clusterkinematics')
    % calculate cluster kinematics

    for Si=1:length(BODY.SEGMENT), % for each segment
        if ~isempty( BODY.SEGMENT(Si).Name),
            CalculateClusterKinematics(Si);  %  eq.10
        end
    end

elseif strcmp(FunctionDescription,'kinematics_posture_referenced')
    % segment kinematics relative to reference position
    CalculatePostureRefKinematics;

elseif strcmp(FunctionDescription,'virtualmarks')
    CalculateVirtualMarkers;

elseif strcmp(FunctionDescription,'stickfigure')
    CalculateDefaultStickFigure;

elseif strcmp(FunctionDescription,'kinematics_anatomy_referenced')
    CalculateAnatomicalKinematics;

elseif strcmp(FunctionDescription,'joint_kinematics_anatomy_ref')
    CalculateJointKinematics('AnatomyBased');

elseif strcmp(FunctionDescription,'joint_kinematics_posture_ref')
    CalculateJointKinematics('ReferenceBased');


    % ###############
    % ## MENU View ##
    % ###############

elseif strcmp(FunctionDescription,'Orthogonal_display')
    h=findobj('Tag','OrthoDisplay');
    if isempty(h),
        OrthoView([-1400 1400 0 2000 -600 600]);
        VIZ.ORTHOMODE=[0 0 0 0 0 0 0 0];
        VIZ.ORTHOHANDLE=ones(1,3,1);
    else
        figure(h);
    end

elseif strcmp(FunctionDescription,'GraphMarkers')
    GraphMarkers;

elseif strcmp(FunctionDescription,'graph_joint_kinematics')
    GraphJointAngles;

elseif strcmp(FunctionDescription,'graph_joint_moments')
    GraphNetMoments

elseif strcmp(FunctionDescription,'graph_SRE')
    GraphSRE

elseif strcmp(FunctionDescription,'graph_Raw_EMG')
    GraphRawEmg

elseif strcmp(FunctionDescription,'graph_force')
    GraphForceSignals
else
    errordlg({'BodyMechMenuFcn';...
        'unknown menucommand'},...
        '** BODYMECH ERROR **')

    return
end

ListBodyModel

% ============================================
% END ### BodyMechMenuFcn ###
