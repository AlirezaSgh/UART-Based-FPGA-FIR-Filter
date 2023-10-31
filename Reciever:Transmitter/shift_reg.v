module register
    (input clk, rst, en, in , output reg out);
    always@(posedge clk) begin
        if(rst)
            out <= 0;
        else if(en)
            out <= in;
    end
endmodule

module nbit_reg #(parameter WIDTH = 8)(input clk, rst, en, input[WIDTH-1:0] in, output reg[WIDTH-1:0] out);
    always @(posedge clk) begin
        if(rst)
            out <=0;
            else if(en)
            out <=in;
    end
endmodule

module shreg #(parameter SIZE = 8)(input clk, rst, en, in, output[SIZE-1:0] out);
    genvar i;
    wire [SIZE:0] reg_out;
    wire rst_al;
    assign rst_al = ~rst;
    generate
        for(i = 0; i < SIZE; i= i + 1) begin : sampler_regs
            register RXX (.clk(clk), .rst(rst_al), .en(en), .in(reg_out[i+1]), .out(reg_out[i]));
        end
    endgenerate
    assign out = reg_out[SIZE:1];
    assign reg_out[SIZE] = in;
endmodule

module shreg_tb();
    reg clk = 0, rst = 1, en = 1, in;
    wire [4:0]out;
    shreg #5 ut(clk, rst, en, in, out);
    always #2 clk = ~clk;
    initial begin
        #10 rst = 0;
        in = $random;
        repeat(10) #5 in = $random;
        en = 0;
        repeat(5) #5 in = $random;
        #50 $stop;
    end
endmodule
