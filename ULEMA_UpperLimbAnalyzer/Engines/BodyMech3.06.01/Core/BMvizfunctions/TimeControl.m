%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function TimeControl
% TIMECONTROL [ BodyMech 3.06.01 ]: invoked when GUI timecontrol is manipulated
% INPUT
%    Input :  relative or absolute time-instance from GUI-control 
% PROCESS
%   calculates time and calls updating functions
% OUTPUT
%   

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

CurrentTime=VIZ.TIME;
NewTime=CurrentTime;

%% TODO: centraal uitrekenen
TimeSpan=length(BODY.SEGMENT(1).Cluster.KinematicsMarkers)-1).* BODY.SEGMENT(1).Cluster.TimeGain;
TimeOffset=BODY.SEGMENT(1).Cluster.TimeOffset

%% scan all time control sources
GUIsourceRel={'OrthoSlider'};
GUIsourceAbs={'TimeDisplay'};

iSource=1;
while iSource <=length(GUIsourceRel) & NewTime==CurrentTime;
    h=findobj('Tag',GUIsourceRel(iSource));
    dot=get(h,'value');
    NewTime=TimeOffset+dot*TimeSpan;
    iSource=iSource+1;
end

iSource=1;
while iSource <=length(GUIsourceAbs) & NewTime==CurrentTime;
    h=findobj('Tag',GUIsourceAbs(iSource))
    NewTime=get(h,'value');
    NewTime=max(NewTime,TimeOffset);
    NewTime=min(NewTime,(TimeOffset+TimeSpan));
    iSource=iSource+1;
end

%% process newTime
if NewTime~=CurrentTime;    
 
set(findobj('Tag','TimeDisplay'),'String',num2str(iTime));
%============================================================
% END ### TimeControl ###
