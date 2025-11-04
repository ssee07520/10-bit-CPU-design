`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2025 15:13:28
// Design Name: 
// Module Name: OutputBuffer
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


module OutputBuffer (
    input             OE,         
    input       [9:0] data, 
    output wire [9:0] Data_Out 
);

    assign Data_Out = (OE) ? data : 10'b0000000000;

endmodule
