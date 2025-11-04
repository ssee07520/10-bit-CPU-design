`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2025 15:08:35
// Design Name: 
// Module Name: Flip_Flop
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


module Flip_Flop(
    input        clk,
    input        rst, 
    input        ZE,    // Zero Flag Enable
    input        Z,     // Zero Flag from ALU
    output reg   Z_FF   // Stored Zero Flag
);

    always @(posedge clk) begin
        if(rst)begin //when reset is high reset Z_FF
            Z_FF <= 0;
       end else begin
            if (ZE) begin
                Z_FF <= Z;  // Store Z when ZE is active
            end
       end
    end

endmodule