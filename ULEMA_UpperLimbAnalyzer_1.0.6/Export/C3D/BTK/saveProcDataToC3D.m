%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function saveProcDataToC3D(trial, inpath, outpath)

% Open original C3D
h = btkReadAcquisition(inpath);

% Writing markers (only anatomical landmarks)
% pn = fieldnames(btkGetPoints(h));
if trial.version <= 2
    fn = fieldnames(trial.data.points);
else
    fn = trial.data.ALsList;
end
for i = 1 : length(fn)
%     found = 0;
%     for j = 1 : length(pn)
%         if strcmp(fn{i},pn{j})
%             found = true;
%             break;
%         end
%     end
%     if found == 1
%         btkRemovePoint(h, fn{i});
%     end
    currPoint = trial.data.points.(fn{i});
    try
        btkAppendPoint(h, 'marker', fn{i}, currPoint);
    catch
        btkSetPoint(h, fn{i}, currPoint);
    end
end

% Writing angles
fn = fieldnames(trial.data.angles);
for i = 1 : length(fn)
    % Get the raw angle
    currAngle = [trial.data.angles.(fn{i}) zeros(length(trial.data.angles.(fn{i})),2)];
    % Remove data before first event and last event in the file, to avoid
    % bad data parsing from Vicon Polygon
    eventsTime = trial.data.stParam.eventsRaw.eventTime;
    kineFreq = trial.data.kineFreq;
    ev1 = min(eventsTime);
    ev2 = max(eventsTime);
    fr1 = round(ev1 * kineFreq);
    fr2 = round(ev2 * kineFreq);
    safetyFrames = 2;
    currAngle(1:fr1-safetyFrames,:) = 0;
    currAngle(fr2+safetyFrames:end,:) = 0;
    try
        btkAppendPoint(h, 'angle', fn{i}, currAngle);
    catch
        btkSetPoint(h, fn{i}, currAngle);
    end
end


% Writing spatio-temporal parameters for the cycles, if cycles are present,
% in the ANALYSIS section, so that they readable by Polygon.
USED.format = 'Integer';
USED.values = [];

NAMES.format = 'Char';
NAMES.values = {};

SUBJECTS.format = 'Char';
SUBJECTS.values = {};

CONTEXTS.format = 'Char';
CONTEXTS.values = {};

UNITS.format = 'Char';
UNITS.values = {};

DESCRIPTIONS.format = 'Char';
DESCRIPTIONS.values = {};

VALUES.format = 'Real';
VALUES.values = [];

if isfield(trial, 'cycles')
    if isfield(trial.cycles, 'Merged')
        trial.cycles = rmfield(trial.cycles,'Merged');
    end
    contexts = fieldnames(trial.cycles);
    % Read the name of the subjects
    metaData = btkGetMetaData(h);
    subName = metaData.children.SUBJECTS.children.NAMES.info.values{1};
    % Cycle for every parameter
    for co = 1 : length(contexts)
        for cy = 1 : length(trial.cycles.(contexts{co}))
            mkrs = fieldnames(trial.cycles.(contexts{co})(cy).data.stParam.timing);
            for m = 1 : length(mkrs)
                phases = fieldnames(trial.cycles.(contexts{co})(cy).data.stParam.timing.(mkrs{m}));
                for p = 1 : length(phases)
                    % timing
                    if ~isempty(trial.cycles.(contexts{co})(cy).data.stParam.timing.(mkrs{m}).(phases{p})) && ...
                       ~isnan(trial.cycles.(contexts{co})(cy).data.stParam.timing.(mkrs{m}).(phases{p}).duration)
                        pn = fieldnames(trial.cycles.(contexts{co})(cy).data.stParam.timing.(mkrs{m}).(phases{p}));
                        for i = 1 : length(pn)  
                            NAMES.values{end+1,1} = [contexts{co}, '_', trial.cycles.(contexts{co})(cy).name, '_', mkrs{m}, '_', phases{p}, '_', pn{i}];
                            SUBJECTS.values{end+1,1} = subName;
                            CONTEXTS.values{end+1,1} = contexts{co};
                            DESCRIPTIONS.values{end+1,1} = '';
                            VALUES.values(end+1,1) = trial.cycles.(contexts{co})(cy).data.stParam.timing.(mkrs{m}).(phases{p}).(pn{i});
                            switch pn{i}
                                case 'duration'
                                    UNITS.values{end+1,1} = 's';
                                case 'percentageTiming'
                                    UNITS.values{end+1,1} = '%';
                                case 'timeVmax'
                                    UNITS.values{end+1,1} = '%';
                            end
                        end
                    end
                    % speed
                    if ~isempty(trial.cycles.(contexts{co})(cy).data.stParam.speed.(mkrs{m}).(phases{p})) && ...
                       ~isnan(trial.cycles.(contexts{co})(cy).data.stParam.speed.(mkrs{m}).(phases{p}).Vmax)
                        pn = fieldnames(trial.cycles.(contexts{co})(cy).data.stParam.speed.(mkrs{m}).(phases{p}));
                        for i = 1 : length(pn)  
                            NAMES.values{end+1,1} = [contexts{co}, '_', trial.cycles.(contexts{co})(cy).name, '_', mkrs{m}, '_', phases{p}, '_', pn{i}];
                            SUBJECTS.values{end+1,1} = subName;
                            CONTEXTS.values{end+1,1} = contexts{co};
                            DESCRIPTIONS.values{end+1,1} = '';
                            VALUES.values(end+1,1) = trial.cycles.(contexts{co})(cy).data.stParam.speed.(mkrs{m}).(phases{p}).(pn{i});
                            UNITS.values{end+1,1} = 'mm/s';
                        end
                    end
                    % trajectory
                    if ~isempty(trial.cycles.(contexts{co})(cy).data.stParam.trajectory.(mkrs{m}).(phases{p})) && ...
                       ~isnan(trial.cycles.(contexts{co})(cy).data.stParam.trajectory.(mkrs{m}).(phases{p}).trajectory)
                        pn = fieldnames(trial.cycles.(contexts{co})(cy).data.stParam.trajectory.(mkrs{m}).(phases{p}));
                        for i = 1 : length(pn)
                            NAMES.values{end+1,1} = [contexts{co}, '_', trial.cycles.(contexts{co})(cy).name, '_', mkrs{m}, '_', phases{p}, '_', pn{i}];
                            SUBJECTS.values{end+1,1} = subName;
                            CONTEXTS.values{end+1,1} = contexts{co};
                            DESCRIPTIONS.values{end+1,1} = '';
                            VALUES.values(end+1,1) = trial.cycles.(contexts{co})(cy).data.stParam.trajectory.(mkrs{m}).(phases{p}).(pn{i});
                            UNITS.values{end+1,1} = '';
                        end
                    end
                    % min, max, start and end values
%                     angleNames = fieldnames(trial.cycles.(contexts{co})(cy).data.stParam.valuesInTime);
%                     if ~isempty(trial.cycles.(contexts{co})(cy).data.stParam.valuesInTime.(angleNames{1}).(phases{p}))
%                         for i = 1 : length(angleNames)
%                             valueTypes = fieldnames(trial.cycles.(contexts{co})(cy).data.stParam.valuesInTime.(angleNames{i}).(phases{p}));
%                             for v = 1 : length(valueTypes)
%                                 NAMES.values{end+1,1} = [contexts{co}, '_', trial.cycles.(contexts{co})(cy).name, '_', angleNames{i}, '_', phases{p}, '_', valueTypes{v}];
%                                 SUBJECTS.values{end+1,1} = subName;
%                                 CONTEXTS.values{end+1,1} = contexts{co};
%                                 DESCRIPTIONS.values{end+1,1} = '';
%                                 VALUES.values(end+1,1) = trial.cycles.(contexts{co})(cy).data.stParam.valuesInTime.(angleNames{i}).(phases{p}).(valueTypes{v});
%                                 UNITS.values{end+1,1} = 'deg'; 
%                             end
%                         end
%                     end
                end
            end
        end
    end
end

% try
    % Writing data to c3d
    USED.values = length(NAMES.values);
    btkAppendMetaData(h, 'ANALYSIS', 'USED', USED);
    btkAppendMetaData(h, 'ANALYSIS', 'NAMES', NAMES);
    btkAppendMetaData(h, 'ANALYSIS', 'SUBJECTS', SUBJECTS);
    btkAppendMetaData(h, 'ANALYSIS', 'CONTEXTS', CONTEXTS);
    btkAppendMetaData(h, 'ANALYSIS', 'UNITS', UNITS);
    btkAppendMetaData(h, 'ANALYSIS', 'DESCRIPTIONS', DESCRIPTIONS);
    btkAppendMetaData(h, 'ANALYSIS', 'VALUES', VALUES);
% catch
%     fprintf('\n\nAn error occured. Probably the number of parameters is greater than 255!\n\n');
% end
 
% Saving file
btkWriteAcquisition(h, outpath);

% Freeing memory
btkDeleteAcquisition(h);



