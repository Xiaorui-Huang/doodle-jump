# Doodle Jumps to MARS
[Doodle jump](https://poki.com/en/g/doodle-jump "The original") in Minecraft style written in MIPS assembly 

This game was written and simulated using [MIPS Assembly and Runtime Simulator(MARS)](http://courses.missouristate.edu/kenvollmar/mars/ "Please download and give the game a try🥺") version 4.5

Game has been tested on JRE 9. 

## Installation
1. Download the [MIPS Assembly and Runtime Simulator](https://courses.missouristate.edu/kenvollmar/mars/download.htm) or run
```bash
wget https://courses.missouristate.edu/kenvollmar/mars/MARS_4_5_Aug2014/Mars4_5.jar
```

2. Install any appropriate JRE runtime. 

    *Windows*
   
    ```bash
    winget install --id Azul.Zulu.9.JRE
    ```

    *Ubuntu*
    ```bash
    sudo apt install default-jre 
    # for specific versions
    # sudo apt install openjdk-9-jre 
    ```

## For display and keyboard configuration
Go to Tools, select **Bitmap display** as well as **Keyboard and Display MMIO Simulator**
### Bitmap Display Configuration:
- Unit width in pixels: `8`
- Unit height in pixels: `8`
- Display width in pixels: `256`
- Display height in pixels: `256`
- Base Address for Display: `0x10008000 ($gp)`

After configuration, Click **Connect to MIPS** on both windows

Open `doodlejump.s`, Go to the **Run** tab, assemble the code and run

## Game commands
- j - go left
- k - go right
- s - respawn (when Game Over)

## Doodle Jump in action 

https://user-images.githubusercontent.com/42769475/142275258-1143dcc3-984a-4bdb-acf7-fc294da5ffe8.mp4
