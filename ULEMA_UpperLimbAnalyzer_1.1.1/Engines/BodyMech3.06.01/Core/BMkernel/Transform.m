%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [q,b]=Transform(M,p)
% TRANSFORM [ BodyMech 3.06.01 ]: Transform uses a 4x4 TransformationMatrix on all elements of the Invector
% INPUT
%   M : TransformationMatrix
%   p : InVector
% PROCESS
%   Transform uses a 4x4 TransformationMatrix on all elements of the Invector
%   An OutVector (as well as its homogeneous value) is calculated.
% OUTPUT
%   q : OutVector
%   b : HomOutVector

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

[dim,Ncols]=size(p);
if dim==3,
    if Ncols==1,
        a=[p;1]; % homogenize
        b=M*a;
        q=b(1:3); % dehomogenize
    else
        a=[p;ones([1 Ncols])]; % homogenize
        b=M*a;
        q=b(1:3,:); % dehomogenize
    end
else
    % display application error

end

return
%======================================================================
% END ### Transform ###
