%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function StylusTip=LoadProbing(infotext);
% LOADPROBING [ BodyMech 3.06.01 ]: Import probing data from Optotrakfile  (*.NDF)
% INPUT
%   Data from probing file
% PROCESS
%   Calculates StylusTip coordinates
% OUTPUT
%   StylusTip

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader
X=1;
StylusTip=NaN;

FileExtension='*.*';

if nargin < 1,
WindowHeader=['open file'];
else
    WindowHeader=['open file (',infotext,')'];
end

datafile=BMimportNdf(FileExtension,WindowHeader);

if datafile ~= 0
    
    AssignMarkerDataToStylus;
    [Ncoords,Nmarkers,Nsamples]=size(BODY.CONTEXT.Stylus.KinematicsMarkers);
    StylusTip=NaN*zeros(Ncoords,Nsamples);
    
    for iSample=1:Nsamples,
        % use only sample-instants with all markers visible
        if  Nmarkers==sum(~isnan(BODY.CONTEXT.Stylus.KinematicsMarkers(X,:,iSample)));
            
            % StylusTipCalculation
            StylusTip=feval(BODY.CONTEXT.Stylus.ToTipFunction, ... 
                BODY.CONTEXT.Stylus.KinematicsMarkers(:,:,iSample)); 
            return
        end
    end
end

warndlg({'LoadProbing';' ';...
        'Stylus_tip coordinates could not be calculated';... 
    },...
    '** BODYMECH WARNING **') 
return

%=========================================================================
% END ### LoadProbing ###
