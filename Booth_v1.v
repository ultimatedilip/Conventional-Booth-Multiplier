`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dilip Singh
// 
// Create Date: 03.01.2022 14:24:20
// Design Name: Booth
// Module Name: Booth_v1
// Project Name: Booth
// Target Devices: FPGA/ASICs
// Tool Versions: Vivado 2019.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Module starts here////////
module Booth_v1 #(parameter WIDTH=32)(clk, start, multiplier, multiplicand, product, done);
    input clk, start;                               //input clock and start input 
    input [WIDTH-1:0] multiplier, multiplicand;     //input multiplier and multiplicand for the specified width
    output [2*WIDTH-1:0] product;                   //widthof output = 2*input
    output done;                                    //done flag to stop the module

    reg [2*WIDTH-1:0] product;                      //output reg to store final product
    reg done;                                       
    reg [2:0] state;                                //state initialization with 6 states
    reg [4:0] count;                                //count to know when calculation is over
    reg [WIDTH-1:0] A, Q, M;                        // temperory reg to store the input and evaluate where A is accumulator, Q is multiplier and M is multiplicand
    reg Q_1;                                        // the q-minus-1 bit
    parameter IDLE = 3'b000;                        //idle state or s00
    parameter INITIALIZE = 3'b001;                  //initialize state after start is active (s01)
    parameter OPERATION = 3'b010;                   //conditional state to identify which operation to perform (s02)
    parameter ADD = 3'b011;                         //A=A+M 
    parameter SUBTRACT = 3'b100;                    //A=A-M
    parameter SHIFT_RIGHT = 3'b101;                 //A>>1
    parameter DONE = 3'b110;                        //done state to finish the computation
    

    always @( posedge clk)
        begin
            case (state) //state check block
            IDLE:
                if (start) state <= INITIALIZE;
                else state <= IDLE;
            INITIALIZE:
                begin
                    done = 0;
                    A = 0; 
                    Q_1 = 0;  
                    count = WIDTH;
                    M = multiplicand;
                    Q = multiplier;
                    state = OPERATION;
                end 
            OPERATION:
                begin 
                    case ({Q[0],Q_1})
                    2'b01: 
                        state = ADD;
                    2'b10: 
                        state = SUBTRACT;
                    2'b00,2'b11:
                        state = SHIFT_RIGHT;
                    endcase
                end 
            ADD: 
                begin
                    A = A + M;
                    state = SHIFT_RIGHT;
                end
            SUBTRACT: 
                begin 
                    A = A - M;
                    state = SHIFT_RIGHT;
                end
            SHIFT_RIGHT: 
                begin
                    {A,Q,Q_1} = {A[WIDTH-1],A,Q};  //shift right and copy the msb of A to new A
                    count = count - 1;
                    if (count == 0) 
                        state = DONE; 
                    else
                       state= OPERATION;
                end
            DONE:
                done = 1;
            default: state = IDLE;
            endcase
            product = {A, Q}; //the final output is combination of A and Q
        end
endmodule 
