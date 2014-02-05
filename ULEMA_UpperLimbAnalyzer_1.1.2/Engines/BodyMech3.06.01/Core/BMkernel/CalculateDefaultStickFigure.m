%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CalculateDefaultStickFigure()
% CALCULATEDEFAULTSTICKFIGURE [ BodyMech 3.06.01 ]: generates default stickfigure from anatomical landmarks
% INPUT
%    Input : none
% PROCESS
%    generates default stickdiagram from anatomical landmarks for visualisation
% OUTPUT
%  GLOBAL BODY.SEGMENT(iSegm).StickFigure(iStickmarker).Kinematics

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
	if length(BODY.SEGMENT(iSegm).StickFigure)==1,   % dat is zo bij aanmaken Project en session; dus 'ongevuld'
		nStickMarkers=length(BODY.SEGMENT(iSegm).AnatomicalLandmark);
	else
		nStickMarkers=length(BODY.SEGMENT(iSegm).StickFigure);
	end

	for iStickmarker=1:nStickMarkers,
		BODY.SEGMENT(iSegm).StickFigure(iStickmarker).Kinematics=zeros(3,1);
	end
end

for iSegm=1:Nsegm,
	
	waitbar_txt=['BodyMech calculus, segment ',num2str(iSegm),' please wait...'];
	h_waitbar = waitbar(0,waitbar_txt);
	
	Nsamples=size(BODY.SEGMENT(iSegm).Cluster.KinematicsPose,3);
	nLandmarks=length(BODY.SEGMENT(iSegm).AnatomicalLandmark);
	for iSample=1:Nsamples,
		%if iSample > Nsamples/10*ceil(iSample*10/Nsamples), 
			%waitbar(iSample/Nsamples);
			%end
		
		for iStickmarker=1:nLandmarks,
			BODY.SEGMENT(iSegm).StickFigure(iStickmarker).Kinematics(:,iSample)= ...
			BODY.SEGMENT(iSegm).AnatomicalLandmark(iStickmarker).Kinematics(:,iSample);
			
			BODY.SEGMENT(iSegm).StickFigure(iStickmarker).TimeGain=BODY.SEGMENT(iSegm).AnatomicalLandmark(iStickmarker).TimeGain;
			BODY.SEGMENT(iSegm).StickFigure(iStickmarker).TimeOffset=BODY.SEGMENT(iSegm).AnatomicalLandmark(iStickmarker).TimeOffset;
		end
		
		if nLandmarks > 2,
			BODY.SEGMENT(iSegm).StickFigure(nLandmarks+1).Kinematics(:,iSample)=...
				BODY.SEGMENT(iSegm).StickFigure(1).Kinematics(:,iSample); % close drawing
		end
	end
	close(h_waitbar) 
end

return
%=======================================================================
% END ### CalculateDefaultStickFigure ###
