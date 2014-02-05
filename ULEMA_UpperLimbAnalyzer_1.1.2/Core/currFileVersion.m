%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function version = currFileVersion()

% ULEMA 1.0.6 (first open-source release)
% version = 3;

% ULEMA 1.1.0
% - MHA field data added to subjects(i).sessions(j).trials(k)
% - DJC{i,3} changed structure: field data has 2 subfields, points and freq
% - DJC{i,4}.data contains now global coordinates for pivot point (and not local anymore)
version = 4;

