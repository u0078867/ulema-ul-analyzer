%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [filename,pathname]=SaveAsBodyFile(filename,pathname)
% SAVEASBODYFILE [ BodyMech 3.06.01 ]: saves BODY model as *.bmb file
% INPUT
%   filename, pathname
% PROCESS
%   saves BODY model as *.BMB file
% OUTPUT
%   GLOBAL BODY.HEADER.FileName

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, November 1999)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

BodyMechFuncHeader
if exist('BODY')~=1,
    warndlg({'SaveAsBodyFile';...
        'BODY is non-existent'},...
        '** BODYMECH WARNING **')
    return
end


% Check Header Status
if findstr(BODY.HEADER.ModelType,'Project'),
    % BODY will be saved with PROJECTfields only: all Session&TrialFields will be cleared;
    ClearAllbutProjectModel;

    defaults_project={...
        BODY.HEADER.FileName,...
        BODY.HEADER.ProjectName,...
        BODY.HEADER.ProjectCode,...
        };

    prompt_project={...
        'File Name (*.BMB)',...
        'Project name',...
        'Project code',...
        };

    headtext_p='Save project data';
    answer_p  = inputdlg(prompt_project,headtext_p,1,defaults_project,'on');

    if ~isempty(answer_p),
        BODY.HEADER.FileName=char(answer_p(1));
        BODY.HEADER.ProjectName=char(answer_p(2));
        BODY.HEADER.ProjectCode=char(answer_p(3));
    end

elseif findstr(BODY.HEADER.ModelType,'Session'),
    % BODY will be saved with PROJECT & SESSIONfields only: all TrialFields will be cleared;
    ClearTrialModel

    defaults_session={...
        BODY.HEADER.FileName,...
        BODY.HEADER.Session.Name,...
        BODY.HEADER.Session.Code,...
        BODY.HEADER.Session.Remarks,...
        BODY.HEADER.Subject.Name,...
        BODY.HEADER.Subject.Code,...
        };

    prompt_session={...
        'File name (*.BMB)',...
        'Session name',...
        'Session code',...
        'Session remarks',...
        'Subject name',...
        'Subject code',...
        };

    headtext_s='Save session data';
    answer_s  = inputdlg(prompt_session,headtext_s,1,defaults_session,'on');


    if ~isempty(answer_s),
        BODY.HEADER.FileName=char(answer_s(1));
        BODY.HEADER.Session.Name=char(answer_s(2));
        BODY.HEADER.Session.Code=char(answer_s(3));
        BODY.HEADER.Session.Remarks=char(answer_s(4));
        BODY.HEADER.Subject.Name=char(answer_s(5));
        BODY.HEADER.Subject.Code=char(answer_s(6));
    end

elseif findstr(BODY.HEADER.ModelType,'Trial'),
    defaults_trial={...
        BODY.HEADER.FileName,...
        BODY.HEADER.Trial.Name,...
        BODY.HEADER.Trial.Code,...
        BODY.HEADER.Trial.Remarks...
        };

    prompt_trial={...
        'File name (*.BMB)',...
        'Trial name',...
        'Trial code',...
        'Remarks'...
        };

    headtext_t='Save trial data';
    answer_t  = inputdlg(prompt_trial,headtext_t,1,defaults_trial,'on');

    if ~isempty(answer_t),
        BODY.HEADER.FileName=char(answer_t(1));
        BODY.HEADER.Trial.Name=char(answer_t(2));
        BODY.HEADER.Trial.Code=char(answer_t(3));
        BODY.HEADER.Trial.Remarks=char(answer_t(4));
    end
end

BODY.HEADER.FileCreationDate=date;
%
if nargin == 2,
    cd(pathname);
    [filename,pathname]=uiputfile(filename,'Save BodyMech-BODY');
elseif nargin==1
    [filename,pathname]=uiputfile(filename,'Save BodyMech-BODY');
elseif ~isempty(BODY.HEADER.FileName),
    filename=BODY.HEADER.FileName;
    [filename,pathname]=uiputfile(filename,'Save BodyMech-BODY');
else
    [filename,pathname]=uiputfile('*.BMB','Save BodyMech-BODY');
end

if filename ~= 0

    uc_ext_added=findstr(filename,'.BMB');
    lc_ext_added=findstr(filename,'.bmb');
    if isempty(uc_ext_added) & isempty(lc_ext_added)
        save([char(pathname),char(filename)], 'BODY');
    else
        save([char(pathname),char(filename)], 'BODY');
    end
    BODY.HEADER.FileName=filename;
end

BodyMechFuncFooter
return
% ============================================
% END ### SaveAsBodyFile ###
