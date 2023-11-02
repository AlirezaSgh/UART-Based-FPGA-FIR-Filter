`timescale 1ns/1ns
module wrapper_dp(  input clk, rst, rx_done, out_reg_en, input[2:0] out_mux_sel, input[7:0] rx_data, input[37:0] fir_data_out,
                    output[7:0] tx_data, output[15:0] fir_data_in);
    wire [7:0] reg_interconnect;
    wire [37:0] out_reg_out;
    nbit_reg #8 MSB_reg(clk, rst, rx_done, fir_data_in[7:0],fir_data_in[15:8]),
                LSB_reg(clk, rst, rx_done, rx_data, fir_data_in[7:0]);
    nbit_reg #38 out_reg(clk, rst, out_reg_en, fir_data_out, out_reg_out);
    mux5to1 out_mux(out_mux_sel, 
                    {out_reg_out[37],out_reg_out[37],out_reg_out[37:32]}, 
                    out_reg_out[31:24], 
                    out_reg_out[23:16], 
                    out_reg_out[15:8], 
                    out_reg_out[7:0], 
                    tx_data);


endmodule

module wrapper_sm(  input clk, rst, rx_done, output_valid, txd_busy, 
                    output reg input_valid, out_reg_en, txd_start, output reg[2:0] out_mux_sel);
    parameter [2:0] Idle = 3'd0, Save_Rx_Data1 = 3'd1,Rx_Data2 = 3'd2, Save_Rx_Data2 = 3'd3 ,
                    Start_FIR = 3'd4, Wait_for_FIR = 3'd5, Transmit = 3'd6, Wait_for_transmission = 3'd7;
    reg [2:0] pstate, nstate;
    reg cen, cout;

    always @(posedge clk) begin
        
        if(rst)
            out_mux_sel <= 3'b0;
        if(cen) begin
            cout <= 1'b0;
            out_mux_sel <= out_mux_sel + 3'd1;
        end
        if(out_mux_sel == 3'd5) begin
            out_mux_sel <= 3'd0;
            cout <= 1'b1;
        end
    end

    always @(pstate, rx_done, output_valid, txd_busy, out_mux_sel, cout) begin
        nstate <= Idle;
        input_valid <= 1'b0;
        out_reg_en <= 1'b0;
        cen <= 1'b0;
        txd_start <= 1'b0;
        case (pstate)
            Idle: nstate <= rx_done ? Save_Rx_Data1 : Idle;
            Save_Rx_Data1: nstate <= ~rx_done ? Rx_Data2 : Save_Rx_Data1;
            Rx_Data2: nstate <= rx_done ? Save_Rx_Data2 : Rx_Data2;
            Save_Rx_Data2: nstate <= ~rx_done ? Start_FIR : Save_Rx_Data2;
            Start_FIR: begin 
                nstate <= Wait_for_FIR;
                input_valid <= 1'b1;
            end
            Wait_for_FIR: begin
                nstate <= output_valid ? Transmit : Wait_for_FIR;
                out_reg_en <= 1'b1;
            end
            Transmit: begin
                cen <= 1'b1;
                txd_start <= 1'b1;
                nstate <= Wait_for_transmission;

            end
            Wait_for_transmission: begin
                if (txd_busy) begin
                    nstate <= Wait_for_transmission;
                end
                else begin
                    if(cout)
                        nstate <= Idle;
                    else
                        nstate <= Transmit;
                end
            end
            default: nstate <= Idle; 
        endcase
    end
    always @(posedge clk) begin
        if(rst) pstate <= Idle;
        else pstate <= nstate;
    end
    
endmodule

module wrapper(input clk, rst, rx_done, output_valid, txd_busy, input[7:0] rx_data, input[37:0] fir_data_out,
                output input_valid, txd_start, output[7:0] tx_data, output[15:0] fir_data_in);
    wire [2:0] out_mux_sel;
    wire out_reg_en;
    wrapper_dp datapath(    clk, rst, rx_done, out_reg_en, out_mux_sel, rx_data, fir_data_out,
                            tx_data, fir_data_in);
    wrapper_sm statemachine(clk, rst, rx_done, output_valid, txd_busy, 
                            input_valid, out_reg_en, txd_start, out_mux_sel);
endmodule