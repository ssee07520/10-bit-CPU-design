`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.03.2025 13:14:27
// Design Name: 
// Module Name: INSTBuffer
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


module INSTBuffer(
        input             Ins_Buff,         
        input       [3:0] imm_data, 
        output wire [3:0] imm_out 
);

    assign imm_out = (Ins_Buff) ? imm_data : 4'bzzzz; 

endmodule