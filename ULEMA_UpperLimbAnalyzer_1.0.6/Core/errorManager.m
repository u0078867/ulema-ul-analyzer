%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function toDo = errorManager(e, errMsg, errTitle)

toDo.return = 1;
choice = questdlg(errMsg, errTitle, 'Yes', 'No', 'Go to error and stop', 'No');
switch choice
    case 'Yes'
    % Do nothing
    case 'Go to error and stop'
    winopen(e.stack(1).file);
    fprintf(['\n',errTitle,'\n']);
    toDo.return = 1;
    otherwise
    % Exit from this function
    fprintf(errTitle);
    toDo.return = 1;
end


