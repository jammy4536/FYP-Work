function Produce_Graphs(SurfSpecies,SurfDens)
global timestep;

figure('Name','Surface Overall Density','NumberTitle','off','Color','White'); 
plot(SurfDens(:,1),SurfDens(:,2));
hold on;
grid on;
Name=sprintf('Atmospheric Density on spacecraft surface (Ignoring the block) tstep: %.0f',timestep);
title(Name);
xlabel('Distance (m)');
ylabel('Density (particles/m^2)');

%% Plot the surface densities
figure('Name','Surface Species Density','NumberTitle','off','Color','White');
plot(SurfSpecies(:,1),SurfSpecies(:,2),SurfSpecies(:,1),SurfSpecies(:,3),SurfSpecies(:,1),SurfSpecies(:,4)...
 ,SurfSpecies(:,1),SurfSpecies(:,5),SurfSpecies(:,1),SurfSpecies(:,6))
legend('O_2','N_2', 'H','O' ,'He')
hold on;
Name=sprintf('Species densities on spacecraft surface (Ignoring the block) tstep: %.0f',timestep);
title(Name);
xlabel('Distance (m)');
ylabel('Density (particles/m^2)');
grid on;







