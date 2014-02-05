%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [ok, prot1FilesList, prot2FilesList] = testDJCFilesList(prot1, prot2)

% Test if the file names in the first DJC list are the same to the ones in
% the second list. Order in the list it is not important. Existance of new
% new file names in the second list makes the test fail.

prot1FilesList = prot1.DJCList(:,3); 
prot1FilesList(cellfun(@isempty,prot1FilesList)) = [];
prot1FilesList = unique(prot1FilesList);
prot2FilesList = prot2.DJCList(:,3);
prot2FilesList(cellfun(@isempty,prot2FilesList)) = [];
prot2FilesList = unique(prot2FilesList);
ok = isequal(prot1FilesList, prot2FilesList);

