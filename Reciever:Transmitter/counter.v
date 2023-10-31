`timescale 1ns/1ns
module counter
    #(parameter WIDTH = 3)
    (input clk, rst, en, output reg done);
    reg [WIDTH-1:0] count;
    always @(posedge clk)begin
        if(~rst) begin
            count <= 0;
            done <= 0;
        end
        else if(en) 
            {done, count} <= count + 1;
    end 
endmodule

module counter_tb();
    reg clk = 0, rst = 1, en = 0;
    wire done;
    counter #5 ut(clk, rst, en, done);
    always #2 clk = ~clk;
    initial begin
        #10 rst = 0;
        en = 1;
        #1000 en = 0;
        #50 $stop;
    end
endmodule