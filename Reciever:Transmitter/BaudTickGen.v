module BaudTickGen 
    #(  parameter ClkFrequency = 50000000,
        parameter Baud = 115200,
        parameter Oversampling = 1)
    (clk, rst, enable, tick);
    input clk, rst, enable;
    output reg tick;
    parameter counter_max = ClkFrequency/(Baud * Oversampling);
    reg [$clog2(counter_max)-1:0] count;
    always @(posedge clk) begin
        if (~rst || tick)
            count = 0;
        else if(enable)
            count = count + 1;
    end
    always @(count) begin
	tick = 0;

	if(count == counter_max && enable) begin
            tick = 1;
        end
    end

endmodule