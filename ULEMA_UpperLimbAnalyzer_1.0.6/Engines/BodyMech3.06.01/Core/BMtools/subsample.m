%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function  SubSampledSignal=subsample(Signal,SourceFrq,DestFrq,Bandwith)
% SUBSAMPLE : resamples an equidistant timeseries
% in case of downsampling, Nyquist' criterion is preserved
% INPUT
% Signal         : Original timeseries
% SourceFrq      : sample frequency of original timeseries
% DestFrq        : target sample frequency
% Bandwith       : Forced bandwith of the target signal relative to DestFrq 
%                 (default=.3, i.e the Nyquist criterion (.5) at the safe side)
% PROCESS
% resamples an equidistant timeseries
% lowpass filtering will prevent undersampling
% OUTPUT
% SubSampledSignal : New time series, at 1/DestFrq time intervals
 
% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 2003)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

if nargin < 3, 
    wrndlg('not enough parameters to subsample' ); 
    NewSignal=Signal;
    return
end
if nargin < 4, Bandwith=.3; end

FrqRatio=SourceFrq/DestFrq;

if FrqRatio > 1  &  Bandwith > 0 ,
    
    Fc=Bandwith*DestFrq;
    Fs=SourceFrq;
    Fc=Fc/.805;  % conserve net fc for bidirectional application of the filter
    [b,a]=butter(2,Fc/(Fs/2)); % symmetric smoothing filter @ fc hz. 
    Signal=filtfilt(b,a,Signal); % net 4th order lowpass
end

OldSampleSpan=length(Signal)-1;
NewSampleSpan=floor(OldSampleSpan/FrqRatio);
NewTimeBase=[1:NewSampleSpan+1]; % 0-based vs. 1-based

OldTimeBase=[1:length(Signal)]-1; 
OldTimeBaseNew=OldTimeBase./FrqRatio+1; % 0-based vs. 1-based

SubSampledSignal=interp1(OldTimeBaseNew',Signal',NewTimeBase','cubic');

return
% ###########################################
% END SubSample

% ###########################################
% NON FUNCTIONAL CODE BELOW
% COPY AND PASTE INTO THE COMMAND WINDOW FOR A DEMO
  
a=sin([1:1:13800]*.001);
b=subsample(a,1120,10,.3);
 
newtimebase=([1:124]-1.)*1120/10+1;
 
figure(1), clf
plot([1:13800],a);
hold on
plot(newtimebase,b,'r*')
 
% effect van het smoothen:
aa=a+(.2.*rand([1 13800])-.1); % add some noise
b=subsample(aa,1120,10,.3); 
c=subsample(aa,1120,10,0);

figure(2), clf
plot(aa), hold
plot(newtimebase,b,'r*')
plot(newtimebase,c,'g*')
 
figure(3), clf
plot(a), hold
plot(newtimebase,b,'r*')
 
figure(4), clf
plot(a), hold
plot(newtimebase,c,'g*')
%==========================================================================
% END ### subsample ###
