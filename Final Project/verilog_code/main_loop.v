// ASSUMPTIONS:
// R0 has controller pin values
// R0 == 0 -> Idle
// R0 == 3'b001 -> Move right
// R0 == 3'b010 -> Move left
// R0 == 3'b100 -> Press A
// Else, jump up

IDLE: // Label -- while loop
CMPI 1, R15
JE #### // Jump to line for move right
CMPI 2, R0
JE #### // Jump to line for move left
CMPI 4, R0
JE #### // Jump to line for Press A
JUMP IDLE

MV_RIGHT:
