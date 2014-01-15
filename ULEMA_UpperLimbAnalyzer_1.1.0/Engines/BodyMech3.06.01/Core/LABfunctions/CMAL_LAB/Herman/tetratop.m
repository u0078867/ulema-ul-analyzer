%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [comp,T1,T2] = tetratop(P,Q,R,lp,lq,lr)

% [comp,T1,T2] = tetratop(P,Q,R,lp,lq,lr)
%
% P, Q, and R are the coordinates of the base points of a
% tetrahedron; lp, lq and lr are the distances between these base
% points and the top of the tetrahedron. (P, Q and R are 3 x 1
% vectors; lp, lq and lr are positive scalars.)
% If the lengths are compatible with the size of the base, the
% function returns `comp' equal to 1, and two three-vectors, T1 and T2,
% which are the coordinates of the top of the tetrahedron. T1 and T2
% are each other's reflections through the base.
% `comp' equals 0 if the leg lengths are not compatible with the size
% of the base.
%
% Requires: sol_llq

% Herman Bruyninckx, 14 FEB 1996, 05 JAN 97
% Reference:
%   Bruyninckx, Herman
%   ``Forward Kinematics for Hunt-Primrose Parallel Manipulators''
%   Mechanism and Machine Theory, 1997

% Let S = (Sx Sy Sz) be the (unknown) vector from P to the top T;
% so lp is the length of S, and
%   (1)    Sx^2 + Sy^2 + Sz^2 = lp^2
% Let A = (Ax Ay Az) be the (known) vector from P to Q (i.e., A = Q - P),
% with length a.
% and B = (Bx By Bz) the (known) vector from P to R (i.e., B = R - P),
% with length b.
% Let C be the (unknown) vector from Q to T; it has (known) length lq.
% Let D be the (unknown) vector from R to T; it has (known) length lr.
% Hence:
%   A + C = S
%   B + D = S
% Taking the dot products of these identities with themselves gives
%   (2)    Ax Sx + Ay Sy + Az Sz = (lp^2 + a^2 - lq^2)/2
%   (3)    Bx Sx + By Sy + Bz Sz = (lp^2 + b^2 - lr^2)/2
% Hence, S is the solution of a set of three equations: the two linear
% equations (2) and (3), and the quadratic equation (1).

name = 'tetratop';
comp = 1;
T1   = zeros(3,1); T2 = T1;

A = Q - P; B = R - P;
if rank([A B]) < 2 fprintf(2,'%s: Base points are collinear!\n',name)
   comp = 0;
   return;
end;

da      = (lp^2 + norm(A)^2 - lq^2)/2;
db      = (lp^2 + norm(B)^2 - lr^2)/2;
[X1,X2] = sol_llq(A,B,[1;1;1],da,db,lp^2);
if ( norm(imag(X1)) > 0 ) % no real solution!
  comp = 0;
  return;
end;
T1 = P + X1;
T2 = P + X2;

