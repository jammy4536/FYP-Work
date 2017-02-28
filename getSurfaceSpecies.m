function [SurfSpecies,SurfDens] = getSurfaceSpecies
global C timestep;
%steplength=0.01;
%% Find how many points in x-direction
is= fopen('in.step', 'r');

%Skip through to the create_box command
for f=1:10
    bleh=fgets(is); %#ok<*NASGU>
end

%Read the line, ignoring the create_box text
sizeC=[3 1];
C= fscanf(is, ['create_grid' '%f %f %f'], sizeC);

fclose('all');

SurfSpecies=zeros(C(1),6);
SurfDens=zeros(C(1),2);

%% Get the values of species density on the SC surface (boundary)
SpeciesName=sprintf('/dev/shm/speciesdens.%.0f.grid',timestep);
tempSurfSpecies=dlmread(SpeciesName,' ',9,0);
temp=sortrows(tempSurfSpecies);
clear tempSurfSpecies;

OverallName=sprintf('/dev/shm/pdens.%.0f.grid',timestep);
tempSurfDens=dlmread(OverallName, ' ', 9,0);
temp2=sortrows(tempSurfDens);
clear tempSurfDens;

tempSurfSpecies(:,1)=temp(1:C(1),2);
tempSurfSpecies(:,2:6)=temp(1:C(1),4:8);
tempSurfDens(:,1)=temp2(1:C(1),2);
tempSurfDens(:,2)=temp2(1:C(1),4);

%% Smooth the graphs somewhat
for j=1:3
    SurfSpecies(1,:)=(tempSurfSpecies(1,:)+tempSurfSpecies(2,:))/2;
    SurfSpecies(C(1),:)=(tempSurfSpecies(C(1)-1,:)+tempSurfSpecies(C(1),:))/2;
    SurfDens(1,:)=(tempSurfDens(1,:)+tempSurfDens(2,:))/2;
    SurfDens(C(1),:)=(tempSurfDens(C(1)-1,:)+tempSurfDens(C(1),:))/2;

    for i=2:C(1)-1
        if tempSurfSpecies(i,1)>=1.9 && tempSurfSpecies(i,1)<=2.1
            SurfSpecies(i,:)=tempSurfSpecies(i,:);
        end
        if tempSurfDens(i,1)>=1.9 && tempSurfDens(i,1)<=2.01
            SurfDens(i,:)=tempSurfDens(i,:);
        end
        
        SurfSpecies(i,:)=(tempSurfSpecies(i,:)+tempSurfSpecies(i+1,:)+tempSurfSpecies(i-1,:))/3;
        SurfDens(i,:)=(tempSurfDens(i,:)+tempSurfDens(i+1,:)+tempSurfDens(i-1,:))/3;
    end
    tempSurfSpecies=SurfSpecies;
    tempSurfDens=SurfDens;
end

