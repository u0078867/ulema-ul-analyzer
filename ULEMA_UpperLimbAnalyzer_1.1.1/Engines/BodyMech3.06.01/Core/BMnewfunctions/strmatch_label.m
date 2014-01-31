function ndx=strmatch_label(str,strarray)
% compares the end of the strings in an strarray and return the matching indices
%
% function strmatch_label(str,strarray)
% INPUT:
%   str: string to compare.
%   strarray: cell array of strings.
% OUTPUT:
%   ndx: all indices in strarray for which the last part of the string
%        element corresponds to str.
%
% Erwin Aertbelien.
% Dep. of Mech. Eng. - K.U.Leuven, july 2010
ndx = [];
for i=1:length(strarray)
    if strcmp_label(str,strarray{i})
        ndx=[ndx i];
    end
end

