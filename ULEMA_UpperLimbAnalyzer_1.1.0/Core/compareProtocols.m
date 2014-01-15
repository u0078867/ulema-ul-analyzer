%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function res = compareProtocols(prot1, prot2, protOptsDescr, sections, specificFields)

if isempty(sections)
    res = -1;   % no comparison is performed
end

if strcmp(sections,'-all')
    sections = unique(protOptsDescr(:,2));
end

res = 1;

if isempty(specificFields)

    for s = 1 : length(sections)
        ind = find(strcmp(protOptsDescr(:,2),sections{s}));
        for f = 1 : length(ind)
            %fprintf('\nChecking %s ... ', protOptsDescr{ind(f),1});
            if isfield(prot1,protOptsDescr{ind(f),1}) && isfield(prot2,protOptsDescr{ind(f),1})
                field1 = prot1.(protOptsDescr{ind(f),1});
                field2 = prot2.(protOptsDescr{ind(f),1});
                if isempty(protOptsDescr{ind(f),4})
                    test = feval(protOptsDescr{ind(f),3}, field1, field2);
                else
                    test = feval(protOptsDescr{ind(f),3}, field1, field2, protOptsDescr{ind(f),4});
                end
                if test == 0
                    res = 0;
                    %fprintf('not equal');
                    return
                else
                    %fprintf('ok');
                end
            else
                res = 0;
                %fprintf('not found in one prot');
                return
            end
        end
    end

else
            
    for s = 1 : length(specificFields)
        ind = strcmp(protOptsDescr(:,1),specificFields{s});
        if isfield(prot1,specificFields{s}) && isfield(prot2,specificFields{s})
            field1 = prot1.(specificFields{s});
            field2 = prot2.(specificFields{s});
            if isempty(protOptsDescr{ind,4})
                test = feval(protOptsDescr{ind,3}, field1, field2);
            else
                test = feval(protOptsDescr{ind,3}, field1, field2, protOptsDescr{ind,4});
            end
            if test == 0
                res = 0;
                return
            end
        else
            res = 0;
            return
        end
    end
end

% fprintf('Protocols data is matching');
    
    
