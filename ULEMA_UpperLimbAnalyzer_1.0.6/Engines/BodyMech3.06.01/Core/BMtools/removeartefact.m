%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ssign=removeartefact(signal,Fc,Fs)
% REMOVEARTEFACT : reduces low frequency artefacts ( high-pass filter)
% INPUT : Signal: any one dimensional array
%         Fc    : Low pass cut-off frequency (default: 10 Hz) 
%         Fs    : sample freqency of Signal  (default: 1000 Hz)
% PROCESS: 3rd order high pass butterworth filter 
% OUTPUT:  signal with reduced lowfreq.artefacts

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

ssign=[];

if nargin < 3, Fs=1000.; end
if nargin < 2, Fc=10.; end
if nargin < 1, return, end

if Fs < Fc, % wrong sequence
    temp=Fs;
    Fs=Fc;
    Fc=temp;
    clear temp
end

[b,a]=butter(3,Fc/(Fs/2),'high'); % high pass filter coeff. @ Fc Hz.
ssign=filter(b,a,signal);

return
% ============================================ 
% END ### removeartefact ###
