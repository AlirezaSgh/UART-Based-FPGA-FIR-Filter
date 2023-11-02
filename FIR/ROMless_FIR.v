module ROMless_FIR (
    clock,
    reset,
    Input_Valid,
    coeff,
    FIR_Input,
    Output_Valid,
    counter_out,
    FIR_Output
);
  parameter input_width = 16, output_width = 38, coeff_size = 64;
  localparam address_size = $clog2(coeff_size);
  input clock, reset, Input_Valid;
  input signed [input_width - 1:0] coeff;
  input signed [input_width - 1:0] FIR_Input;
  output Output_Valid;
  output [5:0] counter_out;
  output signed [output_width - 1:0] FIR_Output;


  wire
      input_reset,
      input_enable,
      output_reset,
      output_enable,
      counter_reset,
      counter_enable,
      multiplier_reset,
      multiplier_enable,
      tc;
  Controller controller (
      Input_Valid,
      tc,
      clock,
      reset,
      Output_Valid,
      input_reset,
      input_enable,
      output_reset,
      output_enable,
      counter_reset,
      counter_enable,
      multiplier_reset,
      multiplier_enable
  );
  ROMless_Datapath #(input_width, output_width, coeff_size) datapath (
      clock,
      input_reset,
      input_enable,
      output_reset,
      output_enable,
      counter_reset,
      counter_enable,
      multiplier_reset,
      multiplier_enable,
      coeff,
      FIR_Input,
      tc,
      counter_out,
      FIR_Output
  );
endmodule
