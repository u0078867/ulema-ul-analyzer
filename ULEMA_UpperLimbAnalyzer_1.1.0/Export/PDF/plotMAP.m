%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function fig = plotMAP(data, visible, rot, ti)

% Get headers from data
labelNames = data(1,2:end);
% Transpose cell-matrix
data = data';   % data is per row, columns are: median, iqr+, iqr-, median (control), iqr+ (control), iqr- (control)
% Get rid of the non-numeric data in the table
data = cell2mat(data(2:end,2:end));
% Create the figure
fig = figure('Visible',visible);
% Plot non-control data bars (light blue, thick)
nonControlData = data(:,1);
bar(nonControlData,'BarWidth',0.5,'FaceColor',[0.6784 0.9216 1.0000]);
hold on
% Plot control data bars (black, narrow)
controlData = data(:,4);
bar(controlData,'BarWidth',0.25,'FaceColor',[0.3 0.3 0.3]);
% Plot the IQR as horizontal lines
for i = 1 : size(data,1)
    plotIQR(i,data(i,1),data(i,2),data(i,3),'b');
    plotIQR(i,data(i,4),data(i,5),data(i,6),'r'); 
end
% Add labels
set(gca,'XTickLabel',labelNames);
% Rotate labels if necessary
if rot ~= 0
    % Get current tick labels
    ax = gca;
    while rot < 0
        rot = rot+360;
    end
    a = get(ax,'XTickLabel');
    % Erase current tick labels from figure
    set(ax,'XTickLabel',[]);
    % Get tick label positions
    b = get(ax,'XTick');
    c = get(ax,'YTick');
    % Make new tick labels
    if rot < 180
        text(b,repmat(c(1)-.1*(c(2)-c(1)),length(b),1),a,'HorizontalAlignment','right','rotation',rot);
    else
        text(b,repmat(c(1)-.1*(c(2)-c(1)),length(b),1),a,'HorizontalAlignment','left','rotation',rot);
    end
    p = get(gca,'Position');
    set(gca,'Position',[p(1),p(2)*2.5,p(3),p(4)*0.8]);
end
% Add title
title(ti,'interpreter','none');

% Subfunctions
function plotIQR(x,median,iqrUp,iqrDo,color)
vLineX = [x, x];
vLineY = [median+iqrUp,median-iqrDo];
plot(vLineX,vLineY,[color,'-']);
hl = 0.08;
hLineUpX = [x-hl,x+hl];
hLineUpY = [median+iqrUp,median+iqrUp];
plot(hLineUpX,hLineUpY,[color,'-']);
hLineDoX = [x-hl,x+hl];
hLineDoY = [median-iqrDo,median-iqrDo];
plot(hLineDoX,hLineDoY,[color,'-']);

