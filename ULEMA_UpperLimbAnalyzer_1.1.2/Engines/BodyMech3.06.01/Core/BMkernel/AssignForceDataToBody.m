%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function   AssignForceDataToBody(ForceIndex,ForceThreshold)
% ASSIGNFORCEDATATOBODY [ BodyMech 3.06.01 ]: Assigns measured data in the BODY.CONTEXT-fields
% INPUT
%   ForceThreshold (optional) in Newton
%   Global: ANSIGNAL_DATA
%           ANSIGNAL_TIME_GAIN
%           ANSIGNAL_TIME_OFFSET
%           BODY.CONTEXT.ExternalForce(1).Type
%           BODY.CONTEXT.ExternalForce(1).InputFileIndices
%           BODY.CONTEXT.ExternalForce(1).ForceSensorToLab
% PROCESS
%   breaks up external force data and assigns it according to current BODYdefinition
%   Transforms all data to the laboratory frame
% OUTPUT
%   Global: BODY.CONTEXT.ExternalForce(1).MeasuredSignals
%           BODY.CONTEXT.ExternalForce(1).Signals
%           BODY.CONTEXT.ExternalForce(1).TimeGain
%           BODY.CONTEXT.ExternalForce(1).TimeOffset

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, December 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader

% in case of more force plates:
% NumForceSensors=length(BODY.CONTEXT.ExternalForce);
% if NumForceSensors~=0
% for ForceIndex=1:NumForceSensors,

if nargin==0,
    ForceIndex=1;
    ForceThreshold=10;  % Threshold vertical force in Newton
elseif nargin==1
    ForceThreshold=10; % Threshold vertical force in Newton
end

if ~isempty(BODY.CONTEXT.ExternalForce)
    nForceSensors=size(BODY.CONTEXT.ExternalForce,2); % # of ForcePlates used
    for ForceIndex=1:nForceSensors,
        ForceSensorType=BODY.CONTEXT.ExternalForce(ForceIndex).Type;
        ForceSensorChannel=BODY.CONTEXT.ExternalForce(ForceIndex).InputFileIndices;
        ForceSensorToLab=BODY.CONTEXT.ExternalForce(ForceIndex).ForceSensorToLab;
        ForceSensMatrix=BODY.CONTEXT.ExternalForce(ForceIndex).SensMatrix;
        TimeGain = ANSIGNAL_TIME_GAIN;
        TimeOffset = ANSIGNAL_TIME_OFFSET;

        Grf1=ANSIGNAL_DATA(:,ForceSensorChannel);


        % correction for crosstalk
        if  ForceSensorType==4,
            Grf1=ForceSensMatrix*Grf1;
        end

        %transpose to [Dim SampleIndex]
        Grf1=Grf1';
        GrfMeasured=Grf1;

        % % %     % elimination of too low forces (vertical only)
        % % %     for ii=1:size(Grf1,2);
        % % %         if Grf1(Z,ii) < ForceThreshold
        % % %             Grf1(Z,ii)=NaN;
        % % %         end
        % % %     end

        % calculate COP (in original forceplate coordinate system)

        if ForceSensorType==2 |  ForceSensorType==4,
            COPx=Grf1(5,:)./-Grf1(Z,:); % COPx=-My/Fz
            COPy=Grf1(4,:)./Grf1(Z,:); % COPy=Mx/Fz
            COP=[COPx ; COPy ; zeros(size(COPx))];
        end

        Grf1(6,:) = Grf1(6,:) - Grf1(2,:).*COPx + Grf1(1,:).*COPy; % Mkz = Mz - Fy.*Ax + Fx.*Ay;

        % transform to lab coordinate system
        COP=transform(ForceSensorToLab,COP);

        Grf1(4,:)=COP(1,:); % COP(X,Z) in meters.
        Grf1(5,:)=COP(3,:); %

        % ground reaction force = minus  measured force
        Grf1(1:3,:)=ForceSensorToLab(1:3,1:3)*-Grf1(1:3,:);

        % OUTPUT
        BODY.CONTEXT.ExternalForce(ForceIndex).Signals=Grf1;    % [N_CHANNELS N_SAMPLES]
        BODY.CONTEXT.ExternalForce(ForceIndex).MeasuredSignals=GrfMeasured;  % [N_CHANNELS N_SAMPLES]
        BODY.CONTEXT.ExternalForce(ForceIndex).TimeGain = ANSIGNAL_TIME_GAIN;
        BODY.CONTEXT.ExternalForce(ForceIndex).TimeOffset = ANSIGNAL_TIME_OFFSET;
    end
end

BodyMechFuncFooter
return
% ============================================
% END ### AssignForceDataToBody ###
