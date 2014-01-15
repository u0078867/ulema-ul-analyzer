%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function clearallbut(varargin)
% CLEARALLBUT: Clear all variables except these.
%  CLEARALLBUT VAR1 removes all variables from the workspace except VAR1.
%
%   CLEARALLBUT VAR1 VAR2 VAR3 ...
%   CLEARALLBUT('VAR1','VAR2','VAR3',...)
%   CLEARALLBUT({'VAR1','VAR2','VAR3',...})
%   do the same for various variable names.
%   

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

if nargin==0
   error('Expecting an input argument.')
elseif nargin==1
   if ischar(varargin{1})
      in = varargin;
   else
      in = varargin{1};
   end
else
   in = varargin;
end
if ~iscellstr(in)
   error('Input arguments must be strings.')
end
s = evalin('caller','who');
s = setdiff(s,in);
if ~isempty(s)
   s = sprintf(' %s',s{:});
   evalin('caller',['clear',s]);
end
%==========================================================================
% END ### ClearAllBut ###
