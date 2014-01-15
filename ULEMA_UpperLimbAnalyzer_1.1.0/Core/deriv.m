%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function curve_der = deriv(curve, varargin)
toFilter = varargin{1};
dt = varargin{2};
if toFilter == 1
    f_cut = varargin{3}; %Hz
    order = varargin{4};
    f=1/(2*dt);
    [B,A] = butter(order,f_cut/f,'low');
    curve_filtered = filtfilt(B,A,curve);
else
    curve_filtered = curve;
end
curve_der = diff(curve_filtered)'/dt; % first derivative
curve_der = [curve_der(1); curve_der'];

