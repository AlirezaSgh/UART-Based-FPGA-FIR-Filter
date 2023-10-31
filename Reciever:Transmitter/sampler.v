`timescale 1ns/1ns
module sampler
    #(parameter Oversampling = 4)
    (input clk, rst, baud, in, output out, output reg sampling_done);
    wire [Oversampling:0] reg_out;
    reg[$clog2(Oversampling):0] sample_count;

    wire rst_al;
    assign rst_al = ~rst;
    genvar i;
    generate
        for(i = 0; i < Oversampling; i= i + 1) begin : sampler_regs
            register RXX (.clk(clk), .rst(rst_al), .en(baud), .in(reg_out[i]), .out(reg_out[i+1]));
        end
    endgenerate

    assign reg_out[0] = in;
    assign out = reg_out[Oversampling/2 - 1];

    always @(posedge clk) begin
        if(rst_al)
            sample_count = 0;
        else if(baud)
            sample_count = sample_count + 1;
        
        if(sample_count == Oversampling) begin
            sample_count = 0;
            sampling_done = 1;
        end
        else
            sampling_done = 0;
    end
endmodule

module sampler_tb();
    reg clk = 0, rst = 0, in;
    wire baud, out, sampling_done;

    sampler ut(clk, rst, baud, in, out, sampling_done);
    BaudTickGen #(.Oversampling(4)) gen (clk, rst, 1'b1, baud);

    always #2 clk = ~clk;

    initial begin
        #20 rst = 1;
        repeat(100) #27 in = $random;
        #20 $stop; 
    end

endmodule
