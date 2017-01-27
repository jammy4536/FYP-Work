""" This bit of code is hoped to be a function to iterate my FYP work, by allowing it to iterate without human input.
 This will be useful as I can then pass it off to a supercomputer and let it do its own thing, which is great. I can focus on writing.
 To do this, I will need python to:
 1. Call the executable Create_Geometry.
 2. Run SPARTA with the new geometry.
 3. Run a bash program, GridConverter, to transmute files into usable formats.
 4. Run a geometry optimisation program.
 5. Repeat, until a metric is met (To be determined, likely something like fraction value on drag over two iterations). """

from subprocess import call
call(["./Create_Geometry"])
