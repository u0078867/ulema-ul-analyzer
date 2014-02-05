%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function listCell = HTML2listCell(HTML)

temp = strrep(HTML,'<body>','');
temp = strrep(temp,'</body>','');
temp = strrep(temp,'<font>','');
temp = strrep(temp,'</font>','');
temp = strrep(temp,'<html>','');
temp = strrep(temp,'</html>','');
temp = strrep(temp,'<head>','');
temp = strrep(temp,'</head>','');
temp = strrep(temp,'<br>',' ');
[t{1},r] = strtok(temp);
while ~isempty(r)
    [t{end+1},r] = strtok(r);
end
listCell = t(1:end-1);

