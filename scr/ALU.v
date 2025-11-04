`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2025 13:49:04
// Design Name: 
// Module Name: ALU
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


module ALU (
    input [3:0] ALU_cntrl,//From decode
    input [9:0] A, // RF output
    input [9:0] B, // RF output
    input [3:0] imm_num,// immediate data
    output reg  Z,     //Z falg
    output reg [9:0] D_output //ALU out
);
   
    always @(*) begin
        case (ALU_cntrl)
            4'b0000: D_output = ~A; // NOT Rdd, Rss
            4'b0001: D_output = (A < B) ? 0 : 1; // LT Rrr, Rqq
            4'b0010: D_output = A + imm_num; // INC Rrr, #nnnn
            4'b0011: D_output = A - imm_num; // DEC Rrr, #nnnn
            4'b0100: D_output = A + B; // ADD Rdd, Rrr, Rqq
            4'b0101: D_output = A - B; // SUB Rdd, Rrr, Rqq
            4'b0110: D_output = A & B; // AND Rdd, Rrr, Rqq
            4'b0111: D_output = A | B; // OR Rdd, Rrr, Rqq
            4'b1000: D_output = A;
            default: D_output = A; //1111, 1110
        endcase
       
        Z = (D_output == 10'b0) ? 1 : 0;
    end
   
endmodule
