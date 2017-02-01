function [F, P] = getforces(xbar)
%% Get the surface forces and pressures
global imax;

A=dlmread('Forces_Output/forces.1000.surf',' ',9,1);
%A=[Surface_ID, f-x, f-y, P-x, P-y]
%Input the values from A into a force and pressure vector array
F(:,1)=A(:,1);
F(:,2)=A(:,2);
P(:,1)=A(:,3);
P(:,2)=A(:,4);



%% Get the Boundary forces (in a separate file)
%Open the boundary output file
B= dlmread('Forces_Output/Boundary.surf',' ',4,1);
%B= [bound_ID, n particles, Normal pressure, Shear-x, shear-y] 

[a, ~]= size(P);
P(a+1,1)=0;
P(a+1,2)=B(1,2);

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
C= fscanf(is, ['create_box' '%f %f %f %f %f %f'], sizeC);
fclose('all');
%C=[start x, end x, start y, end y, start z, end z]
%F=P*Area
% D=(C(2,1)-C(1,1))-(xbar(imax+1,1)-xbar(1,1)); 
D=(C(2,1)-C(1,1))-(xbar(imax+1,1)-xbar(1,1));
fbound=P(a+1,2)*D;
F(a+1,1)=B(1,4);
F(a+1,2)=-fbound;




