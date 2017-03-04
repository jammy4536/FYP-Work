function writefiles
global timestep C;
%timestep=100;
%% Write stuff to a new file (Density Outputs)
%Get the arrays from the old file

SpeciesName=sprintf('/dev/shm/speciesdens.%.0f.grid',timestep);
tempSurfSpecies=dlmread(SpeciesName,' ',9,0);
temp=sortrows(tempSurfSpecies);
clear tempSurfSpecies;
tempSurfSpecies=temp(:,2:8);
clear temp;

OverallName=sprintf('/dev/shm/pdens.%.0f.grid',timestep);
tempSurfDens=dlmread(OverallName, ' ', 9,0);
temp2=sortrows(tempSurfDens);
clear tempSurfDens;
tempSurfDens=temp2(:,2:4);
clear temp2;

%Define the folder path to output to...
Filepath='/home/jamie/Dropbox/FYP Work/Software/sparta-8Sep16/FYP-Work/Density_Outputs/';
File=sprintf('Species_%.0f.dat',timestep); %Add the timestep to the string

%Add in the file name to open it
Filename=strcat(Filepath,File);
CFile=char(Filename); %Convert the string to a char array to pass to dlmwrite
speciesout= fopen(CFile,'w+'); %open the file

%Write the starting line, so that tecplot can read it
fwrite(speciesout, 'VARIABLES = X Y O2 N2 H O He');
dlmwrite(CFile, tempSurfSpecies,'-append','delimiter',' ','roffset',1); %output the array
fclose(speciesout);

%rewrite it for the overall density
File=sprintf('Overall_Density_%.0f.dat',timestep);
%Add in the file name to open it
Filename=strcat(Filepath,File);
CFile=char(Filename); %Convert the string to a char array to pass to dlmwrite
densout= fopen(Filename,'w+'); %open the file
fwrite(densout, 'VARIABLES = X Y Density');
dlmwrite(CFile, tempSurfDens,'-append','delimiter',' ','roffset',1);
fclose(densout);

%% Write the Knusden Number Output
%{
B = dlmread('/dev/shm/gas_properties.grid',' ',112518,0);
B=sortrows(B);
Knusden=B(C(1)-100:C(1),:);
Avg=mean(Knusden)
Filepath='/home/jamie/Dropbox/FYP Work/Software/sparta-8Sep16/FYP-Work/';
File='gas_properties.dat';
Filename=strcat(Filepath,File);
CFile=char(Filename);
densout= fopen(Filename,'w+'); %open the file
fwrite(densout, 'VARIABLES = ID, Mean Free Path, Knusden Number\n');
%fwrite(densout, 'Variables = ID Lambda Knusden_Number');
dlmwrite(CFile, B,'-append','delimiter',' ');
fclose('all');
%}