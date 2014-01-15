%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function g = PushGlobals()

BodyMechFuncHeader

g.BODY = BODY;
g.MARKER_DATA = MARKER_DATA;
g.MARKER_TIME_GAIN = MARKER_TIME_GAIN;
g.MARKER_TIME_OFFSET = MARKER_TIME_OFFSET;
g.iP = iP;
g.ANSIGNAL_DATA = ANSIGNAL_DATA;
g.ANSIGNAL_TIME_GAIN = ANSIGNAL_TIME_GAIN;
g.ANSIGNAL_TIME_OFFSET = ANSIGNAL_TIME_OFFSET;
g.X = X;
g.Y = Y;
g.Z = Z;
g.U = U;
g.ORTHO_DISPLAY_MODE = ORTHO_DISPLAY_MODE;
g.DDD_DISPLAY_MODE = DDD_DISPLAY_MODE;
g.VIZ = VIZ;
g.VizTime = VizTime;
g.BODYSTATUS = BODYSTATUS;
