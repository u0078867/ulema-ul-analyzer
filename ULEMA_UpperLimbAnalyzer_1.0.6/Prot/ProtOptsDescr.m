%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function d = ProtOptsDescr()

% Row: Parameter name; parameter section; comparison function handle; additional input args for comparison function

d = {};
d{end+1,1} = 'bodyModel';           d{end,2} = 'kine';      d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'staticFile';          d{end,2} = 'kine';      d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'kinematics';          d{end,2} = 'kine';      d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'pointer';             d{end,2} = 'kine';      d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'calPrefix';           d{end,2} = 'kine';      d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'wantedJoints';        d{end,2} = 'kine';      d{end,3} = @isequal2;           d{end,4} = [];
d{end+1,1} = 'absAngRefPos';        d{end,2} = 'kine';      d{end,3} = @isequal;            d{end,4} = [];  
d{end+1,1} = 'absAngRefPosFile';    d{end,2} = 'kine';      d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'absAngRefLab';        d{end,2} = 'kine';      d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'DJCList';             d{end,2} = 'kine';      d{end,3} = @isequalTable;       d{end,4} = [1:4];

d{end+1,1} = 'segMethod';           d{end,2} = 'seg';       d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'contexts';            d{end,2} = 'seg';       d{end,3} = @isequalTable;       d{end,4} = [1:2];
d{end+1,1} = 'anglesMinMaxEv';      d{end,2} = 'seg';       d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'stParPoints';         d{end,2} = 'seg';       d{end,3} = @isequalTable;       d{end,4} = [1:2];
d{end+1,1} = 'timing';              d{end,2} = 'seg';       d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'speed';               d{end,2} = 'seg';       d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'trajectory';          d{end,2} = 'seg';       d{end,3} = @isequal;            d{end,4} = [];
d{end+1,1} = 'jerk';                d{end,2} = 'seg';       d{end,3} = @isequal;            d{end,4} = [];

d{end+1,1} = 'taskPrefixList';      d{end,2} = 'bestCy';    d{end,3} = @isequalTable;       d{end,4} = [1:3];
d{end+1,1} = 'anglesList';          d{end,2} = 'bestCy';    d{end,3} = @isequalTablesList;  d{end,4} = [];
d{end+1,1} = 'bestCyclesN';         d{end,2} = 'bestCy';    d{end,3} = @isequal;            d{end,4} = [];


