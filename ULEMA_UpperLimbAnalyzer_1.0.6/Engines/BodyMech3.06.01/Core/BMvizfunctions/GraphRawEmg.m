%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function GraphRawEmg
% GRAPHRAWEMG [ BodyMech 3.06.01 ]: plots Raw Emg Signals (only availbale when importing Dar Files)
% INPUT
%   GLOBAL :BODY.MUSCLE(..).Emg.Signal
%   USER:  selection of muscles
% PROCESS
%  plots SRE-signals:
%         a plot-axis for each selected muscle
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

% PROCESS
Nmuscles=length(BODY.MUSCLE);
if Nmuscles>=1,
    MuscleSelection=[];

    str={BODY.MUSCLE.Name};
    [MuscleSelection,ok] = listdlg('PromptString','Select a MUSCLE:',...
        'SelectionMode','multiple',...
        'ListString',str);
    if ok==1,
        NselectedMuscles=size(MuscleSelection,2);

        scrsz = get(0,'ScreenSize');
        scr_width=scrsz(3);
        scr_heigth=scrsz(4);
        stHeader=75;
        border=20;
        margin=5;

        VerticalSpace=scr_heigth-border-stHeader;
        FigSize=[scr_width-border-margin VerticalSpace/(8/NselectedMuscles)];
        FigOrigin=[border border ];
        h=figure('Units','pixels',...
            'Name',['Raw EMG signals'],...
            'NumberTitle','off',...
            'Position',[FigOrigin FigSize]);
        set(h,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');


        iAxis=0;

        for iMuscleSel=1:NselectedMuscles,
            iMuscle=MuscleSelection(iMuscleSel);
            if iMuscle>=1 & iMuscle <=Nmuscles,
                if ~isempty(BODY.MUSCLE(iMuscle).Name),
                    if ~isempty(BODY.MUSCLE(iMuscle).Emg.Signal),


                        Nsamples=length(BODY.MUSCLE(iMuscle).Emg.Signal);

                        iAxis=iAxis+1;
                        subplot(NselectedMuscles,1,iAxis)

                        Sfreq=1/BODY.MUSCLE(iMuscle).Emg.TimeGain;
                        time=[1/Sfreq:1/Sfreq:Nsamples/Sfreq];

                        plot(time,BODY.MUSCLE(iMuscle).Emg.Signal,'b');

                        % title:
                        Axranges=axis;
                        xmin=Axranges(1); xmax=Axranges(2);
                        ymin=Axranges(3); ymax=Axranges(4);
                        title(BODY.MUSCLE(iMuscle).Name...
                            ,'position',[(xmax+xmin)/2 ymax 0]...
                            ,'VerticalAlignment','top'...
                            )

                    end
                end
            end
        end
    end
end

return
% ============================================
% END ### GraphRawEmg ###
