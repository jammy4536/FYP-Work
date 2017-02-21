%% MATLAB script to wrap around the SPARTA program
close all; clear all;
%!synclient HorizTwoFingerScroll=0

%% Define the Variables
global C xmax xmin ymax ymin imax m n Oaverage steplength stepheight timestep;
xmax=0; ymax=0; xmin=0; ymin=0; imax=0; Oaverage=0; C=[0 0 0]; 

timestep=100;

stepheight=0.05;
steplength=0.01;
m=1;    %Number of x parameter points
n=1;    %Number of y parameter points


%% Create the Geometry
%Create the starting geometry, to create the parameter points, and
%beginning geometry. This will not be inside the optimisation loop.
%j=1;
% for timestep=100:100:1000

[x,y]=Create_Geometry(stepheight,steplength);

%% Create the Control Points
%Also external from the optimisation loop

[PI,PJ]=getparamCP(x,y);

%Deform the control points to start getting different shapes
 PI(2,1)=0.5*(PI(1,2)-PI(1,1));
 %PJ(2,1)=0.5*(PJ(2,1)-PJ(1,1));
 PI(2,2)=0.6*(PI(1,2)-PI(1,1));
 PJ(2,2)=0.8*PJ(2,1);
%% Create the Geometry with parameterisation
%This will be the start of the optimisation loop, through taking the
%current geometry, and then stretching it with the new control points that
%have been changed by the optimiser, to create a new geometry to be tested. 

[xbar,ybar]=Parameterise(x, y, PI, PJ);

%% Write Geometry to a file to input to SPARTA

Write_Geometry(xbar, ybar);

%% Make in.step

makeinputf;

%% Run SPARTA
!mpirun -np 5 ./spa_g++ <in.step

%% Convert Data from SPARTA
[F, P] = getforces;
[SurfSpecies,SurfDens]=getSurfaceSpecies;

% %% Optimise The shape... (To come soon)
% D(j)= sum(F(:,1));
% stepplot(j)=stepheight;

%% Find the length of the shadow

%step through to find where the shadow begins
i=1;
while SurfSpecies(i,5)>0.05*SurfSpecies(1,5)
    i=i+1;
    if i>=C(1)-1
        fprintf('The solver failed to find the shadow.')
        break;
    end
end

tempSS=SurfSpecies(C(1)-100:C(1),5);
Oaverage= mean(tempSS);
%get a bit of clearance to ensure its into the shadow
i=i+5;

%step through to find when the atomic oxygen is greater than 10% of FS
while SurfSpecies(i,5)<=Oaverage*0.10
    i=i+1;
end

ShadowLength=SurfSpecies(i,1)-2-steplength;
% SL(j)=ShadowLength;
% tstep(j)=timestep;
% D(j)= sum(F(:,1));
% j=j+1;
% end
Drag=sum(F(:,1));

%% Plot Data from SPARTA
%Get the surface densities on the boundary (cba with the block)

Produce_Graphs(SurfSpecies,SurfDens);

% end
 
%% Plot Drag and Shadow length
% 
% Dfig=figure('Name','Drag & Step Length','NumberTitle','off','Color','White');
% %Set the standard colors to black for the axes and let the legend show
% %which is which graph
% set(Dfig, 'defaultAxesColorOrder',[0 0 0; 0 0 0]);
% %draw stuff for the left axis
% yyaxis left
% plot(stepplot,D ,'color','b')
% grid on;
% ylabel('Drag (N)'); 
% hold on; 
% %Draw stuff for the right axis
% yyaxis right;
% plot(stepplot,SL,'color','r')
% ylabel('Shadow Length (m)');
% title('Protrusion height vs Drag & Shadow Length');
% xlabel('Protrusion height (m)');
% legend('Drag', 'Shadow Length', 'Location', 'Southeast')




