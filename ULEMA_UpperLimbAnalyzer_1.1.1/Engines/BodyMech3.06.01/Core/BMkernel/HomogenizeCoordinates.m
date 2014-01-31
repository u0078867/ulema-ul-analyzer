%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function HomCoordinateArray=HomogenizeCoordinates(CoordinateArray)
% HOMOGENIZECOORDINATES [ BodyMech 3.06.01 ]: transformation to homogeneous coordinates
% INPUT
%   coordinate_array DIM1=3
% PROCESS
%   adds ones as the 4th coordinate in the first dimension 
% OUTPUT
%   h_coordinate_array 

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

% initialisation 

% INPUT checks
if nargin==0 
   disp('>> BodyMech.m APPLICATION ERROR:')
   disp('>> No input')
   error(' wrong input format')
   return
end
size_ca=size(CoordinateArray);
if size_ca(1)~=3;
   disp('>> BodyMech.m APPLICATION ERROR:')
   disp('>> first dimension must be X,Y,Z')
   error(' wrong input format')
   return
end


% PROCESS
size_ca(1)=1;

% OUTPUT
HomCoordinateArray=[CoordinateArray;ones(size_ca)];

return
% ============================================ 
% END ### HomogenizeCoordinates ###
