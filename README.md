# doodle-jump
[Doodle jump](https://poki.com/en/g/doodle-jump "The original") in Minecraft style with MIPS assembly 

This game was written and simulated using [MIPS Assembly and Runtime Simulator](http://courses.missouristate.edu/kenvollmar/mars/ "Please download and give the game a try🥺") version 4.5 on a Windows system

## For display and keyboard configuration
Go to Tools, select **Bitmap display** as well as **Keyboard and Display MMIO Simulator**
### Bitmap Display Configuration:
- Unit width in pixels: 8
- Unit height in pixels: 8
- Display width in pixels: 256
- Display height in pixels: 256
- Base Address for Display: 0x10008000 ($gp)

After configuration, click **Connect to MIPS**, assemble the code and run

## Game commands
- j - go left
- k - go right
- s - respawn (when Game Over)

## Demo

https://user-images.githubusercontent.com/42769475/142275258-1143dcc3-984a-4bdb-acf7-fc294da5ffe8.mp4
