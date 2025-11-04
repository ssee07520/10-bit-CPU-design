`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2025 14:15:32
// Design Name: 
// Module Name: MUX
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


module MUX(
    input [9:0] ALU_output,//Data from ALU
    input [9:0] sw,       // input switches
    input [3:0] inst_in,  //  instruction is connected to cpu
    input [1:0] IE_EN,    //IE control
    output reg [9:0] MUX_output
    );
    
    always @(*)begin// Asynchronous
        case(IE_EN)
            2'b00: MUX_output = ALU_output; // output from ALU_output
            2'b01: MUX_output = sw;    // output be switches
            2'b10: MUX_output = inst_in;// output be instruction from decode
            default: MUX_output = 10'bx;
        endcase
   end
    
    
    
endmodule
