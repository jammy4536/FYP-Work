%% FYP Work to wrap around the SPARTA Program
close all; clear all;
!synclient HorizTwoFingerScroll=0

%% Define the Variables
global xmax xmin ymax ymin imax m n;
stepheight=0.75;
steplength=2;
m=2;    %Number of x parameter points
n=1;    %Number of y parameter points


%% Create the Geometry
%Create the starting geometry, to create the parameter points, and
%beginning geometry. This will not be inside the optimisation loop.
%i=1;
%for stepheight=0.5:0.5:4
[x,y]=Create_Geometry(stepheight,steplength);

%% Create the control points
%Similarly this will not be inside the optimisation loop, as the optimiser
%will be moving these points to alter the geometry.
Pi=zeros(m+1,1);
Pj=zeros(n+1,1);

xmax=max(x);
xmin=min(x);
ymax=max(y);
ymin=min(y);

for i=0:m
    Pi(i+1)=xmin+1.0*i/m*(xmax-xmin);
end

for j=0:n
    Pj(j+1)=ymin+1.0*j/n*(ymax-ymin);
end
   
[PI,PJ]=meshgrid(Pi,Pj);


%% Create the Geometry with parameterisation
%This will be the start of the optimisation loop, through taking the
%current geometry, and then stretching it with the new control points that
%have been changed by the optimiser, to create a new geometry to be tested. 
[xbar,ybar]=Parameterise(x, y, PI, PJ);

%% Write Geometry to a file to input to SPARTA
Write_Geometry(xbar, ybar)

%% Run SPARTA
!./spa_serial <in.step
% 
% 
% %% Convert Data from SPARTA
%!make process_Overall
%!make process_Species
[F, P] = getforces(xbar);
[SurfSpecies]=getSurfaceSpecies;

%
% %% Plot Data from SPARTA
% Produce_Graphs
% 
% %% Optimise The shape... (To come soon)
%D(i)= sum(F(:,1));
% stepplot(i)=stepheight;
% i=i+1;
% end

%plot(stepplot,D)
