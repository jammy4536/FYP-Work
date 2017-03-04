function J=Optimise(xopt,Paramstart,Drag0,Shadow0, PI,PJ,x,y)
global C Oaverage steplength D Jstore ShadowL SurfSpecies SurfDens;
global normDrag normShad j;

%% Create the Geometry with parameterisation (Start of Opt Loop)
%This will be the start of the optimisation loop, through taking the
%current geometry, and then stretching it with the new control points that
%have been changed by the optimiser, to create a new geometry to be tested. 
%display(xopt);
[PI,PJ]=convertDV(xopt);
PI(1,2)=0.01;

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


%% Find the length of the shadow

%step through to find where the shadow begins
i=1;
whilecheck=1;
while SurfSpecies(i,5)>0.05*SurfSpecies(1,5)
    i=i+1;
    if i>=C(1)-1
        fprintf('The solver failed to find the shadow.')
        whilecheck=0;
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
    if whilecheck==0
        break;
    end
end

ShadowLength=SurfSpecies(i,1)-1.5-steplength; %Shadow length

Drag=sum(F(:,1));   %Drag=sum of forces in x-direction
normShad=ShadowLength/Shadow0;

ShadowPen=30*abs(1-normShad);

%% End of Optimisation Loop.
%Create the input arguments fun, x0, a, b
%normalise drag and shadowlength

ShadowL(j)=ShadowLength;
normDrag=Drag/Drag0;

%J = normDrag+ShadowPen
J=normDrag/normShad;
D(j)=Drag;
Jstore(j)=J;
j=j+1;
fprintf('%i   %f   %f   %f   %f   %f   %f   %f',j,J,Drag,ShadowLength,xopt(:,1))
