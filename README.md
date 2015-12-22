
Adventure Time with Dr. Alu OpySel
=============================================
by 
Colton Sundstrom 
and 
Nico Ledwith

Our project is a simple platform runner game. The player must help Dr. Alu OpySel (a yellow block) avoid the holes in the ground. By pushing a button, the player can make the Doctor jump. Timing is critical here.

We ran into a few issues. First off, the provided wrapper file didn’t seem to work with our board, so we built a functional one based on our wrapper from Experiment 10. The next issue we ran into was an apparent glitch that draws dots in incorrect locations. The registers holding the coordinates never reach these coordinates (as far as we could determine), yet these dots are still drawn. This can be seen when the Doctor jumps. However, this is not a huge issue as it does not affect the functionality of the game; furthermore it actually adds a bit of “flare” to our rather plain graphics scheme.

## Operating Manual:
*(to be used with a Nexys3 board)*

- Left Button 	=> 	Jump
- Top Button  	=>	Restart Game
