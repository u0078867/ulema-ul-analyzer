%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function GraphMarkers
% GRAPHMARKERS [ BodyMech 3.06.01 ]: Plots marker trajectories
% INPUT
%   GLOBAL :BODY.SEGMENT(..).Cluster.KinematicsMarkers
%   GLOBAL :BODY.SEGMENT(..).Cluster.RecordedMarkers
%   USER:  selection of segments
% PROCESS
%   plots marker trajectories:
%         a figure for each selected segment
%         a plot-axis for each marker
%         interpolated markers in red

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

% declaration
BodyMechFuncHeader

% PROCESS
Nsegments=length(BODY.SEGMENT);
if Nsegments>=1,
    SegmentSelection=[];

    str={BODY.SEGMENT.Name};
    [SegmentSelection,ok] = listdlg('PromptString','Select a SEGMENT:',...
        'SelectionMode','single',...
        'ListString',str);
    if ok==1,
        NselectedSegments=size(SegmentSelection,2);

        scrsz = get(0,'ScreenSize');
        set(0,'DefaultAxesFontSize',8,'DefaulttextInterpreter','none');

        scr_width=scrsz(3);
        scr_heigth=scrsz(4);
        stHeader=75;
        border=10;
        margin=5;

        %         FigSize=[scr_width-NselectedSegments*border-margin...
        %         scr_heigth-NselectedSegments*border-stHeader];

         FigSize=[scr_width-border-margin...
             scr_heigth-border-stHeader];
         
        for iSelSegm=1:NselectedSegments,
            iSegment=SegmentSelection(iSelSegm);
            if iSegment>=1 & iSegment <=Nsegments,
                if ~isempty( BODY.SEGMENT(iSegment).Name),
                    if ~isempty(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers),
                        FigOrigin=[iSelSegm*border (NselectedSegments-iSelSegm+1)*border+margin];

                        h(iSelSegm)=figure('Units','pixels',...
                            'Name',[BODY.SEGMENT(iSegment).Name,'-Markers'],...
                            'NumberTitle','off',...
                            'Position',[FigOrigin FigSize]);


                        [Ndim,Nmarkers,Nsamples]=size(BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers);

                        Ngraphs=Nmarkers*4-1;

                        for iMarker=1:Nmarkers,

                            Sfreq=1/BODY.SEGMENT(iSegment).Cluster.TimeGain;
                            time=[1/Sfreq:1/Sfreq:Nsamples/Sfreq];

                            subplot(Ngraphs,1,(iMarker-1)*4+1)
                            Array=BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(X,iMarker,:);
                            Array=shiftdim(Array,1);
                            plot(time,Array,'r');

                            Array=BODY.SEGMENT(iSegment).Cluster.RecordedMarkers(iMarker,:).*Array;
                            Array=shiftdim(Array);
                            hold on
                            plot(time,Array,'b');
                            title(['Marker ',int2str(iMarker),' [X Y Z]']);

                            subplot(Ngraphs,1,(iMarker-1)*4+2)
                            Array=BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(Y,iMarker,:);
                            Array=shiftdim(Array,1);
                            plot(time,Array,'r');

                            Array=BODY.SEGMENT(iSegment).Cluster.RecordedMarkers(iMarker,:).*Array;
                            Array=shiftdim(Array,1);
                            hold on
                            plot(time,Array,'b');

                            subplot(Ngraphs,1,(iMarker-1)*4+3)
                            Array=BODY.SEGMENT(iSegment).Cluster.KinematicsMarkers(Z,iMarker,:);
                            Array=shiftdim(Array,1);
                            plot(time,Array,'r');

                            Array=BODY.SEGMENT(iSegment).Cluster.RecordedMarkers(iMarker,:).*Array;
                            Array=shiftdim(Array,1);
                            hold on
                            plot(time,Array,'b');
                        end
                    end
                end
            end
        end
    end
end

return
% ============================================
% END ### GraphMarkers ###
