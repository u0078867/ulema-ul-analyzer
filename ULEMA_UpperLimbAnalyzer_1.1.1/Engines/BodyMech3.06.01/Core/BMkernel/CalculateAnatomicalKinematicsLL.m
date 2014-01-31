%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function CalculateAnatomicalKinematics
% CALCULATEANATOMICALKINEMATICS [ BodyMech 3.06.01 ]: Calls an m-file with specific calculations
% INPUT
%   none
% PROCESS
%   Loads and calls an m-file with specific anatomical calculations
% OUTPUT
%   GLOBAL BODY.CONTEXT.AnatomicalCalculationFunction

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 3.0 New BODY field names (VUmc, Amsterdam, August 2004)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

BodyMechFuncHeader

% get file name
% ==============================================
if isfield(BODY.CONTEXT,'AnatomicalCalculationFunction'),
    if ~isempty(BODY.CONTEXT.AnatomicalCalculationFunction);
        AnatCalcFilename=BODY.CONTEXT.AnatomicalCalculationFunction;
        AnatCalcFilename=strrep(AnatCalcFilename,'.m',''); % remove file extension ".m"
        [filename,pathname] = uigetfile([char(AnatCalcFilename),'.m'],'run BodyMech Anatomical Calculation Fcn');
    end

else

    [filename,pathname] = uigetfile('*.m', 'run BodyMech Anatomical Calculation Fcn');
end

% read BODY
if filename ~= 0
    BODY.CONTEXT.AnatomicalCalculationFunction=char(filename);
    cd(pathname);
    filename=strrep(filename,'.m',''); % remove file extension ".m"
    eval(filename);
    %ClearKinematics('joints'); oboslete now
else
    return
end

BodyMechFuncFooter
return
% ============================================
% END ### CalculateAnatomicalKinematics ###
