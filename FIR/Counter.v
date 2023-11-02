// we have 64 coeffs
module Counter (
    clock,
    enable,
    reset,
    tc,
    out
);
  parameter coeff_size = 64;
  localparam address_size = $clog2(coeff_size);

  input clock, enable, reset;
  output reg tc;
  output reg [address_size - 1:0] out;

  always @(posedge clock) begin
    tc = 0;
    if (reset) out <= 0;
    else if (enable) begin
      out <= out + 1;
      if (out == coeff_size - 1) tc = 1;
    end
  end
endmodule

module Counter_TB;
  reg clock = 0;
  reg enable = 0;
  reg reset = 0;
  wire tc;
  wire [5:0] out;
  Counter c (
      clock,
      enable,
      reset,
      tc,
      out
  );

  always #1 clock = !clock;
  initial begin
    #5 reset = 1;
    #5 reset = 0;
    #5 enable = 1;
    #300 $stop;
  end
endmodule
