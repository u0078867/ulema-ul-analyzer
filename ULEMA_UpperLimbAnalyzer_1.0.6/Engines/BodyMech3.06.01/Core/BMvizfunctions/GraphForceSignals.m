%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function GraphForceSignals
% GRAPHFORCESIGNALS [BodyMech 3.06.01]: plots ForceSignals (only availbale when importing Dar Files)
% INPUT
%   GLOBAL :BODY.CONTEXT.ExternalForce.Signals
% PROCESS
%  plots GroundReactionForce-signals
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

% declaration
BodyMechFuncHeader
figure(90)

% PROCESS
Nsignals=length(BODY.CONTEXT.ExternalForce.Signals);

if ~isempty(BODY.CONTEXT.ExternalForce.Name),
    if ~isempty(BODY.CONTEXT.ExternalForce.Signals),

        Nsamples=length(BODY.CONTEXT.ExternalForce.Signals);
        subplot(1,1,1)

        Sfreq=1/BODY.CONTEXT.ExternalForce.TimeGain;
        time=[1/Sfreq:1/Sfreq:Nsamples/Sfreq];

        P=plot(time,BODY.CONTEXT.ExternalForce.Signals(1:3,:));
        set(P,'LineWidth',2)
        hold on
        plot(time,zeros(length(time)),'k-')

        % title:
        Axranges=axis;
        xmin=Axranges(1); xmax=Axranges(2);
        ymin=Axranges(3); ymax=Axranges(4);
        title(BODY.CONTEXT.ExternalForce.Name...
            ,'position',[(xmax+xmin)/2 ymax 0]...
            ,'VerticalAlignment','top'...
            )
 
    end
end

return
% ============================================
% END ### GraphForceSignals ###
