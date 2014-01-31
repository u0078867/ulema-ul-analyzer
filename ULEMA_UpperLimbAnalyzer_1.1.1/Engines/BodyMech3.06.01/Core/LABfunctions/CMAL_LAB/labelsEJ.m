%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% function MyMarkers
% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation; Ellen Jaspers, Herman Bruyninckx, FaBeR - Leuven, June 2007

groupnames = [ParameterGroup.name];
% this results in an array of strings. 
% To find the index for the 'POINT' group, use the following formula:
pointindex = strcmp(groupnames,'POINT');
% this will give a 1xn array where n is the number of 'groups' in the c3d file. 
% It is all zeros except for the index of the 'POINT'group 
% all we are interested in is the 'LABELS' parameter within the 'POINT'group 
% first we get the names of the 'parameters'
parameternames = [ParameterGroup(pointindex).Parameter.name];
%
% find the 'LABELS'parameter
labelindex = strcmp(parameternames,'LABELS');
%
% and get an array of point labels
LabelSequence = ParameterGroup(pointindex).Parameter(labelindex).data;
%
% this array of strings will contain the name of the first 255 markers in the c3d file. 
% the names will be in the same order as the Markers variable
% (if there are more than 255 markers, you need to look in the 'LABELS2'parameter)
%
    MyLabelSequence = {'UA1' 'UA2' 'UA3' 'UA4' 'LA1' 'LA2' 'LA3' 'LA4' 'H1' 'H2' 'H3' 'ACR1' 'ACR2' 'ACR3' 'ST1' 'ST2' 'ST3' 'SCAP1' 'SCAP2' 'SCAP3' 'P1' 'P2' 'P3' 'P4'};
    [R,S] = size(MyLabelSequence);
    [L, M, N] = size(Markers);
    MyMarkers = zeros(L,S,N);
    for i = 1:S;
    j = strmatch(MyLabelSequence(1,i), LabelSequence);
    MyMarkers(:,i,:) = Markers(:,j,:);     
end;

   
% this creates a string with a self-choosen sequence of all labels; 
% S being the size of the string
% the size of the existing Markers-matrix (nCoord, nMarkers, nVideoFrames)
% We create a new matrix marker-file (all zeros): (3, S, N) = MyMarkers
% S = nMarkers (size of the defined string) and N = nVideoFrames;
