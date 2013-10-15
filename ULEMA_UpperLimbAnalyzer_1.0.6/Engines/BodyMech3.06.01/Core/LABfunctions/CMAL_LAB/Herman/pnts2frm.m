%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [ret,p,R] = pnts2frm (f1,f2,f3,w1,w2,w3)

%  [ret,p,R] = pnts2frm (f1,f2,f3,w1,w2,w3)
%
%  Transforms the coordinates of three points into the position p
%  and orientation matrix R of a frame attached to the points.
%  The wi are the coordinates (column three-vectors) of three
%  points on the frame, with respect to the WORLD reference
%  frame. The fi are the coordinates (column three-vectors) of 
%  the same three points, but with respect to the sought-after
%  frame itself.
%  ret is a status return code:
%    0: if the points are collinear, or point lengths and coordinates
%       not compatible;
%    1: after successful termination.
%
%  Caveat: 
%   - the three points should not be collinear!
%   - the code contains an arbitrary zero threshold!
%

%  Herman.Bruyninckx@mech.kuleuven.ac.be, 26 FEB 96, 23 JAN 1997
%
% The solution uses the `tetratop' algorithm, that calculates the
% coordinates of the top of a tetrahedron from the knowledge of 
%  (i) the coordinates of the three other vertices, and
% (ii) the lengths of the edges adjacent to the top.

% Initializations:
name = 'pnts2frm';

% zero threshold relative to dimensions of platform:
l1 = norm(f1); l2 = norm(f2); l3 = norm(f3);
myeps = .000001*(l1+l2+l3);
F=[f1 f2 f3];
W=[w1 w2 w3];
% Simple check to see if points *can* be each other's transforms:
if (abs( (f2-f1)'*(f3-f1) - (w2-w1)'*(w3-w1) ) > myeps)...
 | (abs( (f3-f2)'*(f1-f2) - (w3-w2)'*(w1-w2) ) > myeps)...
 | (abs( (f1-f3)'*(f2-f3) - (w1-w3)'*(w2-w3) ) > myeps)
  fprintf(2,'%s: error: points do not form similar tetrads!\n',name);
  ret = 0;
  return;
end;
comp = 1;          ret = 1;
R    = eye(3,3);   p   = zeros(3,1);
p1   = zeros(3,1); p2  = zeros(3,1);

% First, if one of the fi is (very close to) the origin, we permute
% the fi such that this point becomes f1 (at the same time, we know
% already that p equals the corresponding wi):
if (l1 < myeps) p = w1;
elseif (l2 < myeps)
   p  = w2; f2 = f1; w2 = w1; f1 = [0 0 0]';
   ld = l2; l2 = l1; l1 = ld; w1 = p;
elseif (l3 < myeps)
   p  = w3; f3 = f1; w3 = w1; f1 = [0 0 0]';
   ld = l3; l3 = l1; l1 = ld; w1 = p;
end;
% At his point, it's still possible that f1, f2 and f3 are collinear.
% This case is really degenerate: it can not give a solution.
% Collinearity means:            rank(f2-f1 f3-f1)=1
% Coplanarity with origin means: rank(F)=2
if (rank([F(:,2)-F(:,1) F(:,3)-F(:,1)]) < 2)
  % the fi are collinear
  fprintf(2,'%s: error: collinear points!\n',name);
  ret = 0;
  return;
end;
if (rank(F) < 3)
  % the fi are coplanar with the origin, hence a linear combination
  % of them gives zero:
  lc = null(F)
  % lc(1)*f1 + lc(2)*f2 + lc(3)*f3 = 0.
  % The point p is found from the same linear combination applied to the wi:
  % lc(1)*(w1-p) + lc(2)*(w2-p) + lc(3)*(w3-p) = 0.
  % Hence:
  p = (lc(1)*w1 + lc(2)*w2 + lc(3)*w3)/(lc(1)+lc(2)+lc(3))
  % We replace f1 with the vector product fv = f21 x f31, in order
  % to get three points that are non-coplanar with the origin:
  f21 = f2 - f1;  f31 = f3 - f1;
  f1 = [f21(2)*f31(3) - f21(3)*f31(2); 
        f21(3)*f31(1) - f21(1)*f31(3); 
        f21(1)*f31(2) - f21(2)*f31(1)];
  % w1 should be replaced by the same vector product (AFTER
  % compensation for the shift in origin p!):
  f21 = w2 - w1;  f31 = w3 - w1;
  w1 = [f21(2)*f31(3) - f21(3)*f31(2); 
        f21(3)*f31(1) - f21(1)*f31(3); 
        f21(1)*f31(2) - f21(2)*f31(1) ] + p;
else
  % Calculate the position p of the origin of the top platform  reference
  % frame if we know that none of the fi coincides with the origin:
  [comp,p1,p2] = tetratop(w1,w2,w3,l1,l2,l3);
  if (comp == 0)
    fprintf(2,'%s: Point coordinates and lengths not compatible!\n',name)
    ret = 0;
    return;
  end;
  % The triple product is used to select p1 or p2:
  if ( (det([f1 f2 f3]) * det([w1-p1 w2-p1 w3-p1]) ) < 0 )
      p = p2;
  else
      p = p1;
  end;
end;
% Now calculate the orientation R of the top platform reference frame.
% This algorithm requires that the wi are not coplanar with p.
% R is now found as the matrix that maps the coordinates of the fi
% onto the coordinates of the wi-p:
F = [f1 f2 f3]
V = [w1-p w2-p w3-p]
det(F)
det(V)
% The sought after coefficients of the above-mentioned linear
% combination are the solutions to the linear equation
%    R F = V.
R = V/F;

