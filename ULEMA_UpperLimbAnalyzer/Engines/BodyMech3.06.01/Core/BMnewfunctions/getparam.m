function [varargout] = getparam(ParameterGroup,groupstring,paramstring)

% gets the parameter named 'paramstring' from the group 'groupstring'

% example CAMERA_RATE = getparam(ParameterGroup,'TRIAL','CAMERA_RATE')

% Michael Schwartz, Dec21, 2004
tmp = [ParameterGroup.name];
groupid = strcmp(tmp,groupstring);
tmp = [ParameterGroup(groupid).Parameter.name];
paramid = strcmp(tmp,paramstring);
varargout = {ParameterGroup(groupid).Parameter(paramid).data};
if isempty(varargout)
    error('Cannot find parameter %s/%s', groupstring, paramstring);
    %varargout{1} = {};  % in case of there is no param matching
end