%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function HomogenizedMatrix=Homogenize(vector,matrix)
% HOMOGENIZE [ BodyMech 3.06.01 ]: transformation to homogeneous coordinates
% INPUT
%   if N_input_argument =1 : vector [3,Nsamples]
%   if N_input_argument =2 : vector [3,Nsamples],matrix [3,3,Nsamples]
% PROCESS
%   if N_input_argument =1 : adds ones as the 4th coordinate in the first dimension
%   if N_input_argument =2 : combines translation and rotation into a
%                            single transformation (4X4) matrix
% OUTPUT
%   vector [4,Nsamples} or matrix [4,4,Nsamples]

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
    disp('>> Input must be present')
    error(' wrong input format')
    return
end
size_v=size(vector);
if size_v(1)~=3;
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>> first dimension of the vector must be X,Y,Z')
    error(' wrong input format')
    return
end
if nargin == 2
    size_m=size(matrix);
    if size_m(1)~=3 |  size_m(2)~=3
        disp('>> BodyMech.m APPLICATION ERROR:')
        disp('>> matrix must be a 3x3xN')
        error(' wrong input format')
        return
    end
    if size_m(3)~=size_v(2),
        disp('>> BodyMech.m APPLICATION ERROR:')
        disp('>> last dimension of matrix and vector should be identical (Nsamples)')
        error(' wrong input format')
        return
    end
end

% PROCESS
if nargin==1
    HomogenizedMatrix=HomogenizeCoordinates(vector);
else
    HomogenizedMatrix=HomogenizeMatrix(vector,matrix);
end
return

% ============================================
% END ### Homogenize ###
