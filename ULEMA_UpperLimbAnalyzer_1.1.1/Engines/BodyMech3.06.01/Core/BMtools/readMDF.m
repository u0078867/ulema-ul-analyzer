%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [data,header]=readMDF(datafile,datapath)
% READMDF : reads a Sybar measurement file
% INPUT
%    Input : data: numerical matrix
%            header: string matrix
%             get path and name of MDF file to be loaded
% PROCESS
%       for keyboard-input
%       datapath=input('geef het path van de data  :','s');
%       datafile=input('geef de datafile (8 chars) :','s');
%       datafile=[ datafile, '.mdf'];
%       invoke the windows-file-browser
%       [datafile,datapath] = uigetfile('*.mdf', 'open SYBAR file', 40, 40);
% OUTPUT

% AUTHOR(S) AND VERSION-HISTORY
% $ Ver 1.0 Creation (Jaap Harlaar, VUmc, Amsterdam, October 2000)
% $ Ver 3.06.01 VUmc, Amsterdam, May 2006 (Jaap Harlaar en Caroline Doorenbosch)

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

if datafile ~= 0
    [fid,message]=fopen([datapath,datafile]);	% open file
    if fid == -1
        error(message);
        return
    end

    % get first line,
    line=fgetl(fid);
    % check if the type of datafile is appropriate
    % if0002
    if strcmpi(line(4:8),'Sybar')
        % then: continue
        % read the complete header
        header=str2mat(line);
        i=1;
        while i>=1
            line=fgetl(fid); if isempty(line), line='--'; end
            if ~isempty(strfind(line,'Comment')),
                while i>=2,
                    header=str2mat(header,line);
                    i=i+1;
                    position=ftell(fid);
                    line=fgetl(fid); if isempty(line), line='--'; end
                    if line(1)=='!', break, end
                end
            end
            if line(1)~='!',break, end
            header=str2mat(header,line);
            i=i+1;
            position=ftell(fid);
        end
        nLines=i;

        % assign number of columns from header-text
        nChannels=[];
        i=1;
        while i<=nLines & isempty(nChannels),
            line=deblank(header(i,:));
            if ~isempty(strfind(line,'Nr of channels')),

                nChannelsIndices=find(48 <= line & line <= 57);  % look for any number characters (ascii(0..9))
                nChannels=str2num(line(nChannelsIndices));
            end
            i=i+1;
        end

        if ~isempty(nChannels),
            % file position indicator is set (back) to beginning of data block
            fseek(fid,position,-1);

            [data,N_elements]=fscanf(fid,'%f',[nChannels,inf]);
            data=data'; % FSCANF reads rows but stores column-wise
            N_samples=N_elements/nChannels;

        else
            data=[];
        end

        fclose(fid);

        % name=datafile(1:(findstr(datafile,'.')-1));

    else
        warndlg({'READ_MDF';' ';...
            'this is a not a ver 0.01 of 2.0 SYBAR type MDF file';...
            },...
            '** APPLICATION WARNING **')
    end
end
return
%========================================================================
% END ### readMDF ###
