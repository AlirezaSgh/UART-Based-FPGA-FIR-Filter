module FIR (
    clock,
    reset,
    Input_Valid,
    FIR_Input,
    Output_Valid,
    FIR_Output
);
  parameter input_width = 16, output_width = 38, coeff_size = 64;
  localparam address_size = $clog2(coeff_size);

  input clock, reset, Input_Valid;
  input signed [input_width - 1:0] FIR_Input;
  output Output_Valid;
  output signed [output_width - 1:0] FIR_Output;


  wire signed [input_width - 1:0] coeff;
  wire [address_size - 1:0] counter_out;

  ROMless_FIR #(input_width, output_width, coeff_size) romless_fir (
      clock,
      reset,
      Input_Valid,
      coeff,
      FIR_Input,
      Output_Valid,
      counter_out,
      FIR_Output
  );
  ROM rom (
      clock,
      counter_out,
      coeff
  );
endmodule