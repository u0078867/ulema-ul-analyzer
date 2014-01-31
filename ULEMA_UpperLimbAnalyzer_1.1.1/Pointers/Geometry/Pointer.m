%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function StylusTip=Pointer(InputData, StylusGeomtryParams)
% point [ BodyMech 3.06.01 ]: calculates the tip coordinates of the stylus
% INPUT
%   Input: actual global stylus marker coordinates
% PROCESS
%   uses: a stylus specific calculation
% OUTPUT
%   StylusTip=global coordinates of the stylus tip 

% calculation of stylustip from 4 collinear markers on carbon stick
% to determine the xyz-coordinates of the anatomical bony landmarks
% anatomical landmarks are used to define the anatomical frames

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation Jaap Harlaar, VUmc, Amsterdam, December 2000
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 
% $ Ver 4.0 KUL-FaBeR, Leuven, June 2007 (Herman Bruyninckx en Ellen Jaspers)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader

 % distance from stylustip to each marker % LEUVEN POINTER
 l1 = StylusGeomtryParams.DistancesToTip(1);
 l2 = StylusGeomtryParams.DistancesToTip(2);
 l3 = StylusGeomtryParams.DistancesToTip(3);
 l4 = StylusGeomtryParams.DistancesToTip(4);

% % Distance from stylustip to each marker % UNIVERSITY MAASTRICHT POINTER
% l1 = 334.6/1000;
% l2 = 265.7/1000;
% l3 = 193/1000;
% l4 = 104/1000;

% [L,M,N,] = size(MyMarkers);
% F = N - 100;
% P1 = squeeze(MyMarkers(:,21,200:30:F));
% P2 = squeeze(MyMarkers(:,22,200:30:F));
% P3 = squeeze(MyMarkers(:,23,200:30:F));
% P4 = squeeze(MyMarkers(:,24,200:30:F));

%P1 = BODY.CONTEXT.Stylus.KinematicsMarkers(1:3,1,:); %AssignMarkerDataToStylus
%P2 = BODY.CONTEXT.Stylus.KinematicsMarkers(1:3,2,:);
%P3 = BODY.CONTEXT.Stylus.KinematicsMarkers(1:3,3,:);
%P4 = BODY.CONTEXT.Stylus.KinematicsMarkers(1:3,4,:);

P1 = InputData(:,1);
P2 = InputData(:,2);
P3 = InputData(:,3);
P4 = InputData(:,4);

[n,m] = size(P4); % n=3 coordinates; m=timeframes
E = (P1 - P4);

for i = 1:m;            % i = videoframes
    nE = norm(E(:,i));  % E = unitvector derived from 2 most distant markers
    E(:,i) = E(:,i)/nE; 
end;

    X1 = [P1 - l1*E];   % P=X+l*E, thus X = P-l*E
    X2 = [P2 - l2*E];
    X3 = [P3 - l3*E];
    X4 = [P4 - l4*E];
    X5 = (X1+X2+X3+X4)/4;   % 3x4xN matrix 

StylusTip = mean(X5,2);     % 3 coordinates of StylusTip of pointer

% =========================================================================
% END ### pointer ###
