%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function varargout = eExecEngIFunc(enginesInfo, engineIndex, IFunc, varargin)

fullIFuncName = [IFunc, '_', enginesInfo(engineIndex).pedex];
parString = ' ';
for i = 1 : length(varargin)
    parString = [parString, 'varargin{', num2str(i), '}, '];
end
if ~isempty(varargin)
    parString = parString(1:end-2);
end
commandString = [fullIFuncName, '(', parString, ');'];
varargout{1} = eval(commandString);
