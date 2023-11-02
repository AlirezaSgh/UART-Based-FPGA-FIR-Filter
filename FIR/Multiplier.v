module Multiplier(input signed [15:0] in1, in2, output signed [37:0] out);
assign out = in1 * in2;
endmodule

module Multiplier_TB;
reg signed [15:0] in1;
reg signed [15:0] in2;
wire signed [37:0] out;

Multiplier m(in1, in2, out);

initial begin
    # 5 in1=5; in2=2;
    # 5 in1=10; in2=13;
    # 5 $stop;
end
endmodule
			