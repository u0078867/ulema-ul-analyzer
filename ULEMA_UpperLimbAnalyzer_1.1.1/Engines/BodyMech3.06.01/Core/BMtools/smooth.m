%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ssign=smooth(signal,Fc,Fs,symmetric)
% SMOOTH : smoothes a signal (lowpass filter)
% INPUT
%    Input : Signal: any one dimensional array
%         Fc    : Low pass cut-off frequency
%         Fs    : sample freqency of Signal  (default: 1000 Hz)
%         symmetric: 0 = one pass filter (default)
%                    1 = twopass (bidirectional)
% PROCESS
%   2nd order low pass butterworth filter (symmetric=0) 
%          or 4th order low pass butterworth filter, no phase lag (symmetric=1)
% OUTPUT
%   the smoothed signal

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

if nargin <= 2, Fs=1000.;symmetric=0.; end

if Fs < Fc, % wrong sequence
    temp=Fs;
    Fs=Fc;
    Fc=temp;
    clear temp
    % application warning to user
end
Fs=Fs/2;  

if symmetric==1,
% zero phaselag; 
   Fc=Fc/.805;  % conserve net fc for bidirectional application of the filter
    
   [b,a]=butter(2,Fc/Fs); % symmetric smoothing filter @ fc hz. 
   ssign=filtfilt(b,a,signal); % net 4th order lowpass
   
else
    
    [b,a]=butter(2,Fc/Fs); % smoothing filter @ fc hz.
    ssign=filter(b,a,signal);  % 2nd order lowpass
end
 
return
% ============================================ 
% END ### smooth ###
