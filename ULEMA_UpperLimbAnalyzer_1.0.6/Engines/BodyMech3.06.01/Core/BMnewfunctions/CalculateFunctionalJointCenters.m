%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function DJC = CalculateFunctionalJointCenters(DJCList, FullPath)

% CALCULATEFUNCTIONALJOINTCENTERS [ BodyMech 3.06.01 ]: Calculation of
% functional joint centers
%
% INPUT
%   DJCList : cell-array M x N where every line has the following columns:
%               DJCList{i,1}: name of the proximal segment
%               DJCList{i,2}: name of the distal segment
%               DJCList{i,3}: this cell can be:
%                   string: name of the c3d file on which to perform the
%                   calculation;
%                   struct: structure containing two fields:
%                       name: name of the c3d file. In this case, FullPath
%                       will be used to locate c3d files to be loaded.
%                       data: struct containing marker data
%               DJCList{i,4}: name of the anatomical landmark to which the
%               functional joint center has to be assigned. If the
%               anatomical landmark doens't exist in the proximal segment, 
%               a new one will be created.
%               DJCList{i,5}: name of the method to use. Available names:
%               'Gamage' (see sub-function 'Gamage').
%   FullPath : full path of the folder in which the file indicated by 
%   DJCList{i,3} is located, if it is needed to (re)load it.
%
% OUTPUT:
%   DJC: same cell-array as in DJCList, but the following content is replaced:
%               DJC{i,3}: struct containing the following fields:
%                   name: name of the c3d file
%                   data: struct containing marker data
%               DJC{i,4}: struct containing the following fields:
%                   name: name of the point functional point reconstructed
%                   data: coordinate of the functional point in the
%                   proximal segment reference frame
%
% NOTES:
%   - Body model used to handle the C3D files in DJCList{:,3} has to be the
%   same as the body model used just before the call of this function.
%
% PROCESS
%   Calculation of the functional joint centers using kinematics about the
%   2 segments connected to the joints.
%   
% OUTPUT
%   GLOBAL BODY.SEGMENT(...).AnatomicalLandmark(...).ClusterFrameCoordinates

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Davide Monari, KUL, Leuven, Belgium. May 2012) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

% Push current global variables into globStruct
globStruct = PushGlobals();

% Initialize the list of the modified/added anatomical landmarks
AnatModifiedList = cell(size(DJCList,1),2);

% Cycle for every functional joint center
DJC = DJCList;
for i = 1 : size(DJCList,1)
    if ischar(DJCList{i,3})
        % Read C3D file
        BMimportULC3D_3_AUTO(DJCList{i,3},FullPath);
    else
        % Recover marker data from the structure
        MARKER_DATA = getMarkersDataFromStruct(DJCList{i,3}.data,BODY.CONTEXT.MarkerLabels);
        MARKER_TIME_OFFSET = 0.;
        MARKER_TIME_GAIN = []; % unused
    end
    % Clear kinematics
    ClearKinematics('markers');
    % Assign the read marker to the BODY structure
    AssignMarkerDataToBody;
    % Calculate cluster kinematics
    CalculateClusterKinematics_NO_WB_OPT2(1:length(BODY.SEGMENT));
    % Search for proximal and distal segment
    IndSeg1 = strcmp({BODY.SEGMENT.Name},DJCList{i,1});
    IndSeg2 = strcmp({BODY.SEGMENT.Name},DJCList{i,2});
    % Create a cluster reference frame with an origin
    [R,O] = CreateFrameFromCluster(BODY.SEGMENT(IndSeg1).Cluster.KinematicsMarkers);
    % Express the markers of the distal segment in the frame of the distal one
    nMarkers = size(BODY.SEGMENT(IndSeg2).Cluster.KinematicsMarkers);
    MarkersCell = cell(1,nMarkers);
    for j = 1 : nMarkers
        % --- this loop could be performed in a vectorized way
        for t = 1 : size(R,3)
            MarkersCell{j}(t,:) = (  R(:,:,t)' * (squeeze(BODY.SEGMENT(IndSeg2).Cluster.KinematicsMarkers(:,j,t)) - O(:,t))  )';
        end
        % ---
    end    
    switch DJCList{i,5}
        case 'Gamage'
            [inc,dev,I,n,C] = Gamage(cell2mat(MarkersCell),0);
            IndAnatLand = strcmp({BODY.SEGMENT(IndSeg1).AnatomicalLandmark.Name},DJCList{i,4});
            if sum(IndAnatLand) > 0 % overwrite an existing one
                BODY.SEGMENT(IndSeg1).AnatomicalLandmark(IndAnatLand).ClusterFrameCoordinates = C;
            else % create a new one
                IndAnatLand = length(BODY.SEGMENT(IndSeg1).AnatomicalLandmark) + 1;
                BODY.SEGMENT(IndSeg1).AnatomicalLandmark(IndAnatLand).Name = DJCList{i,4};
                BODY.SEGMENT(IndSeg1).AnatomicalLandmark(IndAnatLand).ClusterFrameCoordinates = C;
            end
        otherwise
            error(sprintf('BODYMECH:CalculateFunctionalJointCenters:Line %d in DJC List; MissingMethodError',i),'Method not implemented');
    end
    % Add names of modified segments and names of the anatomical landmarks
    AnatModifiedList{i,1} = BODY.SEGMENT(IndSeg1).Name;
    AnatModifiedList{i,2} = BODY.SEGMENT(IndSeg1).AnatomicalLandmark(IndAnatLand).Name;
    % Create output variable
    if ischar(DJCList{i,3})
        DJC{i,3}.name = DJCList{i,3};
    else
        DJC{i,3}.name = DJCList{i,3}.name;
    end
    DJC{i,3}.data = AggregateAllPoints(struct(),'AnatomicalLandmarks');
    DJC{i,3}.data = AggregateAllPoints(DJC{i,3}.data,'TechnicalMarkers');
    DJC{i,4}.name = DJCList{i,4};
    DJC{i,4}.data = C;
end

% Save the temporary BODY structure
tempBODY = BODY;

% Pop the original global variables
PopGlobals(globStruct);

% Update the popped BODY structure
for i = 1 : size(AnatModifiedList,1)
    IndSegSource = strcmp({tempBODY.SEGMENT.Name},AnatModifiedList{i,1});
    IndAnatSource = strcmp({tempBODY.SEGMENT(IndSegSource).AnatomicalLandmark.Name},AnatModifiedList{i,2});
    IndSegDest = strcmp({BODY.SEGMENT.Name},AnatModifiedList{i,1});
    IndAnatDest = strcmp({BODY.SEGMENT(IndSegDest).AnatomicalLandmark.Name},AnatModifiedList{i,2});
    if sum(IndAnatDest) > 0
        BODY.SEGMENT(IndSegDest).AnatomicalLandmark(IndAnatDest).ClusterFrameCoordinates = ...
            tempBODY.SEGMENT(IndSegSource).AnatomicalLandmark(IndAnatSource).ClusterFrameCoordinates;    
    else
        IndAnatDest = length(BODY.SEGMENT(IndSegDest).AnatomicalLandmark) + 1;
        BODY.SEGMENT(IndSegDest).AnatomicalLandmark(IndAnatDest).Name = ...
            tempBODY.SEGMENT(IndSegSource).AnatomicalLandmark(IndAnatSource).Name;
        BODY.SEGMENT(IndSegDest).AnatomicalLandmark(IndAnatDest).ClusterFrameCoordinates = ...
            tempBODY.SEGMENT(IndSegSource).AnatomicalLandmark(IndAnatSource).ClusterFrameCoordinates;
    end
end




% ----------- Sub-functions ---------------------

function [R,O] = CreateFrameFromCluster(markersData)

nF = size(markersData,3);
R = zeros(3,3,nF);
O = zeros(3,nF);
for i = 1 : nF
    [dummy1, T] = LocalReferenceFrame(squeeze(markersData(:,1:3,i)));
    R(:,:,i) = T(1:3,1:3);
    O(:,i) = T(1:3,4);
end


function [inc,dev,I,n,C] = Gamage(TrP,or)
% ------------------------------------------------------------------------------------------
% Description: [inc,dev,I,n,C] = Gamage(TrP,or)C
% ------------------------------------------------------------------------------------------
% INPUT: TrP clean matrix containing markers'trajectories in the proximal system of reference.
%            dim(TrP)=Nc*3p where Nc is number of good samples and p is the number of distal markers
%        or: 0 if the deviation is referred to the horizontal plane and the intersection to the sagittal plane(TC)
%            1 if the deviation is referred to the sagittal plane and the intersection to the horizontal plane (ST)
%
% OUTPUT: Cm vector with the coordinates of hip joint center (Cx,Cy,Cz) (column vector).
%------------------------------------------------------------------------------------------
% Comments: metodo1b extracts HJC position as the centre of the optimal spherical suface that minimizes the root mean square error 
%           between the radius(unknown) and the distance of the centroid of marker's coordinates from sphere center(unknown).
%           Using definition of vector differentiation is it possible to put the problem in the form: A*Cm=B that is a
%           linear equation system
% References: Gamage, Lasenby J. (2002).
%             New least squares solutions for estimating the average centre of rotation and the axis of rotation.
%             Journal of Biomechanics 35, 87-93 2002   
%------------------------------------------------------------------------------------------
[r c]=size(TrP);
D=zeros(3);
V1=[];
V2=[];
V3=[];
b1=[0 0 0];
for j=1:3:c
    d1=zeros(3);
    V2a=0;
    V3a=[0 0 0];
    for i=1:r 
        d1=[d1+TrP(i,j:j+2)'*(TrP(i,j:j+2))];       %  dim(b)=3*3
        a=(TrP(i,j).^2+TrP(i,j+1).^2+TrP(i,j+2).^2);
        V2a=V2a+a;     % dim(V2a)=1
        V3a=V3a+a*TrP(i,j:j+2);     %dim(V3a)=1*3
    end
    D=D+(d1/r);     %  dim(D)=3*3
    V2=[V2,V2a/r];  % dim(V2a)=1*p    
    b1=[b1+V3a/r];      % dim(b1)=1*3
end
V1=mean(TrP);      % dim(V1)=1*(3P)
p=size(V1,2);
e1=0;
E=zeros(3);
f1=[0 0 0];
F=[0 0 0];
for k=1:3:p
 e1=V1(k:k+2)'*V1(k:k+2);       %dim(e1)=3*3
 E=E+e1;     % dim(E)=3*3
 f1=V2((k-1)/3+1)*V1(k:k+2);       %dim(f)=1*3
 F=F+f1;      %dim(F)=1*3
end
%----------------------------------------------------------------
%Determination of a point of the axis
% equation (5) of Gamage and Lasenby
A=2*(D-E);      %dim(A)=3*3
B=(b1-F)';         %dim(B)=3*1
[U,S,V] = svd(A);
C = pinv(A)*B; % pseudoinverse of A because the rank of A is two 
%----------------------------------------------------------------
% Axis direction and intersection
n = V(:,3); 
if or == 0
    % Angle between the axis and a horizontal plane (inclination)
    inc = -(90 - acosd(n(2)));% il meno � per rifarsi alle convenzioni adottate da Lewis
    % Angle between the axis and a frontal plane (deviation)
    dev = 90 - acosd(n(1));
    % Intersection of the axis with the sagittal plane
    Ix = C(1)- C(3)*(n(1)/n(3)); 
    Iy = C(2)- C(3)*(n(2)/n(3));
    I = [Ix,Iy,0];
else
    % Angle between the axis and a horizontal plane (inclination)
    inc = 90 - acosd(n(2));
    % Angle between the axis and a sagittal plane (deviation)
    dev = -(90 - acosd(n(3)));
    % Intersection of the axis with the horizontal plane
    Ix = C(1)- C(2)*(n(1)/n(2));
    Iz = C(3)- C(2)*(n(3)/n(2));
    I = [Ix,0,Iz];
end








