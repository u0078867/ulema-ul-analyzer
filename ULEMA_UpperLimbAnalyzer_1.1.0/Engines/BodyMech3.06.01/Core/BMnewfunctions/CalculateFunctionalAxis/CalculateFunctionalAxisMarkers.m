%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%


function CalculateFunctionalAxisMarkers()

BodyMechFuncHeader

Nsegm=length(BODY.SEGMENT);
for iSegm=1:Nsegm,
    
    if isfield(BODY.SEGMENT(iSegm),'FunctionalAxis')
        
        NfunAxis=length(BODY.SEGMENT(iSegm).FunctionalAxis);
        for iFuncAxis=1:NfunAxis,

            Nsamples=size(BODY.SEGMENT(iSegm).Cluster.KinematicsMarkers,3);
            for iSample=1:Nsamples,

                % Create Marker1 and Marker2 lying on nopt

                Distance = 10; % mm: distance of Marker1 and Marker2 from sopt, along nopt 
                
                M = BODY.SEGMENT(iSegm).Cluster.KinematicsPose(:,:,iSample);
                M(1:3,4) = 0;

                BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Marker1.Name = [BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Name, 'Marker1'];
                BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Marker1.Kinematics(:,iSample)=...
                    Transform(BODY.SEGMENT(iSegm).Cluster.KinematicsPose(:,:,iSample),  ... 
                    BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Data.sopt) ...
                    + Distance * Transform(M, BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Data.nopt);

                BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Marker2.Name = [BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Name, 'Marker2'];
                BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Marker2.Kinematics(:,iSample)=...
                    Transform(BODY.SEGMENT(iSegm).Cluster.KinematicsPose(:,:,iSample),  ... 
                    BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Data.sopt) ...
                    - Distance * Transform(M, BODY.SEGMENT(iSegm).FunctionalAxis(iFuncAxis).Data.nopt);
            end

        end
    end
    
end



