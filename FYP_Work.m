%% MATLAB script to wrap around the SPARTA program
close all; clear all;
%!synclient HorizTwoFingerScroll=0

%% Define the Variables
global C xmax xmin ymax ymin imax m n Oaverage steplength stepheight timestep;
global normDrag normShad j D Jstore ShadowL SurfSpecies SurfDens;
xmax=0; ymax=0; xmin=0; ymin=0; imax=0; Oaverage=0; C=[0 0 0]; 

timestep=1500;

stepheight=0.05;
steplength=0.01;
m=1;    %Number of x parameter points
n=1;    %Number of y parameter points


%% Create the Geometry
%Create the starting geometry, to create the parameter points, and
%beginning geometry. This will not be inside the optimisation loop.

[x,y]=Create_Geometry(stepheight,steplength);

%% Create the Control Points
%Also external from the optimisation loop

[PI,PJ]=getparamCP(x,y);

%Deform the control points to get different shapes
 %PI(2,1)=-0.8*(PI(1,2)-PI(1,1));
 %PJ(2,1)=0.5*(PJ(2,1)-PJ(1,1));
% PI(2,2)=0.2*(PI(1,2)-PI(1,1));
 %PJ(2,2)=0.4*PJ(2,2);

Paramstart=[PI(2,1) PJ(2,1) PI(2,2) PJ(2,2)];
j=1; 

%% Perform the Optimisation
x0=[0.5 ;0.5; 0.75; 0.5];
Drag0=1.22462e-05;
Shadow0=0.3033;

%Open a file to write optimisation progress to
optf=fopen('Iteration_steps.txt','w+');
fprintf(optf,'Optimiser: Patternsearch\n');
fprintf(optf,'Starting value: %f %f %f %f\n',x0(:,1));
fprintf(optf,'Drag0= %f      Shadow0=%f\n',Drag0,Shadow0);
fprintf(optf,'Iteration No, J, Drag, Shadowlength, Xopt\n');

%xopt=x0;
A=[1 0 -1 0];
b=0;
%options=optimoptions('patternsearch','FiniteDifferenceStepSize',1e-2,'Cache','on');
options = psoptimset('Cache','on');
[Xopt,Jopt]=patternsearch(@(xopt)Optimise(xopt,Paramstart,Drag0,Shadow0,PI,PJ,x,y),x0,A,b,[],[],[0;0;0;0],[1;1;1;1],[],options);

fclose('optf');
%% Plot Data from SPARTA
%Get the surface densities on the boundary (cba with the block)
writefiles;
Produce_Graphs(SurfSpecies,SurfDens);

 
%% Plot Drag and Shadow length
%{ 
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
%}



