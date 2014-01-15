%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = getVirtualDBIndexes(trDB, names)

% Old implementation with many fors: inefficient

% switch length(names)
%     
%     case 1  % Search among subjects
%         varargout{1} = [];
%         for i = 1 : length(trDB.subjects)
%             workbar(i / length(trDB.subjects), 'Loading internal indexes...', 'Subjects indexing');
%             if strcmp(trDB.subjects(i).name,names{1})
%                 varargout{1} = i;
%             end
%         end
% 
% 
%     case 2  % Search among subjects and sessions
%         varargout{1} = [];
%         varargout{2} = [];
%         for i = 1 : length(trDB.subjects)
%             workbar(i / length(trDB.subjects), 'Loading internal indexes...', 'sessions indexing');
%             if strcmp(trDB.subjects(i).name,names{1})
%                 varargout{1} = i;
%                 for j = 1 : length(trDB.subjects(i).sessions)
%                     if strcmp(trDB.subjects(i).sessions(j).name,names{2})
%                         varargout{2} = j;
%                     end
%                 end
%             end
%         end
%         
%     case 3  % Search among subjects, sessions and trials
%         varargout{1} = [];
%         varargout{2} = [];
%         varargout{3} = [];
%         for i = 1 : length(trDB.subjects)
%             workbar(i / length(trDB.subjects), 'Loading internal indexes...', 'Trials indexing');
%             if strcmp(trDB.subjects(i).name,names{1})
%                 varargout{1} = i;
%                 for j = 1 : length(trDB.subjects(i).sessions)
%                     if strcmp(trDB.subjects(i).sessions(j).name,names{2})
%                         varargout{2} = j;
%                         for t = 1 : length(names{3})
%                             for k = 1 : length(trDB.subjects(i).sessions(j).trials)
%                                 if strcmp(trDB.subjects(i).sessions(j).trials(k).name,names{3}{t})
%                                     varargout{3}{t} = k;
%                                 end
%                             end
%                         end
%                     end
%                 end
%             end
%         end
%         
% end

% new implementation with only one for: efficient


subInd = strcmp({trDB.subjects.name}, names{1});
if sum(subInd) == 0
    varargout{1} = [];
else
    varargout{1} = subInd;
end

if length(names) == 1
    return;
end

sesInd = strcmp({trDB.subjects(subInd).sessions.name}, names{2});
if sum(sesInd) == 0
    varargout{2} = [];
else
    varargout{2} = sesInd;
end

if length(names) == 2
    return;
end

varargout{3} = cell(length(names{3}),1);
for t = 1 : length(names{3})
    trInd = strcmp({trDB.subjects(subInd).sessions(sesInd).trials.name}, names{3}{t});
    if sum(trInd) == 0
        varargout{3}{t} = [];
    else
        varargout{3}{t} = trInd;
    end
end


