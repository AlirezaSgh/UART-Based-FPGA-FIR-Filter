module uart(input clk, rst, RxD, TxD_start, 
            input[7:0] TxD_data,
            output [7:0] RxD_data,
            output TxD, TxD_busy, RxD_data_ready);
async_transmitter Tx(
    clk,
    rst,
    TxD_start,
    TxD_data,
    TxD,
    TxD_busy
);
async_receiver Rx(
    clk,
    rst,
    RxD,
    RxD_data_ready,
    RxD_data  // data received, valid only (for one clock cycle) when RxD_data_ready is asserted
);
endmodule