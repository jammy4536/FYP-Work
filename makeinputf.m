function makeinputf
global timestep;
timestep=1500;
A = regexp( fileread('in.step'), '\n', 'split');

%Lines to change: 55, 56, 60, 61, 66/67, 73, 78

A{55} = sprintf('fix   1 ave/grid 1 100 %.0f c_1[*]', timestep);
A{56} = sprintf('dump  1 grid all %.0f /dev/shm/pdens.*.grid id xlo ylo f_1 proc', timestep);
A{60} = sprintf('fix   2 ave/grid 1 100 %.0f c_2[*]', timestep);
A{61} = sprintf('dump  species grid all %.0f /dev/shm/speciesdens.*.grid id xlo ylo f_2[*] proc',timestep);
A{66} = sprintf('fix   3 ave/surf all 1 100 %.0f c_3[*] ave one', timestep);
A{67} = sprintf('dump  3 surf all %.0f /dev/shm/forces.*.surf id f_3[*]',timestep);
A{73} = sprintf('fix   4 ave/time 1 100 %.0f c_4[*] mode vector file /dev/shm/Boundary.surf', timestep);
A{76} = sprintf('#fix 5 ave/grid 1 100 %.0f c_2[*] c_5[*]', timestep);
A{78} = sprintf('#dump knusden grid all %.0f /dev/shm/gas_properties.grid id c_6[*]',timestep);
A{84} = sprintf('run 		    %.0f',timestep);
fid = fopen('in.step', 'w');
fprintf(fid, '%s\n', A{:});
fclose(fid);