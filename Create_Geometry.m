function [x,y] = Create_Geometry(stepheight, steplength)
%% Create the geometry to be parameterised
global imax;

%% Box Parameters 
stepfront=2; %points on the box front
stepback=2;  %points on the box back
steptop=3;   %points on the box top
imax=stepfront+stepback+steptop;
dx=steplength/steptop; %the change in x to get the necessary distance
dyf=stepheight/stepfront;   %the change in y on the front to get the box
dyb=stepheight/stepback;    %change in y on be back

x=zeros(imax+1,1);
y=zeros(imax+1,1); 


%% Front of the Box
%want x(0) and y(0) to be 0, so leave untouched
for i=2:stepfront+1 
    y(i)=(i-1)*dyf;
end

%% Top of the Box
k=1;
for i=stepfront+2:stepfront+steptop+1
    y(i)=stepheight;
    x(i)=k*dx;
    k=k+1;
end

%% Back of the Box
k=1;
for i=stepfront+steptop+2:imax+1
    y(i)=stepheight-dyb*k;
    x(i)=steplength;
    k=k+1;
end

% figure;
% plot(x,y);

%% Parameterisation Test Geometry (Circle)
% theta=0;
% dtheta=2*pi/imax;
% 
% for i=1:imax+1
%    x(i)=0.5*(1+sin(theta));
%    y(i)=0.5*(1+cos(theta));
%    theta=theta+dtheta;
% end


