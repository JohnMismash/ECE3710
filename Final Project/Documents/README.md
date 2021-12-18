#ECE 3710 - Computer Design Lab

## Authors
John 'Jack' Mismash, Andrew Porter, Vanessa Bentley, Zach Phelan
12/17/21

## Overview
This document provides an overview of Group 1 and our respective Final Project
details for our Connect 4 digital logic game.

Our final project directory contains our source Verilog HDL code, our Python
Assembler code, as well as testing files or testbenches needed for the project.
Our top-level module is top\_level\_counter.  This module instantiates the FSM and
Bit\_gen modules which run the logic and display of the game respectively. All
other modules are created under the umbrella of the FSM.

It may be important to the reader to know this code is somewhat, incomplete.
Our group was not able to finalize the overall structure and functionality of
connecting the memory containing the game state and integrate it in sync within
our bit generator file for the VGA connection/output.


## Compilation
In order to compile this project yourself, you must change the true\_doal\_port\_ram\_single\_clock.v module's "file" parameter to use a correct path for a memory initialization file.
