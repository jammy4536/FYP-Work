function [SurfSpecies,SurfDens,ShadowLength] = getSurfaceSpecies
global Oaverage steplength;
steplength=0.01;
%% Find how many points in x-direction
is= fopen('in.step', 'r');

%Skip through to the create_box command
for f=1:10
    bleh=fgets(is);
end

%Read the line, ignoring the create_box text
sizeC=[3 1];
C= fscanf(is, ['create_grid' '%f %f %f'], sizeC);

%Skip through to the trans command
%Starting from line 12 to line 29
for f=1:19
    bleh=fgets(is);
end
sizeB=[3 1];
%Read the line, ignoring the trans text
B= fscanf(is, ['trans' '%f %f %f'], sizeB);

fclose('all');

SurfSpecies=zeros(C(1),6);
SurfDens=zeros(C(1),2);

%% Get the values of species density on the SC surface (boundary)
tempSurfSpecies=dlmread('Species_Density_Output/speciesdens.1000.grid',' ',9,0);
tempSurfDens=dlmread('Overall_Density_Output/pdens.1000.grid', ' ', 9,0);
temp=sortrows(tempSurfSpecies);
temp2=sortrows(tempSurfDens);
clear tempSurfSpecies tempSurfDens;

tempSurfSpecies(:,1)=temp(1:C(1),2);
tempSurfSpecies(:,2:6)=temp(1:C(1),4:8);
tempSurfDens(:,1)=temp2(1:C(1),2);
tempSurfDens(:,2)=temp2(1:C(1),4);

%% Smooth the graphs somewhat
for j=1:3
    SurfSpecies(1,:)=(tempSurfSpecies(1,:)+tempSurfSpecies(2,:))/2;
    SurfSpecies(C(1),:)=(tempSurfSpecies(C(1)-1,:)+tempSurfSpecies(C(1),:))/2;
    SurfDens(1,:)=(tempSurfDens(1,:)+tempSurfDens(2,:))/2;
    SurfDens(C(1),:)=(tempSurfDens(C(1)-1,:)+tempSurfDens(C(1),:))/2;

    for i=2:C(1)-1
        if tempSurfSpecies(i,1)>=1.9 && tempSurfSpecies(i,1)<=2.1
            SurfSpecies(i,:)=tempSurfSpecies(i,:);
        end
        if tempSurfDens(i,1)>=1.9 && tempSurfDens(i,1)<=2.01
            SurfDens(i,:)=tempSurfDens(i,:);
        end
        
        SurfSpecies(i,:)=(tempSurfSpecies(i,:)+tempSurfSpecies(i+1,:)+tempSurfSpecies(i-1,:))/3;
        SurfDens(i,:)=(tempSurfDens(i,:)+tempSurfDens(i+1,:)+tempSurfDens(i-1,:))/3;
    end
    tempSurfSpecies=SurfSpecies;
    tempSurfDens=SurfDens;
end

%% Find the length of the shadow

Oaverage= SurfSpecies(C(1),5);

%step through to find where the shadow begins
i=1;
while SurfSpecies(i,4)>0
    i=i+1;
end
%get a bit of clearance to ensure its into the shadow
i=i+5;

%step through to find when the atomic oxygen is greater than 10% of FS
while SurfSpecies(i,5)<=Oaverage*0.10
    i=i+1;
end

ShadowLength=SurfSpecies(i,1)-2-steplength;

