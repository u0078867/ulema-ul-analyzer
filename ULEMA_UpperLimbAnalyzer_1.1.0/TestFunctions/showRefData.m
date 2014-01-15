%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function showRefData(RefData)

clc

% Show reference data file content, after loading it in the workspace

f = figure(1000);

task = 'RU';
phase = 'Phase1';
angle = 'H1FRONT_Abduction';

cycleNames = fieldnames(RefData.tasks.(task).(phase).angles.rawData);
hold on;
for i = 1 : length(cycleNames)
    x = 1 : 101;
    angleNames = fieldnames(RefData.tasks.(task).(phase).angles.rawData.(cycleNames{i}));
    idx = ~cellfun(@isempty,strfind(angleNames,angle));
    y = RefData.tasks.(task).(phase).angles.rawData.(cycleNames{i}).(angleNames{idx});
    p = plot(x,y);
    title(angle);
    displayName = [...
        RefData.tasks.(task).(phase).sources.(cycleNames{i}).subject, ', ', ...
        RefData.tasks.(task).(phase).sources.(cycleNames{i}).trial, ', ', ...
        RefData.tasks.(task).(phase).sources.(cycleNames{i}).cycle, ...
        ];
    set(p,'DisplayName',displayName);
end

dcm_obj = datacursormode(f);
set(dcm_obj,'UpdateFcn',@myupdatefcn);

function txt = myupdatefcn(empt,event_obj)
txt = get(get(event_obj,'Target'),'DisplayName');
end
      
end





