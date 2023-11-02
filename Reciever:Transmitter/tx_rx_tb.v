`timescale 1ns/1ns

module tx_rx_tb();
    reg clk = 1'b0, TxD_start = 1'b0, rst = 1'b1;
    reg [7:0] TxD_data = 8'b11010101;
    reg test_in = 1;
    wire TxD, TxD_busy, test_out, RxD_data_ready;
    wire [7:0] RxD_out;
    async_transmitter Tx(clk, rst, TxD_start, TxD_data, TxD, TxD_busy);

    async_receiver Rx(clk, rst, TxD, RxD_data_ready, RxD_out);
    always #1 clk = !clk;
    initial begin
        #20 rst = 1'b0;
        #40 rst = 1'b1;
        #60 TxD_start = 1'b1;
        #20 TxD_start = 1'b0;
        #15000 TxD_data = 8'b10001100;
        #60 TxD_start = 1'b1;
        #20 TxD_start = 1'b0;
        #15000 $stop;
    end
endmodule

module tx_rx_for_sythesis(input clk, rst, TxD_start,input [7:0] data_in, output [7:0] data_out);
    reg test_in = 1;
    wire TxD, TxD_busy, test_out, RxD_data_ready;
    async_transmitter Tx(clk, rst, TxD_start,test_in, data_in, TxD, TxD_busy, test_out);
    async_receiver Rx(clk, rst, TxD, RxD_data_ready, data_out);
endmodule