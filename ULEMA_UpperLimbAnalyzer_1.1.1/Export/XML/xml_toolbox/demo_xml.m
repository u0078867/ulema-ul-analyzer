% This demo_xml script will test the basic functionality of the
% Geodise XML Toolbox for Matlab, and demonstrate the main functions.

%  Copyright (c) 2005 Geodise Project, University of Southampton
%  XML Toolbox for Matlab, http://www.geodise.org

% clear the command window:
clc

disp('------------------------------------------------------------------');
disp(' ');
disp('This is the Geodise XML Toolbox for Matlab demo script, demo_xml.m');
disp(' ');
disp('This demo script will show how to use the commands to convert');
disp('Matlab data into XML format and vice versa.');

disp(' ');
disp('Press any key to continue...');
pause;
disp(' ');

disp('------------------------------------------');
disp('First, let''s create a new Matlab data structure ... ');
disp(' ');
disp(' >> data.project.comment = ''This is a project comment.'' ');
disp(' >> data.project.name    = ''myproject'' ');
disp(' >> data.project.parameters.alpha = 0.5 ');
disp(' >> data.project.parameters.beta  = 0.79 ');
disp(' >> data.project.parameters.pi    = 3.1415 ');

data.project.comment = 'This is a project comment.';
data.project.name    = 'myproject';
data.project.parameters.alpha = 0.5;
data.project.parameters.beta  = 0.79;
data.project.parameters.pi    = 3.1415;

disp(' ');
disp('Press any key to continue...');
pause;
disp(' ');

disp('------------------------------------------');
disp('... then convert this data structure into XML format using the ');
disp('XML_FORMAT command and display it:');
disp(' ');
disp(' >> xmlstring = xml_format( data )');
disp(' >> disp( xmlstring )');
disp(' ');
xmlstring = xml_format( data );
disp(xmlstring)

disp(' ');
disp('Press any key to continue...');
pause;
disp(' ');

disp('------------------------------------------');
disp('Alternatively we can convert it into XML without the attributes:');
disp(' ');
disp(' >> xmlstring_noatt = xml_format( data, ''off'' )');
disp(' >> disp( xmlstring_noatt )');
disp(' ');
xmlstring_noatt = xml_format( data, 'off' );
disp( xmlstring_noatt );

disp(' ');
disp('Press any key to continue...');
pause;
disp(' ');

disp('------------------------------------------');
disp('... and give it a different root-level name, e.g. "MyDataStructure":');
disp(' ');
disp(' >> xmlstring_noatt_name = xml_format( data, ''off'', ''MyDataStructure'' )');
disp(' >> disp( xmlstring_noatt_name )');
disp(' ');
xmlstring_noatt_name = xml_format( data, 'off', 'MyDataStructure' );
disp( xmlstring_noatt_name );

disp(' ');
disp('Press any key to continue...');
pause;
disp(' ');

disp('------------------------------------------');
disp('You can save this data directly to a file in XML format with the ');
disp('XML_SAVE command and reload it with the XML_LOAD command.');
disp(' ');
disp(' >> xml_save( ''mydata.xml'', data )');
disp(' ');
try
  xml_save( 'mydata.xml', data );
  disp('This file has just been successfully created in your current working directory.');
catch
  disp('Oops: Cannot write file in current directory.');
end
disp(' ');
disp(' >> data = xml_load( ''mydata.xml'' );');
disp(' ');

disp(' ');
disp('Press any key to continue...');
pause;
disp(' ');

disp('------------------------------------------');
disp('With the XML_PARSE command you can also convert XML strings directly ');
disp('into data structures, e.g.');
disp(' ');
disp(' >> xmlstr = ''<root><mydata><alpha>1</alpha><alpha>2</alpha></mydata></root>''');
disp(' >> alphadata = xml_parse( xmlstr ) ');
disp(' ');
xmlstr = '<root><mydata><alpha>1</alpha><alpha>2</alpha></mydata></root>';
alphadata = xml_parse( xmlstr );
disp(' alphadata = ')
disp(alphadata)
disp(' alphadata.mydata(1) = ')
disp(alphadata.mydata(1))

disp(' ');
disp('Press any key to continue...');
pause;
disp(' ');

disp('------------------------------------------');
disp('The command XML_PARSEANY lets you parse more generic types of XML ');
disp('into a Matlab structure, for example');
disp(' ');
disp(' >> xmlstr = ''<root rootattribute="111">');
disp('                 <mydata mydataattr="level one">');
disp('                   <alpha tag="first">1</alpha>');
disp('                   <alpha tag="second">2</alpha>');
disp('                 </mydata>');
disp('               </root>''');
disp(' >> alphadata = xml_parseany( xmlstr ) ');
disp(' ');
xmlstr = '<root rootattribute="111"><mydata mydataattr="level one"><alpha tag="first">1</alpha><alpha tag="second">2</alpha></mydata></root>';
alphadata = xml_parseany( xmlstr );
disp(' alphadata = ')
disp(alphadata)
disp(' alphadata.ATTRIBUTE = ')
disp(alphadata.ATTRIBUTE)
disp(' alphadata.mydata{1} = ')
disp(alphadata.mydata{1})
disp(' alphadata.mydata{1}.ATTRIBUTE = ')
disp(alphadata.mydata{1}.ATTRIBUTE)
disp(' alphadata.mydata{1}.alpha{1} = ')
disp(alphadata.mydata{1}.alpha{1})

disp(' ');
disp('Press any key to continue...');
pause;
disp(' ');

disp('------------------------------------------');
disp('A structure of this type can then be easily converted back into XML using');
disp('the command XML_FORMATANY. Please note that in some cases xml_formatany() and ');
disp('xml_parseany() are not "symmetric", i.e. xml_formatany(xml_parseany(xmlstr))');
disp('does not necessarily return the original XML string.');
disp(' ');
disp(' >> xmlstr = xml_formatany( alphadata ) ');
disp(' ');
disp(' xmlstr = ');
xmlstr = xml_formatany(alphadata);
disp(xmlstr);
disp(' ');

disp('----------------------------------------------------------------------------');
disp('  This concludes the demo script demo_xml() for the XML Toolbox for Matlab. ');
disp('----------------------------------------------------------------------------');
