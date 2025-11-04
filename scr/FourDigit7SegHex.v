`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////
//Title       : 10-bit CPU Design
//Created by  : 2407570
//Date        : 2025/03/26
//Description : A simple 10-bit CPU designed for Digilent Basys3 board
/////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module FourDigit7SegHex (
    input        clk,           
    input  [9:0] Data_Out,      // 10-bit input (0x000 - 0x3FF)
    output reg [6:0] seg,         // 7-segment display output (active-low)
    output reg [3:0] an,           // Active-low digit select
    output reg [9:0] sw        //switches
);

    reg [1:0] digit_select = 0;    // Tracks which digit is currently displayed
    reg [3:0] current_digit;       // Current hex digit to display
    reg [16:0] refresh_counter = 0; // Slow down refresh rate

    wire [15:0] hex_number;  // 16-bit representation with valid hex range

    // Convert 10-bit input to 16-bit padded hex value
    assign hex_number = {6'b000000, Data_Out};  

    // Hex to 7-segment decoding
    always @(*) begin
        case (current_digit)
            4'h0: seg = 7'b0000001;
            4'h1: seg = 7'b1001111;
            4'h2: seg = 7'b0010010;
            4'h3: seg = 7'b0000110;
            4'h4: seg = 7'b1001100;
            4'h5: seg = 7'b0100100;
            4'h6: seg = 7'b0100000;
            4'h7: seg = 7'b0001111;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0000100;
            4'hA: seg = 7'b0001000; // A
            4'hB: seg = 7'b1100000; // B
            4'hC: seg = 7'b0110001; // C
            4'hD: seg = 7'b1000010; // D
            4'hE: seg = 7'b0110000; // E
            4'hF: seg = 7'b0111000; // F
            default: seg = 7'b1111111; // Blank display
        endcase
    end

    // Clock divider for refresh rate
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter == 50000) begin // Adjust for display stability
            refresh_counter <= 0;
            digit_select <= digit_select + 1;
        end
    end

    // Multiplex the 4 digits
    always @(*) begin
        case (digit_select)
            2'b00: begin an = 4'b1110; current_digit = hex_number[3:0]; end
            2'b01: begin an = 4'b1101; current_digit = hex_number[7:4]; end
            2'b10: begin an = 4'b1011; current_digit = hex_number[9:8]; end
            2'b11: begin an = 4'b0111; current_digit = 4'h0; end // Only three valid digits
            default: begin an = 4'b1111; current_digit = 4'hF; end
        endcase
    end

 CPU cpu(
    .clk(clk),
    .rst(rst),
    .sw(sw),
    .dataout(Data_Out)
);





endmodule

