%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function InterpolateMarkerKinematics_ADV(method)
% INTERPOLATEMARKERKINEMATICS [ BodyMech 3.06.01 ]: interpolates all marker-signalsarray 
% INPUT
%   GLOBAL: BODY.SEGMENT(..).Cluster.KinematicsMarkers
%   GLOBAL: BODY.SEGMENT(..).Cluster.RecordedMarkers
%   CriticalHole : warninglevel
%   method: string indicating the method to use for interpolation:
%       'GCVSPL': Woltring spline (GCVSPL.dll file needed, only for WinXP)
%       'Cubic': cubic spline
% PROCESS
%   Interpolates "holes" in the signal and, if method GCVSPL is used, also
%   smoothes the signal.
% OUTPUT
%   GLOBAL: BODY.SEGMENT(..).Cluster.KinematicsMarkers
%   GLOBAL: BODY.SEGMENT(..).Cluster.AvailableMarkers

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

warning('off','MATLAB:dispatcher:InexactMatch')
% declaration
BodyMechFuncHeader

% initialisation 

Nsegments=length(BODY.SEGMENT);
if Nsegments > 0,  
   for iSegment=1:Nsegments, % for each segment
      if ~isempty( BODY.SEGMENT(iSegment).Name),
         if ~isempty(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers),
            [Ndim,Nmarkers,Nsamples]=size(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers);
            SegmentHoles=cell([1,Nmarkers]);
            
            for iMarker=1:Nmarkers,
                              
               Array=BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,iMarker,:);
               
               
               % == search holes ==
               holes=FindHoles(Array);
               % holes(j,:)= [StartIndex Magnitude] of the j-th hole
               holes=sortrows(holes,2); % in ascending order of magnitude
               SegmentHoles(iMarker)={holes(:,:)};
               % This information might be used to feedback to the user
               % == end == seach holes ==
            
               % == interpolate each dimension
               
               Sfreq=1/BODY.SEGMENT(iSegment).Cluster.TimeGain;
               time=[1/Sfreq:1/Sfreq:Nsamples/Sfreq];
               
               func=shiftdim(BODY.SEGMENT(iSegment).Cluster.RecordedMarkers(iMarker,:));
               
               MarkerTrace=shiftdim(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,iMarker,:),1);  
               switch method
                   case 'GCVSPL'
                    BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,iMarker,:)=GCVSPL(time,MarkerTrace,func);
                   case 'Cubic'
                    BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,iMarker,:)=CubicSpline(MarkerTrace);
               end
               
               MarkerTrace=shiftdim(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(Y,iMarker,:),1);   
               switch method
                   case 'GCVSPL'
                    BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(Y,iMarker,:)=GCVSPL(time,MarkerTrace,func);
                   case 'Cubic'
                    BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(Y,iMarker,:)=CubicSpline(MarkerTrace);
               end
               
               MarkerTrace=shiftdim(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(Z,iMarker,:),1); 
               switch method
                   case 'GCVSPL'
                    BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(Z,iMarker,:)=GCVSPL(time,MarkerTrace,func);
                   case 'Cubic'
                    BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(Z,iMarker,:)=CubicSpline(MarkerTrace);
               end
               
               
               % == derive BODY.SEGMENT(iSegment).Cluster.AvailableMarkers
               
               MarkerTrace=shiftdim(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,:,:));
               
               NanArray=isnan(MarkerTrace);
               BODY.SEGMENT(iSegment).Cluster.AvailableMarkers(iMarker,:)=...
                  NanArray(iMarker,:).*MarkerTrace(iMarker,:)+1;
               
            end % next marker
         end % no marker kinematics
      end % no segment.name
   end % next segment
else % no BODY.SEGMENTS
   return
end

% OUTPUT     
% 
%

return
% ============================================ 
% END ### InterpolateMarkerKinematics ###


function holes=FindHoles(Array);
% FindHoles(BodyMech.m_): searches for continuous segments of NaN 

% INPUT
% Array : The array with certain NaN 
% CriticalHole : warninglevel
% PROCESS
% finds continuous segments of NaN -NotANumber-("holes") in Array 
% OUTPUT
% holes(i,1) = index of 1st NaN of i-th hole
% holes(i,2) = magnitude of i-th hole


% AUTHOR(S) AND VERSION-HISTORY
% Creation (name author, month year)

[Ndim,Nsamples]=size(Array);

holes=zeros(0,2);

j=1; % hole counter

i=1;  % array index
while i<=Nsamples,
   if isnan(Array(1,i))  % only the first dimension of A is used for isnan
      holes(j,1)=i;
      holes(j,2)=1;
      k=i+1;    % array index during hole
      if k>=Nsamples, return, end;
      while isnan(Array(1,k)),
         k=k+1;
         if k>Nsamples, break, end;
      end
      holes(j,2)=k-i; % magnitude of the j-th hole
      i=k+1;
      j=j+1; 
   else
      i=i+1;
   end
end
return
% ============================================ 
% END ### InterpolateMarkerKinematics ###

function X = CubicSpline(X)
% Interpolate over NaNs using cubic spline
X(isnan(X)) = interp1(find(~isnan(X)), X(~isnan(X)), find(isnan(X)), 'cubic'); 


