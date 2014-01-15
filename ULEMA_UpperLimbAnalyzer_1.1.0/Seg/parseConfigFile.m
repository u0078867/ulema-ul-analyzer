%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function config = parseConfigFile(fn,sections,subsections)

% This function parse a config file (.txt) that has the following
% structure:
%
%     [\Section1]
% 
%     [Subsection1]
%     ...
% 
%     [Subsection1]
%     ...
% 
%     [\Section2]
%
%     [Subsection2]
%     ...
% 
%     [Subsection2]
%     ...
% 
%     [\End]
%
% New parameters are addable by the user in the .txt file and they will be
% automatically structured in the "config" output structure.
%
% ------ INPUT ------
% 
% fn [String]   : complete path of the config file to open
%
% ------ OUTPUT ------
% config [n x 1 Cell]   : cell array (n is the number sections [Method]) 
%                         of structires in which every field is the 
%                         parameter set in the config file "fn"
%
% ------ AUTHOR ------
% Davide Monari
% mailto: d.monari@inail.it
%
% ------ REVIEW ------
% Last review: Apr 2011, Davide Monari

fid=fopen(fn);
goOnSub = true;
goOnPar = true;
contConf = 1;
contPar = 1;
config = [];

%% Start parsing

for s = 1 : length(sections) % cicle for every [\section]
    
    line = fgetl(fid);
    if strcmp(line,['[',sections{s},']'])        
        while goOnSub % cicle for every [subsection]
            
            line = fgetl(fid);
            if strcmp(line,['[\',sections{s},']'])
                goOnSub = false;
            elseif strcmp(line,['[',subsections{s},']'])       
                %disp('Subsection found');
                % read a parameter lines
                while goOnPar
                    line = fgetl(fid);
                    if strcmp(line,['[\',subsections{s},']']) 
                        goOnPar = false;
                        contPar = contPar - 1;
                    elseif ~isempty(line)
                        % parse name and value of the parameter
                        %disp('Parameter found');
                        [pn{contPar}, dummy] = strtok(line,'=');
                        eval([line]);
                        contPar = contPar + 1;
                    end
                end
                % set the config structure with the current "[Method]" content
                for i = 1 : contPar
                    parName = pn{i}(3:end);
                    config{contConf}.(parName) = p.(parName);
                end
                % reset internal counters and check for the end of [Method] or [\Manual]
                contPar = 1;
                pn = {};
                contConf = contConf + 1;
                goOnPar = true;
                
            end
            
        end
        
    
    end
    
end


%% Close file

fclose(fid);
