%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [out, bestCyclesN] = getBestCycles(trials, context, phase, anglesList, bestCyclesN)

% Calculate the RMSE between every cycle and the mean of the other ones.
% Do this for every wanted angle. The total number of angles is 'M'.
% In the end, for every cycle, calculate the mean of the 'M' RMSEs.
% Select the best 'N' cycles and return theme

cyclesCont = 0;
% Picking up only the existing angles among the ones wanted
angleNames = {};
availableAngles = fieldnames(trials(1).cycles.(context)(1).data.anglesNorm.(phase));
for i = 1 : length(anglesList)
    if ~isempty(findc(availableAngles,anglesList{i}))
        angleNames{end+1,1} = anglesList{i};
    end
end
% Grouping all cycles angles data
for i = 1 : length(trials)
    for j = 1 : length(trials(i).cycles.(context))
        cyclesCont = cyclesCont + 1;
        for k = 1 : length(angleNames) % Only the existing among wanted angles
            allCyclesAngles(cyclesCont,:,k) = trials(i).cycles.(context)(j).data.anglesNorm.(phase).(angleNames{k});
        end
        cycles(cyclesCont).name = trials(i).cycles.(context)(j).name;
        cycles(cyclesCont).movingSide = trials(i).cycles.(context)(j).movingSide;
        cycles(cyclesCont).trial = trials(i).name;  
        cycles(cyclesCont).data.anglesCut = trials(i).cycles.(context)(j).data.anglesCut.(phase);
        cycles(cyclesCont).data.anglesNorm = trials(i).cycles.(context)(j).data.anglesNorm.(phase);
        cycles(cyclesCont).data.pointsCut = trials(i).cycles.(context)(j).data.pointsCut.(phase);
        cycles(cyclesCont).data.pointsNorm = trials(i).cycles.(context)(j).data.pointsNorm.(phase);
        cycles(cyclesCont).data.stParam = trials(i).cycles.(context)(j).data.stParam;
        cycles(cyclesCont).anglesForSelection = angleNames;
    end
end

% Calculating RMSE for every angle and every cycle
for i = 1 : size(allCyclesAngles,1) % cycle for every movement cycle
    indForMean = 1 : size(allCyclesAngles,1);
    indForMean(i) = [];
    for k = 1 : length(angleNames)
        meanAngle = mean(squeeze(allCyclesAngles(indForMean,:,k)),1);
        angle = squeeze(allCyclesAngles(i,:,k));
        perAngleRMSE(k,i) = RMSE(meanAngle, angle);
    end
end

% NOTE: perAngleRMSE is in the same format of Ellen Jaspers' Excel file.

% Meaning RMSE across all the angle
cycleRMSE = mean(perAngleRMSE,1);

% Finding the best cycles and returning them
[cycleRMSESorted, I] = sort(cycleRMSE);
bestCyclesN = min(bestCyclesN, length(I));
if length(I) < bestCyclesN
    fprintf('\n   Se: Number of cycles (%d) lower than number of best cycles wanted (%d) ...', length(I), bestCyclesN);
end
bestCyclesInd = I(1:bestCyclesN);

% Returning the copy of the best cycles
out.cycles = cycles(bestCyclesInd);

% Creating tabled data (i.e. for Excel/Calc)
for i = 1 : size(perAngleRMSE,2)
    cyNames{1,i} = ['Cycle ', num2str(i)];
end
out.formattedData.RMSETableForBestCycles = [{'Angles:'}, cyNames; angleNames, num2cell(perAngleRMSE)];




