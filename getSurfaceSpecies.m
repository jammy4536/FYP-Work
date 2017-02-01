function [SurfSpecies] = getSurfaceSpecies
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
SurfSpecies=dlmread('Species_Density_Output/speciesdens.1000.grid', ' ', [9 0 8+C(1,1) 6]);

%% Plot the surface densities

plot(SurfSpecies(:,1),SurfSpecies(:,3),SurfSpecies(:,1),SurfSpecies(:,4),SurfSpecies(:,1),SurfSpecies(:,5)...
 ,SurfSpecies(:,1),SurfSpecies(:,6),SurfSpecies(:,1),SurfSpecies(:,7))
legend('O_2','N_2', 'H','O' ,'He')
