`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 12:47:37
// Design Name: 
// Module Name: IR
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


module IR(
    input       clk,
    input       rst,
    input [9:0] instr_IRload, // instructions IRload
    input       IRload,
    
    output reg [9:0] IRoutput,
    output reg [3:0] IRoutput_low
);

always @(posedge clk) begin
    if(rst)begin
        IRoutput     <= 10'd0;
        IRoutput_low <= 4'd0;
    end else begin
        if (IRload) begin
            IRoutput     <= instr_IRload;     // Load full 10-bit instruction
            IRoutput_low <= instr_IRload[3:0]; // Extract lower 4 bits
        end
    end
end

endmodule
