%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [datafile,CollDate,CollTime]=LoadNdf(FileExtension,WindowHeader)
% LOADNDF : loads an 3D Optotrak File
% INPUT 
%    Input : FileExtension,WindowHeader
% PROCESS
%   loads an 3D Optotrak File
% OUTPUT
%   

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

if nargin < 2,
   WindowHeader='open NDF (OptoTrak) file';
end
if nargin < 1,
   FileExtension='*.*';
end

% == invoke the filebrowser
[datafile,datapath] = ...
   uigetfile(FileExtension,WindowHeader);


if datafile ~= 0
   % == read the data from file
   [OTdata,SampleFrequency,CollDate,CollTime]=ReadNdf(datapath,datafile);
   
   MARKER_DATA=OTdata./1000; % mm. to m.
   MARKER_TIME_OFFSET=0.; 
   MARKER_TIME_GAIN=1./SampleFrequency;
   
   % [n_coordinates,n_markers,n_samples]=size(MARKER_DATA);
   
   % == set path for subsequent file-access
   eval(['cd ',datapath]);
else
   return
end

BodyMechFuncFooter
return
% ============================================ 
% END ### LoadNdf ###
