module wrapper_w_fir(input clk, rst, RxD, output TxD);
    wire TxD_start, TxD_busy, RxD_data_ready, TxD_busy, output_valid, input_valid;
    wire inv_rst;
    wire [37:0] fir_data_out;
    wire [15:0] fir_data_in;
    assign inv_rst = ~rst;
    wire [7:0] TxD_data, RxD_data;
    uart rxtx(clk, rst, RxD, TxD_start, RxD_data_ready, TxD_data, RxD_data, TxD, TxD_busy);
    // place FIR here, note: use inv_rst for reset wire
    wrapper fir_wrapper(clk, inv_rst, RxD_data_ready, output_valid, TxD_busy, RxD_data,fir_data_out,
                        input_valid, TxD_start, TxD_data, fir_data_in);

endmodule

//note that fir has active high rst but uart's rst is active low, inverse fir's rst or use normal rst for wrapper and inverse uart's reset before connecting.
module wrapper_wo_fir(input clk, rst, RxD,output_valid, input [37:0] fir_data_out, output TxD, input_valid, output[15:0] fir_data_in);
    wire TxD_start, TxD_busy, RxD_data_ready, TxD_busy;
    wire inv_rst;
    assign inv_rst = ~rst;
    wire [7:0] TxD_data, RxD_data;
    uart rxtx(clk, rst, RxD, TxD_start, RxD_data_ready, TxD_data, RxD_data, TxD, TxD_busy);
    wrapper fir_wrapper(clk, inv_rst, RxD_data_ready, output_valid, TxD_busy, RxD_data,fir_data_out,
                        input_valid, TxD_start, TxD_data, fir_data_in);

endmodule