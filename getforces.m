function [F, P] = getforces
%% Get the surface forces and pressures
global imax timestep steplength;

is= fopen('in.step', 'r');

%Skip through to the create_box command
for f=1:77
    bleh=fgets(is);
end

%Read the line, ignoring the create_box text

timestep= fscanf(is, ['run' '%f']);

fclose('all');
ForceName=sprintf('/dev/shm/forces.%.0f.surf',timestep);

A=dlmread(ForceName,' ',9);
A=sortrows(A);
%A=[f-x, f-y, P-x, P-y, S_x, S_y] (dlmread ignores ID)
%Input the values from A into a force and pressure vector array
F(:,1)=A(:,2);
F(:,2)=A(:,3);
P(:,1)=A(:,4);
P(:,2)=A(:,5);



%% Get the Boundary forces (in a separate file)
%Open the boundary output file
%Boundary.surf=[ID, n particles, Normal pressure, Shear-x, shear-y]
B= dlmread('/dev/shm/Boundary.surf',' ',4);
B=sortrows(B);
%B= [n particles, Normal pressure, Shear-x, shear-y] (dlmread ignores ID)

[a, ~]= size(P);
P(a+1,1)=0;
P(a+1,2)=B(1,3);

%% Get the forces on the boundary from the pressure
%Need the area however in order to get the normal force.
%Tangential force (x-direction) is the shear force in array B
%Open in.step to get the box dimensions
is= fopen('in.step', 'r');

%Skip through to the create_box command
for f=1:9
    bleh=fgets(is);
end

%Read the line, ignoring the create_box text
sizeC=[6 1];
H= fscanf(is, ['create_box' '%f %f %f %f %f %f'], sizeC);
fclose('all');
%H=[start x, end x, start y, end y, start z, end z]
%F=P*Area
% D=(C(2,1)-C(1,1))-(xbar(imax+1,1)-xbar(1,1)); 
D=(H(2,1)-H(1,1))-steplength; %Area of exposed boundary
fbound=P(a+1,2)*D;  %Pressure force on the boundary
F(a+1,2)=-fbound; 
F(a+1,1)=B(1,5);

%% Writing to file
%Define the file path to the subfolder desired
Filepath='/home/jamie/Dropbox/FYP Work/Software/sparta-8Sep16/FYP-Work/Forces_Output/';
File=sprintf('Forces_%.0f.dat',timestep); %Add the timestep to the string
%Add the file to the end of the file path
Filename=strcat(Filepath,File);
CFile=char(Filename); %Convert the string to a char array to pass to dlmwrite
forceout= fopen(Filename,'w+');
fwrite(forceout, 'VARIABLES = F_x F_y P_x P_y S_x S_y\n');
dlmwrite(CFile, A,'-append','delimiter',' ','roffset',1);
fclose(forceout);

File=sprintf('Boundary_%.0f.dat',timestep); %Add the timestep to the string
%Add the file to the end of the file path
Filename=strcat(Filepath,File);
boundout= fopen(Filename,'w+');
CFile=char(Filename); %Convert the string to a char array to pass to dlmwrite
fwrite(boundout, 'VARIABLES = n P_y S_x S_y\n');
dlmwrite(CFile, B, '-append','delimiter',' ','roffset',1);
fclose(boundout);
