function Produce_Graphs(SurfSpecies,SurfDens)
close all;
% myfile= fopen('Overall_Density_Output/pdens.1000.dat','r');
% bleh=fgets(myfile);
% sizeA=[3 Inf];
% A=fscanf(myfile, '%f %f %f', sizeA);
% 
% A=A';
% imagesc(A)
% view(2); pcolor(X,Y,Z);
% axis equal;

figure; 
plot(SurfDens(:,1),SurfDens(:,2));
hold on;
grid on;
title('Atmospheric Density on spacecraft surface (Ignoring the block)');
xlabel('Distance (m)');
ylabel('Density (particles/m^2)');

%% Plot the surface densities
figure;
plot(SurfSpecies(:,1),SurfSpecies(:,2),SurfSpecies(:,1),SurfSpecies(:,3),SurfSpecies(:,1),SurfSpecies(:,4)...
 ,SurfSpecies(:,1),SurfSpecies(:,5),SurfSpecies(:,1),SurfSpecies(:,6))
legend('O_2','N_2', 'H','O' ,'He')
hold on;
title('Species densities on spacecraft surface (Ignoring the block)');
xlabel('Distance (m)');
ylabel('Density (particles/m^2)');
grid on;





