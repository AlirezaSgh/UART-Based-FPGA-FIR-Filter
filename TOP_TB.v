`timescale 1ns/1ns

module TOP_TB;

//input
reg clk=1'b0, rst=1'b0;
reg TxD_start = 0;

wire output_valid;
wire [37:0] fir_data_out;

//output
wire TxD, RxD;

wire input_valid;
wire [15:0] fir_data_in;


wrapper_wo_fir wwof(clk, rst, RxD, output_valid, fir_data_out,
                    TxD, input_valid, fir_data_in);
FIR fir(
    clk,
    rst,
    input_valid,
    fir_data_in,
    output_valid,
    fir_data_out
);

    wire inv_rst;
    assign inv_rst = ~rst;
    wire [7:0] RxD_data;
    reg [7:0] TxD_data;
    wire RxD_done, TxD_busy;
    uart rxtx(  clk, inv_rst, TxD, TxD_start,
                TxD_data, RxD_data, RxD, TxD_busy, RxD_done);

    always #1 clk = !clk;
    initial begin
        #20 rst = 1'b1;
        #40 rst = 1'b0;
        #60 TxD_data=8'b10010001;
        TxD_start = 1;
        #20 TxD_start = 0;
        #10000
        TxD_data=8'b11100010;
        TxD_start = 1;
        #20 TxD_start = 0;
        #50000 $stop;
    end

endmodule