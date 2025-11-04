`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2025 14:39:23
// Design Name: 
// Module Name: RF
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


module RF(
    input        clk,
    input        WE,  // Write Enable
    input  [1:0] WA,  // Write Address (2-bit for 4 registers)
    input        RAE, // Read Port A Enable
    input  [1:0] RAA,  // Read Port A Address
    input        RBE,        // Read Port B Enable
    input  [1:0] RBA,  // Read Port B Address
    input  [9:0] input_data, // Data to write (10-bit)
    
    output reg [9:0] Aout, // Read Port A Output (10-bit)
    output reg [9:0] Bout  // Read Port B Output (10-bit)
    );

    // 4 registers, each 10 bits wide
    reg [9:0] RF [3:0];

    // Write Operation (Synchronous)
    always @(posedge clk) begin
        if (WE) begin
            RF[WA] <= input_data;
         end
    end

    // Read Operation (Asynchronous)
    always @(*) begin
        if (RAE)begin// if RAE is high, out A from the register addressed by RAA
            Aout <= RF[RAA];
        end

        if (RBE)begin// if REE is high, out E from the register addressed by RAEA
            Bout <= RF[RBA];
        end
    end

endmodule
