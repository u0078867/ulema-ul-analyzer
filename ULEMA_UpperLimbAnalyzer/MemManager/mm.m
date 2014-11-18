%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function mm(obj,cancel,action,H,flag)
%mm  Memory Monitor displays MATLAB runtime memory information
%
%author:  Elmar Tarajan [MCommander@gmx.de]
%version: v2.4

if nargin==0
   %
   vr = sscanf(version,'%f.');
   if vr(1)<7.0 || ~ispc
      error('Sorry...at least MATLAB R14 on Windows PC is required. :(')
   end% if
   %
   if ~isempty(findall(0,'Type','Figure','Tag','mm2'))
      disp('warning: only one instance is allowed');
   else
      H = gui_builder;
      H.Period = 1;
      mm(H.menu,'','option',H,0)
   end% if
   return
end% if
%
switch action
   case 'option'
      uicontrol(H.edit(1))
      switch get(obj,'value')
         case 1 % start / set timer period
            try
               stop(timerfindall('Tag','mm2'))
            end% try
            %
            if flag==1
               try
                  answer = inputdlg('timer period (in seconds)', ...
                     'timer settings',1,{sprintf('%.2f',H.Period)});
                  H.Period = eval(sprintf('%.2f',eval(char(answer))));
               catch
                  return
               end% try
            end% if
            %
            tmp = get(obj,'String');
            tmp{1} = sprintf('start / timer period (%gs)',H.Period);
            set(obj,'String',tmp)
            %
            H.timer = timer('Period',H.Period, ...
               'tag','mm2', ...
               'ObjectVisibility','off', ...
               'ExecutionMode','fixedSpacing');
            %
            set(H.timer,'TimerFcn' ,{@mm,'update',H,1});
            set(H.timer,'StopFcn'  ,{@mm,'stop'  ,H,1});
            set(H.main ,'DeleteFcn',{@mm,'stop'  ,H,2});
            set(H.menu ,'Callback' ,{@mm,'option',H,1});
            %
            set([H.disp H.hbar],'Enable','on')
            start(H.timer)            
            %
         case 2 % stop / refresh
            try
               stop(timerfindall('Tag','mm2'))
            end% try
            mm('','','update',H)            
            %
         case 4 % start recording data
            tmp = get(obj,'String');
            if strncmp(tmp{4},'start recording data',5)
               [fname fpath] = uiputfile('*.log','set LOG-file');
               if fpath
                  tmp{4} = sprintf('stop recording (%s)',fname);
                  set(obj,'String',tmp)
                  set(H.main,'UserData',fopen(fullfile(fpath,fname),'wt'));
                  set(obj,'value',1)
                  if isempty(timerfindall('Tag','mm2')) 
                     mm(obj,'','option',H,1)
                  end% if
                  set(H.status,'Foregroundcolor',[1 .3 .3])
               end% if
            else
               try
                  fclose(get(H.main,'UserData'));
                  set(H.status,'Foregroundcolor',[0.8 0.7 0.6])
               end
            end% if
            %
         case 5 % show recorded LOG-file
            showlog
            %
         case 7 % move window
            tmp = get(obj,'String');
            if strncmp(tmp{7},'move window',4)
               pos = get(H.main,'outerposition');
               set(H.main,'outerposition',[1 H.scr_h-pos(4)+1 pos(3:4)])
               tmp{7} = 'align to the top left corner';
            else
               set(H.main,'Position',[4 H.scr_h-76 148 77])
               tmp{7} = 'move window';
            end% if
            set(obj,'String',tmp)
            %
         case 8 % info
            answer = questdlg({'MATLAB Memory Monitor v2.4' ...
               '(c) 2007 by Elmar Tarajan [MCommander@gmx.de]'}, ...
               'about...','look for updates','Bug found?','OK','OK');
            switch answer
               case 'look for updates'
                  web(['http://www.mathworks.com/matlabcentral/fileexchange/' ...
                     'loadAuthor.do?objectId=936824&objectType=author'],'-browser');
               case 'Bug found?'
                  web(['mailto:MCommander@gmx.de?subject=MM%20v2.4-BUG:' ...
                     '[Description]-[ReproductionSteps]-[Suggestion' ...
                     '(if%20possible)]-[MATLAB%20v' strrep(version,' ','%20') ']']);
               case 'OK',
            end % switch
            %
         case 9 % exit... sure?... ;(
            delete(H.main)
            %
         case 11 % "out of memory" / matlab ?
            web('http://www.mathworks.com/support/tech-notes/1100/1106.html','-browser');
            %
         case 12 % "out of memory" / simulink ?
            web('http://www.mathworks.com/support/tech-notes/1800/1806.html','-browser');
            %
      end% swtich
      %
   case 'stop'
      switch flag
         case 1
            set([H.disp H.hbar],'Enable','off')
            delete(H.timer)
            try
               fclose(get(H.main,'UserData'));
            end% try
            set(H.status,'Foregroundcolor',[0.8 0.7 0.6])
            mm('','','update',H)
         case 2
            try
               stop(H.timer)
            end% try
      end% switch
      %
   case 'update'
      %
      % MATLAB
      tmp = regexp(evalc('feature(''memstats'')'),'(\w*) MB','match');
      tmp = sscanf([tmp{:}],'%f MB');
      %
      if system_dependent('CheckMalloc')
         minuse = feature('CheckMallocMemoryUsage')/1048576;
      else
         ws = evalin('base','[whos;whos(''global'')]');
         minuse = sum([ws.bytes])/1048576;
      end% if
      mtotal = tmp(end)+minuse;
      update(H.hbar(3),minuse,mtotal/1000)
      %
      set(H.disp,{'String'},{length(inmem);length(findall(0));...
         sprintf('%.0f',minuse);sprintf('%.0f',tmp(10));sprintf('%.0f',mtotal)})
      %
      % BAR
      h = ceil(tmp(10:12)/mtotal*32);% 45
      set(H.vbar, ...
         {'position'},{[133 24 12 36];[134 25 10 h(1)]; ...
         [134 25+h(1) 10 h(2)];[134 25+h(2)+h(1) 10 h(3)]}, ...
         'ToolTipString',sprintf(['largest contiguous free blocks\n' ...
         sprintf('%d. - %%.0f MB\\n',1:10)],tmp(10:19)))
      %
      % RAM
      update(H.hbar(4),tmp(1),tmp(3))
      %
      % SWAP
      update(H.hbar(1),tmp(4),tmp(6))
      %
      % JAVA
      total = java.lang.Runtime.getRuntime.totalMemory/1048576;
      inuse = total-java.lang.Runtime.getRuntime.freeMemory/1048576;
      maxim = java.lang.Runtime.getRuntime.maxMemory/1048576;
      update(H.hbar(2),inuse,maxim)
      set(H.hbar(2),'ToolTipString',sprintf('%s (%.1fMB-total)', ...
         get(H.hbar(2),'ToolTipString'),total))
      %
      drawnow
      %
      try
         fprintf(get(H.main,'UserData'), ...
            '%f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.0f %.0f \n', ...
            now,tmp(1),tmp(3),minuse,mtotal,inuse,maxim,tmp(4),tmp(6),length(inmem),length(findall(0)));
      catch
         tmp = get(H.menu,'String');
         tmp{4} = 'start recording data';
         set(H.menu,'String',tmp)
         set(H.status,'Foregroundcolor',[0.8 0.7 0.6])
      end% if
      %
end% switch
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update(h,inuse,total)
%-------------------------------------------------------------------------------
set(h,'string',sprintf('%.0f%%',inuse/total*100), ...
   'position',get(h,'position').*[1 1 0 1]+[0 0 14+inuse/total*61 0], ...
   'ToolTipString',sprintf('in use-%.1fMB|%.1fMB-max',inuse,total), ...
   'BackgroundColor',[0.7 0.6 0.2]+((inuse/total)>0.9)*[.3 -.3 -.2])
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function H = gui_builder
%-------------------------------------------------------------------------------
H.scr_h = get(0,'ScreenSize')*[0;0;0;1];
H.main = figure('Color',[0.8 0.8 0.8],...
                'MenuBar','none',...
                'Position',[4 H.scr_h-76 148 77], ...
                'Name','mm v2.4',...
                'NumberTitle','off',...
                'Resize','off',...
                'HandleVisibility','off',...
                'Tag','mm2',...
                'UserData',[]);
drawnow
set(H.main,'Position',[4 H.scr_h-76 148 77]);
%
cfg.Parent = H.main;
cfg.Style = 'popupmenu';
cfg.BackgroundColor = [.5 .5 .5];
cfg.ForegroundColor = [0.7 0.6 0.2];
cfg.FontName = 'MS Sans Serif';
cfg.FontSize = 7;
cfg.Units = 'pixel';
cfg.Value = 1;
H.menu = uicontrol(cfg,'Position',[1 -1 148 22], ...
                   'String', ...
                  {'start / set timer period'; ...
                   'stop / refresh'; ...
                   '----------------------------------';...                   
                   'start recording data'; ...
                   'show recorded LOG-file'; ...
                   '----------------------------------';...                   
                   'move window'; ...
                   'info'; ...
                   'exit... sure?... ;('; ...
                   '----------------------------------';...
                   '"out of memory" / matlab ?';...
                   '"out of memory" / simulink ?'});
%
cfg.Style = 'edit';
cfg.Enable = 'inactive';
H.edit(1) = uicontrol(cfg,'Position',[1 1 53 20]);
H.edit(2) = uicontrol(cfg,'Position',[54 1 77 20]);
H.edit(3) = uicontrol(cfg,'Position',[1 21 148 55]);
%
cfg.Style = 'text';
cfg.Enable = 'on';
cfg.BackgroundColor = [0.9 0.85 0.7];
cfg.ForegroundColor = [0.85 0.75 0.5];
cfg.HorizontalAlignment = 'right';
uicontrol(cfg,'Position',[54 24 77 49]);
cfg.ForegroundColor = [.3 .3 .3];
uicontrol(cfg,'Position',[113 24 18 7],'FontSize',5,'String','v2.4 ')
H.vbar(1) = uicontrol(cfg,'Position',[133 24 12 36]);
cfg.ForegroundColor = [0.8 0.7 0.6];
H.status = uicontrol(cfg,'Position',[133 61 12 12],'FontSize',8,'String','� ');

%
cfg.BackgroundColor = [0.7 0.6 0.2];
cfg.ForegroundColor = [0.95 0.9 0.8];
cfg.HorizontalAlignment = 'left';
%
H.hbar(1) = uicontrol(cfg,'Position',[ 55 25 60 11]);
H.hbar(2) = uicontrol(cfg,'Position',[ 55 37 60 11]);
H.hbar(3) = uicontrol(cfg,'Position',[ 55 49 60 11]);
H.hbar(4) = uicontrol(cfg,'Position',[ 55 61 60 11]);
%
H.vbar(2) = uicontrol(cfg,'Position',[134 25 10 25]);
H.vbar(3) = uicontrol(cfg,'Position',[134 50 10 10],'BackgroundColor',[0.8 0.7 0.3]);
H.vbar(4) = uicontrol(cfg,'Position',[134 60 10  5],'BackgroundColor',[1 1 1]);
%
cfg.BackgroundColor = [0.25 0.25 0.25];
cfg.ForegroundColor = [0.8 0.8 0.8];
cfg.HorizontalAlignment = 'center';
cfg.FontSize = 7;
%
uicontrol(cfg,'Position',[5 25 47 11],'String','swap');
uicontrol(cfg,'Position',[5 37 47 11],'String','java');
uicontrol(cfg,'Position',[5 61 47 11],'String','ram');
if ~system_dependent('CheckMalloc')
   cfg.BackgroundColor = [1 0 0];
   cfg.ToolTipString = sprintf(['!!! WARNING !!!\n' ...
      'The calculated value for the MATLAB memory allocation is only the sum\n' ...
      'of all variables existing in the current MATLAB Workspace.\n \n' ...
      'To determine the correct MATLAB memory allocation information\n' ...
      'add the environment variable "MATLAB_MEM_MGR = debug", using the following steps:\n \n' ...
      '1. Click on Settings in the Start Menu\n' ...
      '2. Choose Control Panel\n' ...
      '3. Click on System\n' ...
      '4. Choose the "Advanced" tab and the "Environment Variables..." button.\n' ...
      '5. Create a new User variables with the Variable Name "MATLAB_MEM_MGR" and Variable value "debug"\n' ...
      '6. Press OK\n']);
   disp(cfg.ToolTipString)
end% if
uicontrol(cfg,'Position',[5 49 47 11],'String','matlab');
%
cfg.BackgroundColor = [0.75 0.75 0.75];
cfg.ToolTipString = '';
uicontrol(cfg,'Position',[3 5 48 13])
uicontrol(cfg,'Position',[57 5 71 13])
%
cfg.BackgroundColor = [0.9 0.85 0.7];
cfg.ForegroundColor = [0.3 0.3 0.3];
cfg.HorizontalAlignment = 'center';
%
H.disp(1) = uicontrol(cfg,'Position',[ 4 6 23 11],'ToolTipString','functions in memory');
H.disp(2) = uicontrol(cfg,'Position',[28 6 23 11],'ToolTipString','UI objects in memory');
H.disp(3) = uicontrol(cfg,'Position',[57 6 23 11],'ToolTipString','MATLAB memory - in use (MB)');
H.disp(4) = uicontrol(cfg,'Position',[81 6 23 11],'ToolTipString','MATLAB memory - largest contiguous free block (MB)');
H.disp(5) = uicontrol(cfg,'Position',[105 6 23 11],'ToolTipString','MATLAB memory - maximal available (MB)');
drawnow
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showlog
%-------------------------------------------------------------------------------
[fname fpath] = uigetfile('*.log','pick a LOG-file');
drawnow
if ~path
   return
end% if
log = load(fullfile(fpath,fname),'ascii');
ssz = get(0,'ScreenSize');
H.main = figure('Name',sprintf('MM log-file viewer (%s)',fname), ...
                'NumberTitle','off', ...
                'menubar','none', ...   
                'color',[.3 .3 .3], ...
                'units','pixel', ...
                'visible','off', ...
                'position',[ (ssz(3:4)-[500 350])/2 500 350 ]);
%
H.axes = axes('NextPlot','add', ...
              'YColor',[.9 .9 .9],'XColor',[.9 .9 .9],'color',[.5 .5 .5], ...
              'FontSize',7,'layer','top','box','on', ...
              'XGrid','on','YGrid','on','Layer','bottom', ...
              'YMinorTick','on','XMinorTick','on');
%
H.hplot = plot(log(:,1),log(:,2:9));
tag = {'ram';'ram';'matlab';'matlab';'java';'java';'swap';'swap'};
set(H.hplot,{'Tag'},tag,'linewidth',2.5,'color',[.25 .25 .25])
%
H.hplot = [H.hplot;plot(log(:,1),log(:,2:9))];
set(H.hplot(9:end),{'Tag'},tag,{'color'}, ...
   {[ 1 .5 .5];[ 1 .5 .5]; ...
    [.5  1 .5];[.5  1 .5];...
    [.5 .5  1];[.5 .5  1]; ...
    [ 1  1  1];[ 1  1  1]})
%
set(gca,'XLim',[log(1,1) log(end,1)],'YLim',get(gca,'YLim'), ...
        'UserData',[log(1,1) log(end,1)])
%
title(sprintf('Memory usage (MB)\n%s <========> %s',datestr(log(1,1)),datestr(log(end,1))),'Color',[.9 .9 .9])
H.legend = legend(H.hplot([9 11 13 15]),tag([1 3 5 7]),'Color',[.7 .7 .7]);
%
cfg.units = 'pixel';
H.ui(1) = uicontrol(cfg,'style','edit','position',[98 5 276 21]);
cfg.style = 'popupmenu';
cfg.FontSize = 7;
t = datenum([0 0 0 0 5 0 ; 0 0 0  0 15 0 ; 0 0 0 0 30 0 ; ...
             0 0 0 1 0 0 ; 0 0 0  2  0 0 ; 0 0 0 3  0 0 ; ...
             0 0 0 6 0 0 ; 0 0 0 12  0 0 ; 0 0 1 0  0 0 ; ...
             0 0 2 0 0 0 ; 0 0 4  0  0 0 ; 0 0 7 0  0 0]);
t = unique(min(t,log(end,1)-log(1,1)));
cfg.callback = {@time_limit,H,[log(1,1) log(end,1)],t};
str = {'5 minuts' '15 minuts' '30 minuts' '1 hour' '2 hours' ...
       '3 hours' '6 hours' '12 hours' '1 day' '2 days' '4 days' '7 days'};
str = [str(1:length(t)-1) 'all'];
H.ui(2) = uicontrol(cfg,'position',[98 4 275 21],'String',str,'value',length(t));
cfg.style = 'togglebutton';
cfg.ForegroundColor = [.3 .3 .3];
cfg.callback = {@cb,H};
cfg.FontSize = 7;
cfg.cdata = repmat(repmat([.5:0.025:1]',1,65),[1 1 3]);
H.ui(3) = uicontrol(cfg,'position',[100 7 65 16],'String','ram');
H.ui(4) = uicontrol(cfg,'position',[164 7 65 16],'String','matlab');
H.ui(5) = uicontrol(cfg,'position',[228 7 65 16],'String','java');
H.ui(6) = uicontrol(cfg,'position',[292 7 65 16],'String','swap');
%
set(H.main,'resizefcn',{@fig_resize,H},'visible','on')
fig_resize([],[],H);
time_limit(H.ui(2),'',H,[log(1,1) log(end,1)],t);
pan('xon')
%
set(H.main,'Visible','on')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cb(obj,cnc,H)
%-------------------------------------------------------------------------------
uicontrol(H.ui(1))
ind = strcmp(get(H.hplot,'Tag'),get(obj,'string'));
switch get(obj,'value')
   case 0
      set(H.hplot(ind),'Visible','on')
   case 1
      set(H.hplot(ind),'Visible','off')
end% switch
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fig_resize(obj,cnc,H)
%-------------------------------------------------------------------------------
pos = get(H.main,'position');
pos(3) = max(pos(3),500);
set(H.main,'position',pos);
pos(4) = max(pos(4),350);
set(H.main,'position',pos);
set(H.axes,'units','pixel','position',[40 45 pos(3)-60 pos(4)-79]);
posi = get(H.ui,'position');
posi{1}(1) = (pos(3)-260)/2;
posi{2}(1) = posi{1}(1)+1;
posi{3}(1) = posi{1}(1)+2;
posi{4}(1) = posi{1}(1)+66;
posi{5}(1) = posi{1}(1)+130;
posi{6}(1) = posi{1}(1)+194;
set(H.ui,{'position'},posi)
drawnow
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function time_limit(obj,cnc,H,tm,t)
%-------------------------------------------------------------------------------
lim = get(H.axes,'XLim');
lim = max(min(lim(2),tm(2)),tm(1)+t(get(obj,'Value')));
set(gca,'XLim',[lim-t(get(obj,'Value'),1) lim], ...
        'XTickMode','auto','XTickLabelMode','auto');
ticks = [tm(1):mean(diff(get(gca,'XTick'))):tm(2)];
set(gca,'XTick',ticks,'XTickLabel',datestr(ticks,15))
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%[I LOVE MATLAB]%%%
