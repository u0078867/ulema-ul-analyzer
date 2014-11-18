%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [datafile,CollDate,CollTime]=BMimportNDF(FileExtension,WindowHeader)
% BMIMPORTNDF [ BodyMech 3.06.01 ]: Import measurement from Optotrak-file
% INPUT
%   FileExtension
%   WindowHeader
% PROCESS
%   Read data from optotrak file (ReadNdf.m)
% OUTPUT
%   GLOBAL: MARKER_DATA
%           MARKER_TIME_OFFSET
%           MARKER_TIME_GAIN

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, July 2000) 
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader
global IMPORT_NDF_DIR

if ~isempty(IMPORT_NDF_DIR),
    cd(IMPORT_NDF_DIR);
end

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
   [OTdata,SampleFrequency,CollDate,CollTime]=readNdf(datapath,datafile);
   
   MARKER_DATA=OTdata./1000; % mm. to m.
   MARKER_TIME_OFFSET=0.; 
   MARKER_TIME_GAIN=1./SampleFrequency;
   
   % [n_coordinates,n_markers,n_samples]=size(MARKER_DATA);
   
   % == set path for subsequent file-access
   IMPORT_NDF_DIR=datapath;
else
   return
end

BodyMechFuncFooter
return
% ============================================ 
% END ### BMimportNDF ###
