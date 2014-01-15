%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function data = getScores(data, refDataStruct, anglesList, logTransVS, VSName, PSName)

% Create the mean trajectory from the reference data
for i = 1 : length(refDataStruct)
    anglesData(i,:,:) = refDataStruct.cycles{i};
end
meanAngles = squeeze(mean(anglesData,1));

allRefCyclesNames = fieldnames(refDataStruct.rawData);

% Calculate (A/G)VS, (Arm/Gait) Value Score, for the current subject
for i = 1 : length(data.cycles) % cycle for each movement cycle
    for j = 1 : length(anglesList) % cycle for every angle
        data.cycles(i).data.scores.(VSName){j,1} = anglesList{j};
        data.cycles(i).data.scores.(VSName){j,2} = RMSE(data.cycles(i).data.anglesNorm.(anglesList{j})', meanAngles(j,:));
        % Log-transform is requested
        if logTransVS == 1
            data.cycles(i).data.scores.(VSName){j,3} = log(data.cycles(i).data.scores.(VSName){j,2});
        end
    end
    % Calculate (A/G)PS, (Arm/Gait) Profile Score
    data.cycles(i).data.scores.(PSName) = RMSE(cell2mat(data.cycles(i).data.scores.(VSName)(:,2)) , zeros(length(anglesList),1));
end

% Calculate (A/G)VS, (Arm/Gait) Value Score, for all the reference cycles in the normal database
% The structure 'data' is replicated and called 'refData'
for i = 1 : length(allRefCyclesNames) % cycle for each movement cycle
    for j = 1 : length(anglesList) % cycle for every angle
        refData.cycles(i).data.scores.(VSName){j,1} = anglesList{j};
        if isfield(refDataStruct.rawData.(allRefCyclesNames{i}), anglesList{j})
            angleName = anglesList{j};
            refData.cycles(i).data.scores.(VSName){j,2} = RMSE(refDataStruct.rawData.(allRefCyclesNames{i}).(angleName), meanAngles(j,:));
        else
            if anglesList{j}(1) == 'R'
                angleName = ['L',anglesList{j}(2:end)];
            else
                angleName = ['R',anglesList{j}(2:end)];
            end
            refData.cycles(i).data.scores.(VSName){j,2} = RMSE(refDataStruct.rawData.(allRefCyclesNames{i}).(angleName), meanAngles(j,:));          
        end
        % Log-transform is requested
        if logTransVS == 1
            refData.cycles(i).data.scores.(VSName){j,3} = log(refData.cycles(i).data.scores.(VSName){j,2});
        end
    end
    % Calculate (A/G)PS, (Arm/Gait) Profile Score
    refData.cycles(i).data.scores.(PSName) = RMSE(cell2mat(refData.cycles(i).data.scores.(VSName)(:,2)) , zeros(length(anglesList),1));
end

% Create formatted data for VS and PS
for i = 1 : length(data.cycles) % cycle for each movment cycle
    data.formattedData.RMSETableVSPerCycle{i} = [{'Angles:',['Raw ',VSName]}; data.cycles(i).data.scores.(VSName)(:,1:2)];
    data.formattedData.RMSETableVSPerCycle{i} = [data.formattedData.RMSETableVSPerCycle{i}; [{'PS'},{data.cycles(i).data.scores.(PSName)}]];
    if logTransVS == 1
        data.formattedData.RMSETableVSPerCycle{i} = [data.formattedData.RMSETableVSPerCycle{i}, [{['ln(',VSName,')']}; data.cycles(i).data.scores.(VSName)(:,3); {log(data.cycles(i).data.scores.(PSName))}]];  
    end
end

% Calculate mean and std.dev of VSs along the movement cycles (current subjects)
% for each angle (Only for log-tansformed option on)
if logTransVS == 1
    for j = 1 : length(anglesList)
        VSvalues = [];
        for i = 1 : length(data.cycles)
            VSvalues = [VSvalues, data.cycles(i).data.scores.(VSName){j,3}];    % this is the value already log-transformed
        end
        RMSE_VSPerAngle(1,j) = mean(VSvalues);
        RMSE_VSPerAngle(2,j) = std(VSvalues);
    end
    % Append mean and std.dev. for PS
    PSvalues = [];
    for i = 1 : length(data.cycles)
        PSvalues = [PSvalues, log(data.cycles(i).data.scores.(PSName))];
    end
    RMSE_VSandPSPerAngle = [RMSE_VSPerAngle, [mean(PSvalues);std(PSvalues)]];

    % Create formatted data for mean and atd dev of VSs and PS along the movement cycles, for each angle
    data.formattedData.RMSETableVSandPSPerAngle = [{''}, anglesList', {PSName}; {'Mean';'StdDev'}, num2cell(RMSE_VSandPSPerAngle)];
end

% Calculate mean and std.dev of VSs along the movement cycles (all reference cycles)
% for each angle (Only for log-tansformed option on)
if logTransVS == 1
    for j = 1 : length(anglesList)
        refVSvalues = [];
        for i = 1 : length(refData.cycles)
            refVSvalues = [refVSvalues, refData.cycles(i).data.scores.(VSName){j,3}];    % this is the value already log-transformed
        end
        refRMSE_VSPerAngle(1,j) = mean(refVSvalues);
        refRMSE_VSPerAngle(2,j) = std(refVSvalues);
    end
    % Append mean and std.dev. for PS
    refPSvalues = [];
    for i = 1 : length(refData.cycles)
        refPSvalues = [refPSvalues, log(refData.cycles(i).data.scores.(PSName))];
    end
    refRMSE_VSandPSPerAngle = [refRMSE_VSPerAngle, [mean(refPSvalues);std(refPSvalues)]];
end

% Create the (A/G)-MAP table, for current subject
for j = 1 : length(anglesList) + 1
    if logTransVS == 1
        lnMAP(1,j) = exp(RMSE_VSandPSPerAngle(1,j));
        lnMAP(2,j) = exp(RMSE_VSandPSPerAngle(1,j)+0.67*RMSE_VSandPSPerAngle(2,j))-lnMAP(1,j);
        lnMAP(3,j) = lnMAP(1,j)-exp(RMSE_VSandPSPerAngle(1,j)-0.67*RMSE_VSandPSPerAngle(2,j));
    end
    MAP(1,j) = RMSE_VSandPSPerAngle(1,j);
    MAP(2,j) = 0.67*RMSE_VSandPSPerAngle(2,j);
    MAP(3,j) = -0.67*RMSE_VSandPSPerAngle(2,j);
end

% Create the (A/G)-MAP table, for all reference cycles
for j = 1 : length(anglesList) + 1
    if logTransVS == 1
        ref_lnMAP(1,j) = exp(refRMSE_VSandPSPerAngle(1,j));
        ref_lnMAP(2,j) = exp(refRMSE_VSandPSPerAngle(1,j)+0.67*refRMSE_VSandPSPerAngle(2,j))-ref_lnMAP(1,j);
        ref_lnMAP(3,j) = ref_lnMAP(1,j)-exp(refRMSE_VSandPSPerAngle(1,j)-0.67*refRMSE_VSandPSPerAngle(2,j));
    end
    refMAP(1,j) = refRMSE_VSandPSPerAngle(1,j);
    refMAP(2,j) = 0.67*refRMSE_VSandPSPerAngle(2,j);
    refMAP(3,j) = -0.67*refRMSE_VSandPSPerAngle(2,j);
end

% Create formatted data for the MAP (raw and with logarithms), current subject
data.formattedData.MAPTable = [{'MAP'},anglesList',{PSName}; {'Median';'IQR+';'IQR-'}, num2cell(MAP)];
data.formattedData.lnMAPTable = [{'MAP'},anglesList',{PSName}; {'Median';'IQR+';'IQR-'}, num2cell(lnMAP)];

% Create formatted data for the MAP (raw and with logarithms), reference cycles
refMAPTable = [{'MAP'},anglesList',{PSName}; {'Median';'IQR+';'IQR-'}, num2cell(refMAP)];
ref_lnMAPTable = [{'MAP'},anglesList',{PSName}; {'Median';'IQR+';'IQR-'}, num2cell(ref_lnMAP)];

% Append to the MAP table the one relative to all reference subjects
data.formattedData.MAPTable = [data.formattedData.MAPTable; refMAPTable(2:end,:)];
data.formattedData.lnMAPTable = [data.formattedData.lnMAPTable; ref_lnMAPTable(2:end,:)];






