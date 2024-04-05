%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

% Marker indices are took from the list of markers in the BodyModel file
StylusGeometry.DistancesToTip = [80 300 0 0];
CreateStylus('Stylus',6,[iP(1) iP(2) iP(3) iP(4)],'PointerP12only',StylusGeometry);

