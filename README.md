## How it works
This chip is a hardware coprocessor that calculates the Greatest Common Divisor (GCD) of two 4-bit numbers using a optimized version of Stein's Algorithm (Binary GCD). 

It reads two 4-bit numbers from the 8 dedicated input switches. When the start button is pressed, a custom Finite State Machine (FSM) computes the GCD using combinational bitwise shifts and subtractions, completely bypassing the need for slow, complex division logic. While calculating, the 7-segment display shows a loading dash. Once the state machine reaches the final answer, the result is decoded and displayed on the 7-segment display.

## How to test
1. Set the bottom 4 input switches (`ui_in[3:0]`) to your first number (A).
2. Set the top 4 input switches (`ui_in[7:4]`) to your second number (B).
3. Press the Start button (`uio_in[0]`).
4. The 7-segment display (`uo_out`) will show a dash (`-`) while processing, and then output the GCD result.

## External hardware
No external hardware is required. The design uses the standard Tiny Tapeout demo board's built-in dip switches, push buttons, and 7-segment display.