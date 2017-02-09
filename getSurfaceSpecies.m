function [SurfSpecies,SurfDens] = getSurfaceSpecies
global C;
%% Find how many points in x-direction
is= fopen('in.step', 'r');

%Skip through to the create_box command
for f=1:10
    bleh=fgets(is);
end

%Read the line, ignoring the create_box text
sizeC=[3 1];
C= fscanf(is, ['create_grid' '%f %f %f'], sizeC);
fclose('all');

%% Get the values of species density on the SC surface (boundary)
tempSurfSpecies=dlmread('Species_Density_Output/speciesdens.1000.grid', ' ', [9 0 8+C(1) 6]);
tempSurfDens=dlmread('Overall_Density_Output/pdens.1000.grid', ' ', [9 0 8+C(1) 2]);
for j=1:1
SurfSpecies(1,:)=(tempSurfSpecies(1,:)+tempSurfSpecies(2,:))/2;
SurfSpecies(C(1),:)=(tempSurfSpecies(C(1)-1,:)+tempSurfSpecies(C(1),:))/2;
SurfDens(1,:)=(tempSurfDens(1,:)+tempSurfDens(2,:))/2;
SurfDens(C(1),:)=(tempSurfDens(C(1)-1,:)+tempSurfDens(C(1),:))/2;

for i=2:C(1)-1
    SurfSpecies(i,:)=(tempSurfSpecies(i,:)+tempSurfSpecies(i+1,:)+tempSurfSpecies(i-1,:))/3;
    SurfDens(i,:)=(tempSurfDens(i,:)+tempSurfDens(i+1,:)+tempSurfDens(i-1,:))/3;
end
tempSurfSpecies=SurfSpecies;
tempSurfDens=SurfDens;
end
