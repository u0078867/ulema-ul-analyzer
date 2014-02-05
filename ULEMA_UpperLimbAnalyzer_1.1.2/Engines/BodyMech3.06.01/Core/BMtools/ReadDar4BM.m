%
% License:  This  program  is  free software; you can redistribute it and/or
% modify  it  under the terms of the GNU General Public License as published
% by  the  Free Software Foundation; either version 3 of the License, or (at
% your  option)  any  later version. This program is distributed in the hope
% that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
% warranty  of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.
%

function [FileData]=ReadDar4BM(DarFilename,datapath)
% READDAR4BM : Function to read data from DAR files (which are DICOM structured files)
% INPUT
%   DarFileName
%   datapath
% PROCESS
%   Function to read data from DAR files (which are DICOM structured files)
%   especially for kinetic and electrophysiological data to be assigned in
%   a "Sybar" environment
%   uses internal functions: ReadDicomAttribute
%                            FindDicomTag
%                            ReadNextDicomTag
% OUTPUT
%   FileData: structured array

% DicomFile definition by Lia Out
% Acknowledgements to Ronald van Schijndel

% Copyright 2000-2006 This program is free software under the terms of the
% GNU General Public License (www.gnu.org)

FileData=[];

% invoke the windows-file-browser to get DAR filename when no input is given
if nargin < 1,
    [DarFilename,datapath] = uigetfile('*.dar', 'open DAR file',40,40);
elseif nargin < 2,
    datapath=cd;
end

if DarFilename ~= 0
    fid=fopen([datapath,'\',DarFilename],'r','l'); % little-endian
else
    return
end

% create data-structure FileData
FileData.DataFileName=DarFilename;

% attributing DICOM fields2FileData
% ==========================================
% === Patient Name (16,16)
% ==========================================
[Attribute, Valid]=ReadDicomAttribute(fid,16,16,'char');
if Valid,
    FileData.PatientName=char(Attribute');
else
    FileData.PatientName='anonymous';
end
% ==========================================
% === Patient ID (16,32)  %          ZISnummer
% ==========================================
[Attribute, Valid]=ReadDicomAttribute(fid,16,32,'char');
if Valid,
    FileData.PatientId=char(Attribute');
else
    FileData.PatientId='not available';
end

% ==========================================
% === Study Date (8,32)
% ==========================================
[Attribute, Valid]=ReadDicomAttribute(fid,8,32,'char');
if Valid,
    FileData.StudyDate=char(Attribute)';
else
    FileData.StudyDate='unknown';
end

% ========================================
% === Study Walking Velocity (9,4107)
% ==========================================
[Attribute, Valid]=ReadDicomAttribute(fid,9,4107,'char');
if Valid,
    FileData.WalkingVelocity=char(Attribute)';
else
    FileData.WalkingVelocity='unknown';
end

% ==========================================
% === Comments (9,16384)
% ==========================================
[Attribute, Valid]=ReadDicomAttribute(fid,9,16384,'char');
if Valid,
    FileData.Comments={char(Attribute)'};
else
    FileData.Comments='no remarks';
end

% ==========================================
% === Optotrak FileID (9,4113)
% ==========================================
[Attribute, Valid]=ReadDicomAttribute(fid,9,4113,'char');
if Valid,
    FileData.OptoTrakFileID={char(Attribute)'};
    %if length(char(FileData.OptoTrakFileID))<=1,
    % FileData.OptoTrakFileID='no OT FileID';
    %end
else
    FileData.OptoTrakFileID='no OT FileID found';
end

% ==========================================
% === Number of Channels (58,5)
% ==========================================
[Attribute,Valid]=ReadDicomAttribute(fid,58,5,'uint16');
if Valid,
    FileData.NumberOfWaveformChannels=Attribute;
else
    FileData.NumberOfWaveformChannels=NaN;
end
NumberOfWaveformChannels=FileData.NumberOfWaveformChannels;

% ==========================================
% === Sampling Frequency (58,26)
% ==========================================
[Attribute,Valid]=ReadDicomAttribute(fid,58,26,'char');
if Valid,
    Number=str2num(char(Attribute)');
    FileData.SamplingFrequency=Number;
else
    FileData.SamplingFrequency=NaN;
end

% ==========================================
% === Number of Samples  (58,16)
% ==========================================
[Attribute, Valid]=ReadDicomAttribute(fid,58,16,'uint32');
if Valid,
    FileData.NumberOfWaveformSamples=Attribute;
else
    FileData.NumberOfWaveformSamples=NaN;
end
NumberOfWaveformSamples=FileData.NumberOfWaveformSamples;

% ==========================================
% === Test Neppertje
% ==========================================
[Attribute, Valid]=ReadDicomAttribute(fid,38,38,'char');
if Valid,
    disp('dit kan eigenlijk niet');
end

% ==========================================
% === MainChannelLabels (58,515)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];
    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope);
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,58,515,'char',ChannelScope);
            if Valid,
                FileData.ChannelLabel(iChannel)={char(Attribute)'};
            else
                FileData.ChannelLabel(iChannel)='';
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% === WaveformChannelNumber (58,514)
% ===== in ChannelDefinition Sequence =====
% ==========================================
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];
    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope); % FFFE E000   delimiter tag
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,58,514,'char',ChannelScope);
            if Valid,
                Number=str2num(char(Attribute)');
                FileData.ChannelNumber(iChannel)=Number;
            else
                FileData.ChannelNumber(iChannel)=-1;
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% ===  Channel Anatomical Label Long (59,4101)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];

    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope);
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,59,4101,'char',ChannelScope);
            if Valid,
                FileData.ChannelAnatomicalLabelLong(iChannel)={char(Attribute)'};
            else
                FileData.ChannelAnatomicalLabelLong(iChannel)='';
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% ===  Channel Anatomical Label Short (59,4102)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];

    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope);
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,59,4102,'char',ChannelScope);
            if Valid,
                FileData.ChannelAnatomicalLabelShort(iChannel)={char(Attribute)'};
            else
                FileData.ChannelAnatomicalLabelShort(iChannel)='';
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% ===  Channel Body Side (59,4103)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];

    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope);
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,59,4103,'char',ChannelScope);
            if Valid,
                FileData.ChannelBodySide(iChannel)={char(Attribute)'};
            else
                FileData.ChannelBodySide(iChannel)='';
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% === ChannelSensitivity (58,528)
% ===== in ChannelDefinition Sequence =====
% ==========================================
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];
    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope); % FFFE E000   delimiter tag
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,58,528,'char',ChannelScope);
            if Valid,
                Number=str2num(char(Attribute)');
                FileData.ChannelSensitivity(iChannel)=Number;
            else
                FileData.ChannelSensitivity(iChannel)=-1;
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% === ChannelSensitivityCorrectionFactor (58,530)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];
    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope); % FFFE E000   delimiter tag
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,58,530,'char',ChannelScope);
            if Valid,
                Number=str2num(char(Attribute)');
                FileData.ChannelSensCorrectionFactor(iChannel)=Number;
            else
                FileData.ChannelSensCorrectionFactor(iChannel)=-1;
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% === ChannelBaseline(58,531)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];
    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope); % FFFE E000   delimiter tag
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,58,531,'char',ChannelScope);

            if Valid,
                Number=str2num(char(Attribute)');
                FileData.ChannelBaseline(iChannel)=Number(1);
            else
                FileData.ChannelBaseline(iChannel)=-1;
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% === ChannelClinicalSensitivity(59,4096)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];
    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope); % FFFE E000   delimiter tag
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,59,4096,'char',ChannelScope);
            if Valid,
                Number=str2num(char(Attribute)');
                FileData.ChannelClinicalSensitivity(iChannel)=Number;
            else
                FileData.ChannelClinicalSensitivity(iChannel)=-1;
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% === ChannelClinicalBaseline(59,4097)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];
    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope); % FFFE E000   delimiter tag
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,59,4097,'char',ChannelScope);
            if Valid,
                Number=str2num(char(Attribute)');
                FileData.ChannelClinicalBaseline(iChannel)=Number;
            else
                FileData.ChannelClinicalBaseline(iChannel)=-1;
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% === ChannelEngineeringUnits(59,4098)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[FieldLength, FilePointer]=FindDicomTag(fid,58,512);% ChannelDefinitionSequence
if FilePointer >= 0,
    ChanSeqScope=[FilePointer,FilePointer+FieldLength];
    for iChannel=1:NumberOfWaveformChannels,
        [FieldLength, FilePointer]=FindDicomTag(fid,65534,57344,ChanSeqScope); % FFFE E000   delimiter tag
        if FilePointer >= 0,
            ChannelScope=[FilePointer,FilePointer+FieldLength];
            [Attribute, Valid]=ReadDicomAttribute(fid,59,4098,'char',ChannelScope);
            if Valid,
                %Number=str2num(char(Attribute)');
                FileData.ChannelEngineeringUnits(iChannel)={char(Attribute)'};
            else
                FileData.ChannelEngineeringUnits(iChannel)=-1;
            end
            ChanSeqScope(1)=FilePointer; % limit scope for next channel
        else
            break
        end
    end
end

% ==========================================
% ==========================================
% === Waveform data (21504,4112)
% ===== in ChannelDefinition Sequence =====
% ==========================================
[Data, Valid]=ReadDicomAttribute(fid,21504,4112,'uint16');

TotNumSamples=NumberOfWaveformChannels*NumberOfWaveformSamples;

if length(Data) == TotNumSamples,

    FileData.WaveformData=reshape(Data,NumberOfWaveformChannels,NumberOfWaveformSamples);
else
    FileData.WaveformData=NaN;
end

% ==========================================
fclose(fid);
return

% ----------
function [Attribute,Valid]=ReadDicomAttribute(fid,DicomGroupId,DicomElementId,Format,Scope)

switch Format
    case 'uint8'
        BytesPerElement=1;
    case 'uint16'
        BytesPerElement=2;
    case 'uint32'
        BytesPerElement=4;
    case 'char'
        BytesPerElement=1;
    otherwise
        BytesPerElement=1;
end

if nargin < 5
    [FieldLength,FilePointer]=FindDicomTag(fid,DicomGroupId,DicomElementId);
else
    [FieldLength,FilePointer]=FindDicomTag(fid,DicomGroupId,DicomElementId,Scope);
end

if FilePointer >= 0,
    fseek(fid,FilePointer,'bof');
    Attribute=fread(fid,FieldLength/BytesPerElement,Format);
    Valid=1;
else
    Attribute=[];
    Valid=0;
end

return

%--------------------------------------------------------------
function [FieldLength,FilePointer]=FindDicomTag(fid,DicomGroupId,DicomElementId,Scope)

if nargin<4, % unlimited scope
    fseek(fid,0,'bof'); % rewind : pointer to BeginningOfFile
    [DicomGroup,DicomElement,FieldLength,Valid]=ReadNextDicomTag(fid);
    while Valid & ( DicomGroup~=DicomGroupId | DicomElement~=DicomElementId ),
        fseek(fid,FieldLength,'cof');
        [DicomGroup,DicomElement,FieldLength,Valid]=ReadNextDicomTag(fid);
    end
    if Valid,
        FilePointer=ftell(fid);
    else
        FilePointer=-1;
    end

else
    % Scope=[ from to]
    fseek(fid,Scope(1),'bof'); % set pointer to beginning of scope
    [DicomGroup,DicomElement,FieldLength,Valid]=ReadNextDicomTag(fid);
    while Valid & ( DicomGroup~=DicomGroupId | DicomElement~=DicomElementId ),

        fseek(fid,FieldLength,'cof');
        FilePointer=ftell(fid);
        if FilePointer < Scope(2),
            [DicomGroup,DicomElement,FieldLength,Valid]=ReadNextDicomTag(fid);
        else
            Valid=0;
        end
    end
    if Valid,
        FilePointer=ftell(fid);
        if FilePointer+FieldLength > Scope(2),
            FilePointer=-1; % only in case of inconsistent files
        end
    else
        FilePointer=-1;
    end
end

return

function [Group,Element,Length,Valid]=ReadNextDicomTag(fid)
[Group,n1]=fread(fid,1,'uint16');
[Element,n2]=fread(fid,1,'uint16');
[Length,n3]=fread(fid,1,'uint32');
if n1 ==1 & n2 == 1 & n3 == 1, Valid =1; else, Valid=0; end
return
%=======================================================================
% END ### ReadDar4BM ###
