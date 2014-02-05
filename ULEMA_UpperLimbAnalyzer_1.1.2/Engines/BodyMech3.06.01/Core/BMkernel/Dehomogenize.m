%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [vector,matrix]=Dehomogenize(HomogeneousMatrix)
% DEHOMOGENIZE [ BodyMech 3.06.01 ]: Transformation to non homogeneous matrices
% INPUT
%   Transformation matrix: size(HomogeneousMatrix)=[4,4,Nsamples]
%   Homogeneous coordinates: size(HomogeneousMatrix)= [4,Nsamples]
% PROCESS
%   Transformation matrix: splits into a translation vector and a rotation matrix
%   Homogeneous coordinates: revomes the 4th (hogenoues) coordinate in th first dim.
% OUTPUT
%   Transformation matrix: vector [3,Nsamples] and  matrix [3,3,Nsamples]
%   Homogeneous coordinates: vector [3,Nsamples]

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (J.Harlaar, VUmc, Amsterdam, November 1999)
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
SizeMatrix=size(HomogeneousMatrix);

if length(SizeMatrix)== 2 & SizeMatrix(1)~=4;
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>> first dimension of the homogeneous vector must be X,Y,Z,U')
    error(' wrong input format')
    return
end
if length(SizeMatrix)== 3 & (SizeMatrix(2)~=4 | SizeMatrix(1)~=4)
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>> transformationmatrix must be 4x4xN')
    error(' wrong input format')
    return
end

% PROCESS
if length(SizeMatrix)== 2
    vector=HomogeneousMatrix(1:3,:);
    matrix=[];
else % length(SizeMatrix)==3
    vector=HomogeneousMatrix(1:3,4,:);              % size(vector)=[3,1,Nsamples]
    vector=reshape(vector,3,prod(size(vector))/3);   % size(vector)=[3,Nsamples]
    matrix=HomogeneousMatrix(1:3,1:3,:);
end
return

% ============================================
% END ### DEHOMOGENIZE ###
