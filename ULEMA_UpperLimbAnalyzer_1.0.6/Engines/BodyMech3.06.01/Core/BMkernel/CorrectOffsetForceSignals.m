%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function  CorrectOffsetForceSignals(ForceIndex,ForceThreshold)
% CORRECTOFFSETFORCESIGNALS [ BodyMech 3.06.01 ]: Correct for bias on all
% ForceSignals from BODY.CONTEXT.ExtrenalForce
% INPUT
%   Forceindex = 1 (when only one FP is used)
%   Global: BODY.CONTEXT.ExternalForce(1).Signals
%           BODY.CONTEXT.ExternalForce(1).TimeGain
%           BODY.CONTEXT.ExternalForce(1).TimeOffset
%           BODY.CONTEXT.ExternalForce(1).Type
% PROCESS
%   plots the external force signals and asks for indication of zero-force
%   level (= and - 0.5 seconds will used to calculate bias)
%   includes: correct for bias and elimination of too low forces (vertical only)
% OUTPUT
%   Global: corrected: BODY.CONTEXT.ExternalForce(1).Signals

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, December 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader
if nargin==0,
    ForceIndex=1;
    ForceThreshold=10;  % Threshold vertical force in Newton
elseif nargin==1
    ForceThreshold=10; % Threshold vertical force in Newton
end

if ~isempty(BODY.CONTEXT.ExternalForce),
    nForceSensors=size(BODY.CONTEXT.ExternalForce,2);  % # of ForcePlates used
    for ForceIndex=1:nForceSensors,
        ForceSensorType=BODY.CONTEXT.ExternalForce(ForceIndex).Type;
        ForceSensorChannel=BODY.CONTEXT.ExternalForce(ForceIndex).InputFileIndices;
        ForceSensorToLab=BODY.CONTEXT.ExternalForce(ForceIndex).ForceSensorToLab;
        ForceSensMatrix=BODY.CONTEXT.ExternalForce(ForceIndex).SensMatrix;
        TimeGain=BODY.CONTEXT.ExternalForce(ForceIndex).TimeGain;
        TimeOffset=BODY.CONTEXT.ExternalForce(ForceIndex).TimeOffset;

        Grf1=BODY.CONTEXT.ExternalForce(ForceIndex).MeasuredSignals;    %[Fx Fy Fz Mx My Mz]

        % correction for crosstalk
        if  ForceSensorType==4,
            Grf1=ForceSensMatrix*Grf1;
        end

        % plot ForceSignals
        figure(88),plot(Grf1(1:3,:)'),title('select one point for zero force')
        % manual:select zero-input time-window
        [xx,yy]=ginput(1);
        start=floor(xx(1)-0.1./TimeGain);  % +/- 0.1 seconde tov ginput index
        stop=ceil(xx(1)+0.1./TimeGain);
        close('88')

        % correct each forceplate channel for measured bias per channel
        for iB=1:size(Grf1,1),
            bias=mean(Grf1(iB,start:stop));
            Grf1(iB,:)=Grf1(iB,:)-bias;
            clear bias
        end

        % calculate COP aginn with corrected Forcesignals(in original forceplate coordinate system)

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

        % elimination of too low forces (Y-direction = vertical force only)
        for ii=1:size(Grf1,2);  % for all samples
            if Grf1(Y,ii) < ForceThreshold
                Grf1(:,ii)=NaN;
            end
        end


        %%%%%%%%%%%%%%%%%%
        % OUTPUT
        BODY.CONTEXT.ExternalForce(ForceIndex).Signals=Grf1;    % [N_CHANNELS N_SAMPLES]
    end
end

BodyMechFuncFooter

return
% ============================================
% END ### CorrectOffsetForceSignals ###
