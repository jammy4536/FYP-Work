function Produce_Graphs

myfile= fopen('Overall_Density_Output/pdens.1000.dat','r');
bleh=fgets(myfile);
sizeA=[3 Inf];
A=fscanf(myfile, '%f %f %f', sizeA);

A=A';
[X,Y]=meshgrid(A(:,1),A(:,2));
mesh(A)
%view(2);
%pcolor(X,Y,Z);
axis equal;





