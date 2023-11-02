module Register (
    clock,
    enable,
    reset,
    in,
    out
);
  parameter width = 16;
  input clock, enable, reset;
  input signed [width - 1:0] in;
  output reg signed [width -1:0] out;
  initial begin
    out = 0;
  end
  always @(posedge clock) begin
    if (reset) out <= 0;
    else if (enable) out <= in;
  end
endmodule

module Register16_TB;
  reg clock = 0;
  reg enable = 1;
  reg reset = 0;
  reg signed [15:0] in;
  wire signed [15:0] out;

  always #1 clock = !clock;
  Register r (
      clock,
      enable,
      reset,
      in,
      out
  );

  initial begin
    #5 reset = 1;
    #5 reset = 0;
    #5 in = 5;
    #5 in = 17;
    #5 enable = 0;
    #5 in = 10;
    #5 $stop;
  end
endmodule

