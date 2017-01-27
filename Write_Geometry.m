function Write_Geometry(xbar,ybar)
global imax;
myfile = fopen('geometry.step', 'w');

% Write the preamble for the file, so SPARTA doesn't give an error.
fprintf(myfile, 'dummy 2d line test\n\n');
%Tell SPARTA how many points and lines are present
fprintf(myfile, '%i points\n', imax+1);
fprintf(myfile, '%i lines\n\n', imax+1);

%% Begin writing points
fprintf(myfile, 'Points\n\n');

% Point ID, x-coord, y-coord
for i=1:imax+1
    fprintf(myfile, '%i %f %f\n', i , xbar(i), ybar(i));
end

%% Begin writing lines
fprintf(myfile, '\nLines\n\n');

% Lines are defined as starting point ID, and ending point ID
% Line ID,  Start point ID, End point ID
for i=1:imax
    fprintf(myfile, '%i %i %i\n',i, i, i+1);
end

fprintf(myfile, '%i %i 1\n', imax+1, imax+1);

fclose('all');




