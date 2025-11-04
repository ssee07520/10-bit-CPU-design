`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 13:19:01
// Design Name: 
// Module Name: MUX2
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


module MUX2(
    input [3:0] instr_output, //instructions output from IR (lower 4 bits)
    input [3:0] incre_output,// Incrementer output (PC + 1)
    input       J_EN, // Jump Enable , controls which input is selected
    output reg [3:0] instr_MUX // MUX output,  instruction address or incremented address
    );
    
    always @(*)begin
        if(J_EN)begin// If J_EN is high, use the instruction address from IR
          instr_MUX <= instr_output;
        end else begin// If J_EN is low, use the incremented address from the Incrementer
            instr_MUX <= incre_output;
        end
   end
    
    
    
endmodule
