%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function bestCyclesMerged = mergeBestCycles(bestCyclesCache)

if isempty(bestCyclesCache)
    bestCyclesMerged = [];
    return;
end
bestCyclesMerged = bestCyclesCache{1};
for k = 1 : length(bestCyclesCache)
    tasks = fieldnames(bestCyclesCache{k});
    for ta = 1 : length(tasks)
        if isfield(bestCyclesMerged, tasks{ta})
            contexts = fieldnames(bestCyclesCache{k}.(tasks{ta}));
            for co = 1 : length(contexts)
                if isfield(bestCyclesMerged.(tasks{ta}), contexts{co})
                    phases = fieldnames(bestCyclesCache{k}.(tasks{ta}).(contexts{co}));
                    for ph = 1 : length(phases)
                        bestCyclesMerged.(tasks{ta}).(contexts{co}).(phases{ph}) = bestCyclesCache{k}.(tasks{ta}).(contexts{co}).(phases{ph}); % this could be also an overwriting
                    end
                else
                    bestCyclesMerged.(tasks{ta}).(contexts{co}) = bestCyclesCache{k}.(tasks{ta}).(contexts{co});
                end
            end
        else
            bestCyclesMerged.(tasks{ta}) = bestCyclesCache{k}.(tasks{ta});
        end
    end
end

