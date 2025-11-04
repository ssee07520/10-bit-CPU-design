//////////////////////////////////
//Title       : 10-bit CPU Design
//Created by  : YaLunLee
//Date        : 2025/03/26
//Description : A simple 10-bit CPU designed for Digilent Basys3 board
/////////////////////////////////
module CPU(
    input        clk,
    input        rst,
    input [9:0]  sw,
    output [9:0] dataout
);
//////////////////////////////////////////////////////////////////////////////////////////////////
    wire [3:0] incre_output_w, IRoutput_low_w, imm_instr_w;
    wire [3:0] address_out_w, decoder_output_w;
    wire [3:0] instr_MUX_w, imm_out_w ;
    wire [3:0] PC_address_w;
    wire [9:0] instruction_w, IRoutput_w, MUX_output_w, Aout_w, Bout_w, D_output_w ;
    wire PCload_w, IRload_w, WE_w, RAE_w, RBE_w, J_EN_w, ZE_w, Z_w, Z_FF_w, OE_w;
    wire [1:0] IE_w, WA_w, RAA_w, RBA_w, Instr_BufferEN_w ;
   
//////////////////////////////////////////////////////////////////////////////////////////////////    
    
        Decoder decode(
        .clk(clk),
        .IR(IRoutput_w),        // 10-bit Instruction Register
        .Z_flag(Z_FF_w),
        .IRload(IRload_w),
        .WE(WE_w),        // Write Enable
        .WA(WA_w),        // Write Address (2-bit for 4 registers)
        .RAE(RAE_w),       // Read Port A Enable
        .RAA(RAA_w),       // Read Port A Address
        .RBE(RBE_w),       // Read Port B Enable
        .RBA(RBA_w),       // Read Port B Address
        .J_EN(J_EN_w),
        .OE(OE_w),        // Output Enable
        .IE(IE_w),     // Input Enable
    
        .Instr_BufferEN(Instr_BufferEN_w),
    
         .imm_instr(imm_instr_w), 
         .ZE(ZE_w),        // Zero Flag from ALU
         .decoder_output(decoder_output_w) // ALU Control Signals
    );
////////////////////////////////////////////////////////////////////////////////////    
    
    MUX mux(
    .ALU_output(D_output_w),
    .sw(sw), //switches
    .inst_in(imm_instr_w),  // immediate_instruction 
    .IE_EN(IE_w),
    .MUX_output(MUX_output_w)
    );
    
     RF rf(
        .clk(clk),
        .WE(WE_w),   // Write Enable
        .WA(WA_w),   // Write Address (2-bit for 4 registers)
        .RAE(RAE_w), // Read Port A Enable
        .RAA(RAA_w), // Read Port A Address
        .RBE(RBE_w), // Read Port B Enable
        .RBA(RBA_w),  // Read Port B Address
        .input_data(MUX_output_w), // Data to write (10-bit)
        .Aout(Aout_w), // Read Port A Output (10-bit)
        .Bout(Bout_w)  // Read Port B Output (10-bit)        


    );
    
    
  INSTBuffer buff(
        .Ins_Buff(Instr_BufferEN_w),         
        .imm_data(imm_instr_w), 
        .imm_out(imm_out_w) 
);
    
    
    
    ALU alu(
    .ALU_cntrl(decoder_output_w),
    .A(Aout_w), 
    .B(Bout_w),
    .imm_num(imm_out_w),
    .Z(Z_w),
    .D_output(D_output_w)
  
);
    
    
    Flip_Flop ff(
        .clk(clk),
        .rst(rst), 
        .ZE(ZE_w),    // Zero Flag Enable
        .Z(Z_w),     // Zero Flag from ALU
        .Z_FF(Z_FF_w)   // Stored Zero Flag
);
    
    
    
    OutputBuffer OB(
        .OE(OE_w),         
        .data(D_output_w), 
        .Data_Out(dataout) 
);
    
    
    
//////////////////////////////////////////////FETCH//////////////////////////////////////////////////////////////////
    FETCH fetch(
    .clk(clk),
    .rst(rst),
    .PCload(PCload_w),
    .IRload(IRload_w)
    );

    // Instantiate MUX2
    MUX2 mux_inst (
        .instr_output(IRoutput_low_w),
        .incre_output(address_out_w),
        .J_EN(J_EN_w),
        .instr_MUX(instr_MUX_w)
    );

    // Instantiate Increment
    Increment inc_inst (
        .PC_address(PC_address_w),
        .address_out(address_out_w)
    );
    
        // Instantiate PC
    PC pc_inst (
        .rst(rst),
        .clk(clk),
        .PCload_EN(PCload_w),
        .instr_MUX(instr_MUX_w),
        .PC_address(PC_address_w)
    );
    
    ROM rom(
        .clk(clk),
        .rst(rst),
        .PC_address(PC_address_w),
        .instruction(instruction_w)
    );
    IR ir(
    .clk(clk),
    .rst(rst),
    .instr_IRload(instruction_w),
    .IRload(IRload_w),
    .IRoutput(IRoutput_w),
    .IRoutput_low(IRoutput_low_w)
);

endmodule