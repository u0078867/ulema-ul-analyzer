%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [T,e]=RigidBodyTransformation_VECT_OPT2(x,yV)
% RIGIDBODYTRANSFORMATION [ BodyMech 3.06.01 ]: calculates a transformation matrix
% INPUT
%   x,y : matrices of a cluster of N markers on the rigid body in [x;y;z] format; N=>3
%   x   : first position
%   y   : second position
% PROCESS
%   Estimation of rotation and translation between x and y solving
%   y = Rx + t in a least square optimal sense.
% OUTPUT
%   R : rotation matrix
%   t : translation vector
%   e : error

% Descriptions of this algorithm can be found in:
% Arun et al.(1987); Woltring(1992); Soderkvist&Wedin(1993); Challis(1995)

% AUTHOR(S) AND VERSION-HISTORY
% Some code was copied from DJ Veeger (1994)
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, Amsterdam, June 1998)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% input checks
[n1,m1]=size(x);
[n2,m2,f2]=size(yV);
if n1~=3 | n2~=3 | m1~=m2
    disp('>> APPLICATION ERROR:')
    disp('>> Input vectors must have equal dimensions and comply to the [x;y;z] format')
    error(' input format')
    return
    disp('>>')
    return
else
    Nmarkers=m1;
end
if Nmarkers<3
    disp('>>  APPLICATION ERROR:')
    disp('>>  at least 3 markers are needed')
    error(' ill-conditioned problem')
    return
end
% end of input checks

% initialisation
R=ones(3);
t=[ 0 0 0 ];
e=0;
T = zeros(4,4,f2);
e = zeros(Nmarkers,f2);
x=x';

% for c = 1 : 6
y = cell(1,f2); 
NmarkersCell = cell(1,f2);
B = cell(1,f2);
C = cell(1,f2);
Rc = cell(1,f2);
tc = cell(1,f2);
xmeanc = cell(1,f2);
xmean = mean(x);
A = x-ones(Nmarkers,3)*diag(xmean);
% Ac = cell(1,f2);
for i = 1 : f2
    y{i} = yV(:,:,i)';
    NmarkersCell{i} = Nmarkers;
    xmeanc{i} = xmean;
    % Ac{i} = A;
end
ymean = cellfun(@mean, y, 'UniformOutput', false);
% B = cellfun(@calcB, NmarkersCell, y, ymean, 'UniformOutput', false);
for i = 1 : f2
    B{i} = y{i}-ones(Nmarkers,3)*diag(ymean{i});
    C{i} = B{i}'*A./Nmarkers;
end
% C = cellfun(@calcC, Ac, B, NmarkersCell, 'UniformOutput', false);
[U,S,V] = cellfun(@svd, C, 'UniformOutput', false);
Vt = cellfun(@transpose, V, 'UniformOutput', false);
UVt = cellfun(@mtimes, U, Vt, 'UniformOutput', false);
D = cellfun(@det, UVt, 'UniformOutput', false);
% Dd = cellfun(@calcD, D, 'UniformOutput', false);
% UDd = cellfun(@mtimes, U, Dd, 'UniformOutput', false);
% Rc = cellfun(@mtimes, UDd, Vt, 'UniformOutput', false);
for i = 1 : f2
    Rc{i} = U{i} * diag([1 1 D{i}]) * Vt{i};
end
R = cell2mat(Rc);
R = reshape(R, 3, 3, f2);
% tc = cellfun(@calct, ymean, Rc, xmeanc, 'UniformOutput', false);
for i = 1 : f2
    tc{i} = ymean{i}'-Rc{i}*xmean';
end
t = cell2mat(tc);
for i = 1 : f2
    T(:,:,i) = [R(:,:,i),t(:,i); 0 0 0 1];
end
e = 0;
% end

% for i = 1 : f2 % cycle for every frame
%         
%     % PATCH to accomodate external format
%     y = yV(:,:,i);
%     y=y';
% 
%     % calculation of the cross-dispersion matrix
%     xmean=mean(x); ymean=mean(y);
%     A=x-ones(Nmarkers,3)*diag(xmean);
%     B=y-ones(Nmarkers,3)*diag(ymean);
%     C=B'*A./Nmarkers;
% 
%     % singular value decomposition of C
%     [U,S,V]=svd(C);
% 
%     tol=0.00002; % was .0001   JHA:28-2-2002 (0.00002)
% 
%     s=diag(S);
% 
% 
%     Srank=sum(s>tol) ;
%     if Srank<2
%         disp('>> APPLICATION ERROR:')
%         disp('>> Markers are probably colinear aligned')
%         error(' ill-conditioned problem')
%         return
%     end
%     if Srank<3
%         % all markers in one plane
%         % calculate cross product, i.e. normal vector
%         U(:,3)=cross(U(:,1),U(:,2));
%         V(:,3)=cross(V(:,1),V(:,2));
%     end
% 
%     % calculation of R,t and e
%     D=det(U*V'); % if D=-1 correction is needed:
%     R=U*diag([1 1 D])*V';
%     t=(ymean'-R*xmean')'; % vectors are internal in the [x y z] format
%     t=t'; % PATCH to accomodate external format
% 
%     yestimated=x*R'+ones(Nmarkers,3)*diag(t); % vectors are inaternal in the [x y z] format
%     e(:,i)=sqrt(sum((yestimated -y)'.^2)');
%     
%     T(:,:,i) = [R,t; 0 0 0 1];
% 
% end

return
% ============================================
% END ### RigidBodyTransformation ###

% function B = calcB(Nmarkers, y, ymean)
% B = y-ones(Nmarkers,3)*diag(ymean);
% 
% function C = calcC(A, B, Nmarkers)
% C = B'*A./Nmarkers;
% 
% function Dd = calcD(D)
% Dd = diag([1 1 D]);
% 
% function t = calct(ymean, R, xmean)
% t = ymean'-R*xmean';
