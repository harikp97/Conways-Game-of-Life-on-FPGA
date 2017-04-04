# Conway-s-Game-of-Life-on-FPGA

Conway’s Game of Life works on an infinite grid of square cells. A finite grid
with wrap around at the edges is used to mimic the infinite grid. The initial
state of every cell in the grid is fed into a bit vector (1 for live and 0 for dead).
The output is displayed on a VGA display at 800*600 resolution; red colour
representing live cells and black representing the dead ones. After a reasonable
amount of time (for the pattern transition to be clearly visible), the next state
of each cell is found based on the current state of the cells and the corresponding
bit value modified.

INSTRUCTIONS
Set 'vga.vhd' as the top level entity. 
The initial condition can be set by changing the value of the bit-vector in the code.
