`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 13:58:52
// Design Name: 
// Module Name: FETCH
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



module FETCH(
    input clk,
    input rst,
    output reg PCload,
    output reg IRload
);

    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state  <= 2'b00; // Reset to initial state
            PCload <= 1'b0;  // Enable PCload first to send address to ROM
            IRload <= 1'b0;  // IRload should be off initially
        end else begin
            case (state)
                2'b00: begin  
//                    // First cycle: PCload sends address to ROM
                    PCload <= 1'b0;  
                    IRload <= 1'b0;  
                    state  <= 2'b01;  
                end
                2'b01: begin  
                    // Second cycle: Disable PCload, enable IRload to fetch instruction
                    PCload <= 1'b1;  
                    IRload <= 1'b1;  
                    state  <= 2'b00;  
                end
            endcase
        end
    end

endmodule
