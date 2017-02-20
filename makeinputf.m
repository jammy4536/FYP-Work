function makeinputf
global timestep;

A = regexp( fileread('in.step'), '\n', 'split');

%Lines to change: 55, 56, 60, 61, 66/67, 73, 78

A{55} = sprintf('fix   1 ave/grid 1 %.0f %.0f c_1[*]',timestep, timestep);
A{56} = sprintf('dump  1 grid all %.0f /dev/shm/pdens.*.grid id xlo ylo f_1 proc', timestep);
A{60} = sprintf('fix   2 ave/grid 1 %.0f %.0f c_2[*]',timestep, timestep);
A{61} = sprintf('dump  species grid all %.0f /dev/shm/speciesdens.*.grid id xlo ylo f_2[*] proc',timestep);
A{66} = sprintf('fix   3 ave/surf all 1 %.0f %.0f c_3[*] ave one',timestep, timestep);
A{67} = sprintf('dump  3 surf all %.0f /dev/shm/forces.*.surf id f_3[*]',timestep);
A{73} = sprintf('fix   5 ave/time 1 %.0f %.0f c_5[*] mode vector file /dev/shm/Boundary.surf',timestep, timestep);
A{78} = sprintf('run 		    %.0f',timestep);
fid = fopen('in.step', 'w');
fprintf(fid, '%s\n', A{:});
fclose(fid);