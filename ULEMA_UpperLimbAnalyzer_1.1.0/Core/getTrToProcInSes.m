%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [sesHasNonProcTr, sesPath] = getTrToProcInSes(trials)

sesHasNonProcTr = 0;
sesPath = [];
for k = 1 : length(trials)
    neverProc = ~isfield(trials(k),'data') || isempty(trials(k).data);
    if neverProc == 1
        sesHasNonProcTr = 1;
        [sesPath,dummy1,dummy2] = fileparts(trials(k).path);
        return;
    end
end

