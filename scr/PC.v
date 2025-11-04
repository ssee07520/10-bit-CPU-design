`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 13:25:29
// Design Name: 
// Module Name: PC
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


module PC(
    input        rst,
    input        clk,
    input        PCload_EN,
    input  [3:0] instr_MUX,
    
    output reg [3:0] PC_address  // Declare as reg because it's assigned inside always block
);

always @(posedge clk or posedge rst) begin 
    if (rst) begin
        PC_address <= 4'b0000;  // Reset to zero when rst is high
    end else if (PCload_EN) begin
        PC_address <= instr_MUX;  // Load new instruction when enabled
    end
end

endmodule

