%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function ShowTip
% SHOWTIP [ BodyMech 3.06.01 ]: Shows tipposition in display
% INPUT
%    Input : global BODY.CONTEXT.Stylus.TipPosition
% PROCESS
%   Shows tipposition of anatomical prober in display
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch) 

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org) 

global BODY

BodyMechFuncHeader

Vmarker=BODY.CONTEXT.Stylus.TipPosition(X:Z)*1000.;

axes(findobj('Tag','DDDview'));

line(Vmarker(X),Vmarker(Z,:),Vmarker(Y,:),...
         'Marker','.',...
         'LineStyle','none',...
         'Color','y',...
         'EraseMode','background');
%=====================================================
% END ### ShowTip ###
