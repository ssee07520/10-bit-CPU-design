`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 14:40:30
// Design Name: 
// Module Name: Decoder
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

module Decoder(
    input            clk,
    input [9:0]      IR,        // 10-bit Instruction Register
    input            Z_flag,
    input           IRload,
    output reg       WE,        // Write Enable
    output reg [1:0] WA,        // Write Address (2-bit for 4 registers)
    output reg       RAE,       // Read Port A Enable
    output reg [1:0] RAA,       // Read Port A Address
    output reg       RBE,       // Read Port B Enable
    output reg [1:0] RBA,       // Read Port B Address
    output reg       J_EN,
    output reg       OE,        // Output Enable
    output reg [1:0] IE,        // Input Enable
    
    output reg       Instr_BufferEN, // Instrution Buff
    
    output reg [3:0] imm_instr,  //immediate instrution
    output reg       ZE,        // Zero Flag from ALU
    
    output reg [3:0] decoder_output // ALU Control Signals
    );
    
    reg [7:0]exec_count = 0; // to distinguish decoded or writing


    always @(posedge clk) begin
        if (exec_count == 0) begin //decode state, read first
            WE <= 0;
            case(IR[9:6])  // Decoding based on upper 4 bits (opcode)
                4'b0000: begin // HALT                     
                    WA   <= 2'b00;
                    RAE  <= 0; 
                    RAA  <= 2'b00;
                    RBE  <= 0; 
                    RBA  <= 2'b00;
                    OE   <= 0; 
                    IE   <= 0;
                    ZE   <= 0;
                    J_EN <= 0;
                    Instr_BufferEN <= 0;
                    imm_instr      <= 4'b0000;
                    decoder_output <= 4'bzzzz; // Default operation (HALT)
                end
    
                4'b0001: begin // MOV Rdd, Rss
                    WA      <= IR[3:2];
                    RAA     <= IR[1:0]; // Source Register
                    IE      <= 2'b00;  // Enable ALU_output
                    OE      <= 0;
                    ZE      <= 0;
                    Instr_BufferEN <= 0;
                    decoder_output <= 4'b1000;
                end
    
                4'b0010: begin // IN Rdd
                    WA  <= IR[1:0];  // Destination Register
                    IE  <= 2'b01;     // Enable Input SW
                    OE  <= 0;
                    RAE <= 0; 
                    RBE <= 0; 
                    ZE  = 0;
                    Instr_BufferEN <= 0;
                    decoder_output <= 4'bxxxx;
                end
    
                4'b0011: begin // OUT Rss
                    OE  <= 1;         // Enable Output
                    RAE <= 1;
                    RAA <= IR[1:0];  // Source Register
                    RBE <= 0;
                    ZE  <= 0;
                    IE  <= 2'bxx;   //Enable do not care
                    Instr_BufferEN <= 0;
                    decoder_output <= 4'b1000; //ALU Control: D_output = A
                end
    
                4'b0100: begin // NOT Rdd, Rss
                    RAE <= 1;
                    RAA <= IR[1:0]; // Source Register
                    WA  <= IR[3:2];  // Destination Register
                    OE  <= 0;
                    IE  <= 2'b00;          
                    ZE  <= 1;
                    Instr_BufferEN <= 0;
                    decoder_output = 4'b0000; // NOT operation
                end
    
                4'b0101: begin // JMP aaaa
                    J_EN <= 1;
                end
    
                4'b0110: begin // JNZ aaaa
                    RAE <= 0;
                    RBE <= 0;
                    OE  <= 0; 
                    IE  <= 2'b00;
                    ZE  <= 0;
                    Instr_BufferEN <= 0; 
                    decoder_output <= 4'bxxxx;
                    if (Z_flag==0)begin // If Zero Flag (Z) is not set
                        J_EN <= 1;
                    end else begin
                        J_EN <= 0;
                    end
                end
    
                4'b0111: begin // JN aaaa
                    RAE <= 0;
                    RBE <= 0;
                    OE  <= 0; 
                    IE  <= 2'b00;
                    ZE  <= 0;
                    decoder_output <= 4'bxxxx;
                    if (Z_flag==1)begin // If Zero Flag (Z) is  set
                        J_EN <= 1;
                    end else begin
                        J_EN <= 0;
                    end
                end
    
                4'b1000: begin // LT Rrr, Rqq
                    RAE <= 1;
                    RAA <= IR[3:2]; // First Operand
                    RBE <= 1;
                    RBA <= IR[1:0]; // Second Operand
                    OE  <= 0;
                    ZE  <= 1;
                    Instr_BufferEN <= 0;
                    decoder_output = 4'b0001; // Less Than operation
                end
    
                4'b1001: begin // INC Rrr, #nnnn
                   WA <= IR[5:4];
                   RAE <= 1; // First Operand
                   RAA <= IR[5:4]; // First Operand
                   OE <= 0;
                   ZE <= 1;
                   IE <= 2'b00;
                   Instr_BufferEN <= 1;
                   imm_instr      <= IR[3:0];
                   decoder_output <= 4'b0010;
                end
    
                4'b1010: begin // DEC Rrr, #nnnn
                   WA  <= IR[5:4];
                   RAE <= 1; // First Operand
                   RAA <= IR[5:4]; // First Operand
                   OE  <= 0;
                   ZE  <= 1;
                   IE  <= 2'b00;
                   imm_instr      <= IR[3:0]; 
                   Instr_BufferEN <= 1;
                   decoder_output <= 4'b0011;
                end
    
                4'b1011: begin // ADD Rdd, Rrr, Rqq
                   WA    <= IR[5:4];
                   RAE   <= 1;
                   RAA   <= IR[3:2]; // First Operand
                   RBE   <= 1;
                   RBA   <= IR[1:0]; // Second clk 
                   J_EN  <=0;
                   OE    <= 0;
                   IE    <= 2'b00;
                   ZE    <= 1;
                   Instr_BufferEN <= 0;
                   decoder_output <= 4'b0100; // ADD operation
                end
    
                4'b1100: begin // SUB Rdd, Rrr, Rqq
                   WA   <= IR[5:4];
                   RAE  <= 1;
                   RAA  <= IR[3:2]; 
                   RBE  <= 1;
                   RBA  <= IR[1:0];
                   OE   <= 0;
                   IE   <= 2'b00; 
                   J_EN <=0;
                   ZE   <= 1;
                   decoder_output <= 4'b0101; // SUB operation
                end
    
                4'b1101: begin // AND Rdd, Rrr, Rqq
                    WA  <= IR[5:4]; // Destination Register
                    RAE <= 1;
                    RAA <= IR[3:2]; // First Operand
                    RBE <= 1;
                    RBA <= IR[1:0]; // Second Operand
                    OE  <= 0;
                    IE  <= 2'b00;
                    ZE  <= 1;
                    Instr_BufferEN <= 0;
                    decoder_output <= 4'b0110; // AND operation
                end
    
                4'b1110: begin // OR Rdd, Rrr, Rqq
                    WA   <= IR[5:4]; // Destination Register
                    RAE  <= 1;
                    RAA  <= IR[3:2]; // First Operand
                    RBE  <= 1;
                    RBA  <= IR[1:0]; // Second Operand
                    OE   <= 0;
                    IE   <= 2'b00;
                    ZE   <= 1;
                    Instr_BufferEN <= 0;
                    decoder_output <= 4'b0111; // OR operation
                end
    
                4'b1111: begin // MOV Rdd, #nnnnnn
                    WA  <= IR[5:4]; // Destination Register
                    RAE <= 0;
                    RBE <= 0;
                    IE  <= 2'b10;
                    OE  <= 0;
                    ZE  <= 0;
                    imm_instr      <= IR[3:0];
                    Instr_BufferEN <= 0;
                    decoder_output <= 4'bxxxx;
                end
            endcase
            exec_count <= exec_count + 1;
        end else if (exec_count == 1) begin
            J_EN=0;
            case(IR[9:6])  // Decoding based on upper 4 bits (opcode)
                4'b0001: begin // MOV Rdd, Rss
                    WE <= 1;
                end
                
                4'b0010: begin // IN Rdd
                    WE <= 1;
                end   
                 
                4'b0100: begin // NOT Rdd, Rss
                    WE <= 1;
                end
                
                4'b1001: begin // INC Rrr, #nnnn
                    WE <= 1;
                end
                    
                4'b1010: begin // DEC Rrr, #nnnn
                    WE <= 1;
                end
    
                4'b1011: begin // ADD Rdd, Rrr, Rqq
                    WE <= 1;
                end
    
                4'b1100: begin // SUB Rdd, Rrr, Rqq
                    WE <= 1;
                end
    
                4'b1101: begin // AND Rdd, Rrr, Rqq
                    WE <= 1;
                end
    
                4'b1110: begin // OR Rdd, Rrr, Rqq
                    WE <= 1;
                end
  
                4'b1111: begin // MOV Rdd, #nnnnnn
                    WE <= 1;
                end
            endcase
            exec_count <= 0;
        end
    end

endmodule

