function result = strcmp_label( str1, str2 )
%STRCMP_LABEL compares labels taking into account possible prefixes.
% 
% function result = strcmp_label( str1, str2 )
% INPUT:
%   str1: input string 1: the label from the user-software.
%   str2: input string 2: the label from the c3d-file.
%
% does a CASE INSENSITIVE match with the following rules:
% - if str1 specifies a prefix, it has to be taken into account.
% - if str1 do not specify a prefix, do not take into account the prefix of
%    str2.
% - leading and trailing spaces are disregarded.
%
% e.g.
%  strcmp_end('ABC','xxxx:ABC')       returns true.
%  strcmp_end('xxxx:ABC','xxxx:ABC')  returns true.
%  strcmp_end('BC','xxxx:ABC')         returns false.
%  strcmp_end('x:ABC','xxxx:ABB')     returns false.
%  strcmp_end('xxxx:ABC','ABC')       returns false.
%
%
% Erwin Aertbelien - IPSA-project.
% Dep. of Mech. Eng. - Kuleuven, July 2010.

    str1=[':' strtrim(str1)];
    str2=[':' strtrim(str2)];
    L = length(str1);
    if length(str2) < L
        result=0;    
    else
        result = strcmp(str1,str2(end-L+1:end));      
    end

