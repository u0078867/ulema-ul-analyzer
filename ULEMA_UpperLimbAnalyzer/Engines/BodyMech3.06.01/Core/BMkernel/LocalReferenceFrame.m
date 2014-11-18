%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [M,T]=LocalReferenceFrame(ClusterMarkers)
% LOCALREFERENCEFRAME [ BodyMech 3.06.01 ]: creates an ad-hoc local coordinate system
% INPUT
%   ClusterMarkers: matrix [3,M] of a rigid cluster of M marker positions in the GRF
%   (global reference frame)
%   Marker positions are column vectors: i.e comply to the [x;y;z] format
%   with N=> 3 : at least three non-colinear markers are needed
% PROCESS
%   calculates the coordinates of the markers in an orthonormal, righthanded
%   local coordinate system
%   origin: centroid of all N points
%   marker1-x: direction of local Xaxis
%   x,marker1,marker2: local XY-plane
% OUTPUT
%   M = (non-homogeneus) markercoordinates in the local frame
%   T = [R,t; 0 0 0 1] : the homogeneous transformation matrix
%   R = [Ex  Ey  Ez]; Ez=Ex X Ey ; local coordinate vectors in global axis, i.e. the rotation matrix
%   t = origin of the local coordinate system (in the GRF)

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, 1998)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader

[Ndimension,Nmarkers]=size(ClusterMarkers);

% initialisation
A=zeros(3);
M=zeros(3,Nmarkers);


% input checks
if Ndimension~=3
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>> Input vectors must comply to the [x;y;z] format')
    error(' wrong input format')
    return
end
if Nmarkers<3
    disp('>> BodyMech.m APPLICATION ERROR:')
    disp('>>A rigid body needs at least 3 non-colinear markers to identify its attitude')
    error(' not enough markers')
    return
end
% end of input checks

centroid = mean(ClusterMarkers,2); % average over rows

% orthogonal righthanded coordinate system
x=ClusterMarkers(:,1)-centroid;
z=cross(x,ClusterMarkers(:,2)-centroid);
y=cross(z,x);

% normalization
ex=x/norm(x);
ey=y/norm(y);
ez=z/norm(z);

R=[ ex ey ez]; % the local coordinate system in global axes,
% i.e. the rotation matrix
t=centroid;    % the translation vector
T = [R,t; 0 0 0 1]; % the transformation matrix

h_ClusterMarkers=[ClusterMarkers;ones([1,Nmarkers])]; % homogeneous coordinates

h_M=inv(T)*h_ClusterMarkers;
M=h_M(X:Z,:);
% M=R'*(ClusterMarkers-t); % local coordinates

BodyMechFuncFooter
return
% ============================================
% END ### LocalReferenceFrame ###
