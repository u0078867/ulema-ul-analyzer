%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function wantedInPar = ParseBodyModelFile(bmFile, command, staTok, parPos, stoTok)

% Search for all non-comment occurancies (in separate lines) of <command>
% and pick the input parameter in parPos-esim position. Start parsing input
% paramters after 'staTok' and before 'stoTok' characters

fid = fopen(which(bmFile));
wantedInPar = {};
while ~feof(fid)
    line = fgetl(fid);
    if ~isempty(line) && line(1) ~= '%'   % descard matlab comments
        [t,r] = strtok(line);   % 't' begins with a matlab command'
        ind = strfind(t, command);  
        if ~isempty(ind) && ind(1) == 1 % if 't' is the main command for that line
            sta = regexp(line,staTok);   % 'r' now is: '(....list of parameters...'
            r = line(sta+length(staTok):end);
            for i = 1 : parPos          % seeking for the correct parameter
                if i == 1
                    [par,r] = strtok(r,',');
                else
                    [par,r] = strtok(r(2:end),','); % (2:end) to descard ',' as first char of 'r'
                end
            end
            [par, r] = strtok(par,stoTok);
            if isempty(str2num(par)) || isnan(str2num(par))   % par is a string
                wantedInPar{end+1,1} = strrep(par,'''','');
            else                        % par is a number
                wantedInPar{end+1,1} = str2num(par);
            end
        end
    end
end
