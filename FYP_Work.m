%% MATLAB script to wrap around the SPARTA program
close all; clear all;
!synclient HorizTwoFingerScroll=0

%% Define the Variables
global xmax xmin ymax ymin imax m n;
stepheight=0.2;
steplength=0.5;
m=2;    %Number of x parameter points
n=1;    %Number of y parameter points


%% Create the Geometry
%Create the starting geometry, to create the parameter points, and
%beginning geometry. This will not be inside the optimisation loop.
%i=1;
%for stepheight=0.5:0.5:4
[x,y]=Create_Geometry(stepheight,steplength);

%% Create the Control Points
%Also external from the optimisation loop
[PI,PJ]=getparamCP(x,y);


%% Create the Geometry with parameterisation
%This will be the start of the optimisation loop, through taking the
%current geometry, and then stretching it with the new control points that
%have been changed by the optimiser, to create a new geometry to be tested. 
[xbar,ybar]=Parameterise(x, y, PI, PJ);

%% Write Geometry to a file to input to SPARTA
Write_Geometry(xbar, ybar)

%% Run SPARTA
!./spa_serial <in.step

%% Convert Data from SPARTA
%!make process_Overall
%!make process_Species
[F, P] = getforces(xbar);
[SurfSpecies,SurfDens]=getSurfaceSpecies;

%% Plot Data from SPARTA
Produce_Graphs(SurfSpecies,SurfDens)
% 
% %% Optimise The shape... (To come soon)
%D(i)= sum(F(:,1));
% stepplot(i)=stepheight;
% i=i+1;
% end

%plot(stepplot,D)
