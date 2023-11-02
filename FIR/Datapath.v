module Datapath (
    clock,
    input_reset,
    input_enable,
    output_reset,
    output_enable,
    counter_reset,
    counter_enable,
    multiplier_reset,
    multiplier_enable,
    in,
    tc,
    out
);
  parameter input_width = 16, output_width = 38, coeff_size = 64;
  localparam address_size = $clog2(coeff_size);

  input clock, input_reset, input_enable, output_reset, output_enable, counter_reset, counter_enable, multiplier_reset, multiplier_enable;
  input signed [input_width - 1:0] in;
  output tc;
  output signed [output_width - 1:0] out;

  reg [address_size - 1:0] counter_out;
  reg signed [input_width - 1:0] coeff, inner_input;
  reg signed [output_width - 1:0] multiplier_out, inner_output, adder_out, inner_multiplier_out;

  assign out = inner_output;
  Adder adder (
      inner_output,
      inner_multiplier_out,
      adder_out
  );
  Multiplier multiplier (
      inner_input,
      coeff,
      multiplier_out
  );
  Counter #(coeff_size) counter (
      clock,
      counter_enable,
      counter_reset,
      tc,
      counter_out
  );
  ROM #(coeff_size, input_width) coeffs_ROM (
      clock,
      counter_out,
      coeff
  );
  Shift_Register #(input_width, coeff_size) input_shift_register (
      clock,
      input_enable,
      input_reset,
      in,
      counter_out,
      inner_input
  );
  Register #(output_width) multiplier_register (
      clock,
      multiplier_enable,
      multiplier_reset,
      multiplier_out,
      inner_multiplier_out
  );
  Register #(output_width) output_register (
      clock,
      output_enable,
      output_reset,
      adder_out,
      inner_output
  );
endmodule
