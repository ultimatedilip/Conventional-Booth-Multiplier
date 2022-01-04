# Conventional-Booth-Multiplier

This Booth multiplier is a parameterized Booth multiplier where WIDTH can be adjusted according to the user.
Design is already Tested for 32,16 and 8-bit.
This design contains 6 states to perform the given operation.
1. S01 is idle state where module requires start to be 1'b0 to move to next state S02.
2. S02 is Initialization state where data is assigned to internal registers.
3. S03(operation) will check for  {Q[0],Q_1} combination as given in Booth algorithm whether to shift the data or add or subtract the     data.
4. S04 state performs addition of A and M then assigns the result to A (A=A+M).
5. S05 state performs subtraction of A and M then assigns the result to A (a=A-M).
6. S06 state is done state to finish the compuation and raising the done flag to high.

If there are any bugs or error please mail me. thanks
