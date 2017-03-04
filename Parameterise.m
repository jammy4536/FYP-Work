function [xbar, ybar] = Parameterise(x, y, PI,PJ)
%% Parameterise the geometry
global xmin xmax ymin ymax imax m n j;
%Parameterised coordinate arrays
xbar=zeros(imax+1,1);
ybar=zeros(imax+1,1);

%% Create a normalised coordinate base

s=zeros(imax+1,1);
t=zeros(imax+1,1);

for i=1:imax+1
    s(i)=(x(i)-xmin)/(xmax-xmin);
    t(i)=(y(i)-ymin)/(ymax-ymin);
end

%% Find the Bernstein Polynomials
Bx=zeros(imax+1,m+1);
By=zeros(imax+1,n+1);

%Find the x bernstein polynomial using normalised coordinates
for g=0:m
    C=nchoosek(m,g);
    for i=0:imax
        Bx(i+1,g+1)=C*s(i+1)^(g)*(1-s(i+1))^(m-g);
    end
end

%The y bernstein polynomial
for g=0:n
    C=nchoosek(n,g);
    for i=0:imax
        By(i+1,g+1)=C*t(i+1)^(g)*(1-t(i+1))^(n-g);
    end
end


%% Create the new coordinates (A summation of each Bernstein Polynomial)
for i=1:imax+1
    for g=0:m
        for k=0:n
            xbar(i)=xbar(i)+Bx(i,g+1)*By(i,k+1)*PI(k+1,g+1);
            ybar(i)=ybar(i)+Bx(i,g+1)*By(i,k+1)*PJ(k+1,g+1);
        end
    end
end

figure('Name','Geometry Plot','Color','White');
plot(xbar,ybar);
axis equal;
xlabel('x (m)'); ylabel('y (m)');
geomtitle=sprintf('Protrusion Geometry (Iteration %i)',j);
title(geomtitle);
            
            
            