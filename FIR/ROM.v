module ROM (
    clock,
    address,
    out
);
  parameter coeff_size = 64, input_width = 16;
  localparam address_size = $clog2(coeff_size);
  input clock;
  input [address_size - 1:0] address;
  output reg signed [input_width - 1:0] out;
  reg signed [input_width - 1:0] mem[0:coeff_size - 1];

  initial begin
    $readmemb("coeffs.txt", mem);
  end

  always @(posedge clock) out <= mem[address];

endmodule


// module LUT_TB;
//   reg [5:0] address = 0;
//   wire signed [15:0] out;
//   LUT l (
//       address,
//       out
//   );
//   always #1 address = address + 1;
//   initial begin
//     #100 $stop;
//   end
// endmodule
