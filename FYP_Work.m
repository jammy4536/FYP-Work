%% FYP Work to wrap around the SPARTA Program
close all; clear all;

%% Define the Variables
global xmax xmin ymax ymin imax m n;
imax=10; %Number of points
m=2;    %Number of x parameter points
n=2;    %Number of y parameter points


%% Create the Geometry
[x,y]=Create_Geometry();

%% Create the control points
Pi=zeros(m+1,1);
Pj=zeros(n+1,1);

xmax=max(x);
xmin=min(x);
ymax=max(y);
ymin=min(y);

for i=0:m
    Pi(i+1)=xmin+1.0*i/n*(xmax-xmin);
end

for j=0:n
    Pj(j+1)=ymin+1.0*j/n*(ymax-ymin);
end
   
%% Create the Geometry with parameterisation
[xbar,ybar]=Parameterise(x, y, Pi, Pj);

%% Write Geometry to a file to input to SPARTA
Write_Geometry(xbar, ybar)

%% Run SPARTA
!./spa_serial <in.step
% 
% 
% %% Convert Data from SPARTA
% !make process_Overall
% !make process_Species
% 
% %% Plot Data from SPARTA
% 
% 
% %% Optimise The shape... (To come soon)

