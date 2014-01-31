%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function TransformationMatrix=HomogenizeMatrix(TranslationVector, RotationMatrix)
% HOMOGENIZEMATRIX [ BodyMech 3.06.01 ]: transformation to homogeneous coordinates
% INPUT
%   TranslationVector [3,Nsamples]
%   RotationMatrix [3,3,Nsamples]
% PROCESS
%   Combines rotation and translation into a single transformation (4X4) matrix
% OUTPUT
%   Transformation_matrix [4,4,Nsamples]

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader
% initialisation

% INPUT checks
if nargin==0 | nargin==1
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>> Input must be a matrix and a vector')
    error(' wrong input format')
    return
end
size_r=size(RotationMatrix);
size_t=size(TranslationVector);
if size_r(2)~=3,
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>> first parameter must be a 3x3xN matrix')
    error(' wrong input format')
    return
end
if size_r(1)~=3 | size_t(1)~=3,
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>> input should have X,Y,Z as first dimension')
    error(' wrong input format')
    return
end
if size_r(3)~=size_t(2),
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>> last dimension of matrix and vector should be identical (Nsamples)')
    error(' wrong input format')
    return
end

% PROCESS
Nsamples=size_r(3);
for i=1:Nsamples,
    T(:,:,i)=[RotationMatrix(:,:,i),TranslationVector(:,i); 0 0 0 1];
end

% OUTPUT
TransformationMatrix=T;

return
% ============================================
% END ### HomogenizeMatrix ###
