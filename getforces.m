function [F, P] = getforces
ff= fopen('Forces_Output/forces.1000.surf', 'r');

%% Get the surface forces and pressures
for k=1:9
    bleh=fgets(ff);
end

sizeA=[5 Inf];
A=fscanf(ff, '%i %f %f %f %f', sizeA);

F=A(2:3,:);
P=A(4:4,:);

F=F';
P=P';

[a, ~]= size(P);
%% Get the Boundary forces (in a separate file)

bf = fopen('Forces_Output/Boundary.surf','r');
for f=1:4
    bleh=fgets(bf);
end
sizeB=[5 1];
B= fscanf(bf, '%i %f %f %f %f', sizeB);

P(a+1,:)=[0 B(2)];

fclose('all');


