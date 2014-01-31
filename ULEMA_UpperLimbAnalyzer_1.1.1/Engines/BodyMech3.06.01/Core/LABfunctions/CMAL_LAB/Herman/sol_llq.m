%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [X1,X2] = sol_llq (A,B,C,da,db,dq)

% [X1,X2] = sol_llq (A,B,C,da,db,dq)
%
% A, B and C are 3 x 1 vectors; da, db and dq are real numbers.
% The two three-vectors Xi are the intersections of two planes and
% a sphere, i.e., the solution of the following set of three
% equations:
%
%   A1 X1  +  A2 X2  +  A3 X3  = da
%   B1 X1  +  B2 X2  +  B3 X3  = db
%  C1 X1^2 + C2 X2^2 + C3 X3^2 = dq
%
% X contains complex numbers if no two real solutions exist.
% X contains NaN if both planes are parallel.

% Herman Bruyninckx, 23 JAN 1997

% Algorithm:
%
% Step 1: intersection of both planes:
%   X = P0 + k*P1, with P0 a point in both planes, and P1 the
%   direction vector of the intersection. P1 is found as the
%   null space of [A B]; P0 is an arbitrary point on the
%   intersection.
%
% Step 2: intersection with sphere:
% The solution X lies at a distance sqrt(dq) from the origin,
% or dq = (P0 + k*P1)^2, which is a quadratic equation in k.
% Hence, two (possibly non-real) solutions exist.

M = [A';B'];
R = [da;db];
% Step 1:
if ( rank(M) < 2) X1 = NaN*eye(3,1); X2 = X1; return; end;
P1 = null (M);
P0 = M\R;

% Step 2:
AA = C'*(P1.*P1);
BB = C'*(P0.*P1);
CC = C'*(P0.*P0) - dq;
D  = BB*BB-AA*CC;
%if (D < 0) X1 = NaN*eye(3,1); X2 = X1; return; end;
D = sqrt(D);
X1 = P0 + P1*(-BB + D)/AA;
X2 = P0 + P1*(-BB - D)/AA;

