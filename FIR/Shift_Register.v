module Shift_Register (
    clock,
    enable,
    reset,
    in,
    address,
    out
);
    parameter input_width, coeff_size;
    localparam address_size = $clog2(coeff_size);
    input clock,
    enable,
    reset;
    input signed [input_width - 1:0] in;
    input [address_size -1:0] address;
    output signed [input_width - 1:0] out;

  wire signed [15:0] register_out[0:coeff_size];
  assign register_out[0] = in;
  genvar i;
  generate
    for (i = 0; i < coeff_size; i = i + 1) begin : REGISTERS
      Register REG (
          clock,
          enable,
          reset,
          register_out[i],
          register_out[i+1]
      );
    end
  endgenerate
  assign out = register_out[address+1];
endmodule
