module Increment(
     input      [3:0] PC_address, // Direct input from PC
     output reg [3:0] address_out // Directly computed output
);

    always @(*) begin
        address_out = PC_address + 1; // Compute incremented value
    end

endmodule
