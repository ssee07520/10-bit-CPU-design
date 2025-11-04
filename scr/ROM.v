`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 13:09:31
// Design Name: 
// Module Name: ROM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module ROM(
    input        clk,
    input        rst,
    input  [3:0] PC_address,
    output reg [9:0] instruction
);

    reg [9:0] ROM [15:0];

    initial begin
        ROM[0] = 10'b0010000000; // IN R0
        ROM[1] = 10'b1011010000; // ADD R1, R0, R0
        ROM[2] = 10'b1010010001; // DEC R1, #1  -- (2N-1)
        ROM[3] = 10'b1111110000; // MOV R3, #0  -- r3 = 0
        ROM[4] = 10'b1011111101; // ADD R3, R3, R1  -- r3 += (2N-1)
        ROM[5] = 10'b1010000001; // DEC R0, #1      -- r0 -= 1
        ROM[6] = 10'b0110000100; // JNZ LOOP (Address 4)
        ROM[7] = 10'b0011110000; // OUT R3
        ROM[8] = 10'b0101000000; // JMP 0
    end

    always @(posedge clk or posedge rst) begin // check if clock and reset is high
        if (rst) begin //if reset is high, instruction will reset.
            instruction <= 10'd0; 
        end else begin //otherwise, ROM provides corresponding instruction according to PC_address
            instruction <= ROM[PC_address];
        end
    end

endmodule

