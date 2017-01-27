function [x,y] = Create_Geometry()
%% Create the geometry to be parameterised
global imax;

%% Box Parameters 
stepstart=4; %points until box top
stepend=6; %point from start until box end
stepheight=2; %box height
dx=stepheight/(stepend-stepstart); %the change in x to get the necessary distance

x=zeros(imax+1,1);
y=zeros(imax+1,1); 


%% Front of the Box
%want x(0) and y(0) to be 0, so leave untouched
for i=2:stepstart+1 
    y(i)=stepheight*((i-1)/stepstart);
    x(i)=0;
end

%% Top of the Box
k=1;
for i=stepstart+2:stepend+1
    y(i)=stepheight;
    x(i)=k*dx;
    k=k+1;
end

%% Back of the Box
for i=stepend+2:imax+1
    y(i)=stepheight*(1-(i-1-stepend)/stepstart);
    x(i)=x(i-1);
end


%% Parameterisation Test Geometry (Circle)
% theta=0;
% dtheta=2*pi/imax;
% 
% for i=1:imax+1
%    x(i)=0.5*(1+sin(theta));
%    y(i)=0.5*(1+cos(theta));
%    theta=theta+dtheta;
% end


