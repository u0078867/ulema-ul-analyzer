%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% pointer [ BodyMech 3.06.01 ]: calculates the tip coordinates of the stylus
% INPUT
%   Input: actual global stylus marker coordinates
% PROCESS
%   uses: a stylus specific calculation
% OUTPUT
%   StylusTip=global coordinates of the stylus tip 

% calculation of penpoint from 4 non-collinear markers to determine the
% xyz-coordinates of the anatomical bony landmarks
% points are used to construct the anatomical coordinate frames

% AUTHOR(S) AND VERSION-HISTORY
% Creation Jaap Harlaar, VUmc, Amsterdam, December 2000
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 
% $ Ver 3.06.02 FaBeR, Leuven, May 2007 (Ellen Jaspers)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

% distance from point to each marker
l1 = 457,5;
l2 = 369;
l3 = 266;
l4 = 147,5;
[L,M,N,] = size(MyMarkers);
F = N - 100;
P1 = squeeze(MyMarkers(:,21,200:30:F));
P2 = squeeze(MyMarkers(:,22,200:30:F));
P3 = squeeze(MyMarkers(:,23,200:30:F));
P4 = squeeze(MyMarkers(:,24,200:30:F));
[n,m] = size(P4);
E = (P1 - P4);
for i = 1:m;
    nE = norm(E(:,i));
    E(:,i) = E(:,i)/nE;
end;
%
% i = videoframe, specify N in command window
% E = unitvector derived from 2 points most distant from each other
% P = X + l*E, whereby X = coordinates of the pen point, thus
% X = P - l*E
    X1 = [P1 - l1*E];
    X2 = [P2 - l2*E];
    X3 = [P3 - l3*E];
    X4 = [P4 - l4*E];
X5 = (X1+X2+X3+X4)/4;
P5 = mean(X5,2);
% P5 = xyz-coordinates of the anatomical landmark 
% =========================================================================
