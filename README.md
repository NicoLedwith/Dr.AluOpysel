
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

## Setup:
You will need Adpet software to install the bitgen onto the Nexys3 board, this can be found on [their website] (http://www.digilentinc.com/Products/Detail.cfm?NavPath=2,66,69&Prod=ADEPT&CFID=22363941&CFTOKEN=ec8d035b0d133dc2-ED74767C-5056-0201-029835BCB78B9C95). Open up Adept and select the `rat_wrapper.bit` once it recognizes the Nexys board. Make sure the board is connected to a VGA display, then install the program using Adept. Have fun!
