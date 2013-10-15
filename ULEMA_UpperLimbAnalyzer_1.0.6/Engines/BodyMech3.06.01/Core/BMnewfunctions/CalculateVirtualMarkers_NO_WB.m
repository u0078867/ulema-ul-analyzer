%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CalculateVirtualMarkers_NO_WB()
% CALCULATEVIRTUALMARKERS [ BodyMech 3.06.01 ]: generates virtual marker coordinates from anatomical markers
% INPUT
%    Input : none
% PROCESS
%   generates virtual marker coordinates from anatomical markers for visualisation
% OUTPUT
%   GLOBAL  BODY.SEGMENT(iSegm).AnatomicalLandmark(iAnatMarker).Kinematics
%           BODY.SEGMENT(iSegm).AnatomicalLandmark(iAnatMarker).TimeGain
%           BODY.SEGMENT(iSegm).AnatomicalLandmark(iAnatMarker).TimeOffset

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

[ndim Nmarkers Nsamples]=size(BODY.SEGMENT(1).Cluster.KinematicsPose);

if Nsamples==0, return, end

Nsegm=length(BODY.SEGMENT);

% intialisation
for iSegm=1:Nsegm,
    nLandmarks=length(BODY.SEGMENT(iSegm).AnatomicalLandmark);
    for iLandmark=1:nLandmarks,
        BODY.SEGMENT(iSegm).AnatomicalLandmark(iLandmark).Kinematics=zeros(3,1);
    end
end

% calculation
% waitbar_txt=['BodyMech calculus for Virtual markers,  please wait...'];
% h_waitbar = waitbar(0,waitbar_txt);

for iSegm=1:Nsegm,
    NanatMarkers=length(BODY.SEGMENT(iSegm).AnatomicalLandmark);
    for iAnatMarker=1:NanatMarkers,
        if ~isempty(BODY.SEGMENT(iSegm).AnatomicalLandmark(iAnatMarker).ClusterFrameCoordinates)
            
            Nsamples=size(BODY.SEGMENT(iSegm).Cluster.KinematicsPose,3);
            for iSample=1:Nsamples,
%                 if iSample > Nsamples/10*ceil(iSample*10/Nsamples), 
%                     waitbar(iSample/Nsamples);
%                 end
                
                BODY.SEGMENT(iSegm).AnatomicalLandmark(iAnatMarker).Kinematics(:,iSample)=...
                    Transform(BODY.SEGMENT(iSegm).Cluster.KinematicsPose(:,:,iSample),  ... 
                    BODY.SEGMENT(iSegm).AnatomicalLandmark(iAnatMarker).ClusterFrameCoordinates);
            end
            BODY.SEGMENT(iSegm).AnatomicalLandmark(iAnatMarker).TimeGain=BODY.SEGMENT(iSegm).Cluster.TimeGain;
            BODY.SEGMENT(iSegm).AnatomicalLandmark(iAnatMarker).TimeOffset=BODY.SEGMENT(iSegm).Cluster.TimeOffset;
            
        end
    end
    
    
end
% close(h_waitbar)

return
%==========================================================================
% END ### CalculateVirtualMarkers ###
