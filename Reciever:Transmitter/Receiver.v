module receiver_dp(input clk, rst,RX, cnt_en, shreg_en, cnt_rst, output [7:0] out, output counter_done);
    wire counter_enable, sampler_out, sampling_done, write_reg, counter_rst;
    assign counter_rst = cnt_rst & rst;
    assign counter_enable = sampling_done & cnt_en;
    assign write_reg = shreg_en & sampling_done;
    sampler sampling_unit(clk, rst, baud, RX, sampler_out, sampling_done);
    BaudTickGen #(.Oversampling(4)) gen (clk, rst, 1'b1, baud);
    shreg #8 shru(clk, rst, write_reg, sampler_out, out);
    counter #3 count_unit(clk, counter_rst, counter_enable, counter_done);
endmodule

module receiver_sm(input clk, rst, RX, counter_done, output reg cnt_en, shreg_en, done, cnt_rst);
    parameter[1:0] Idle = 2'd0, Get_data = 2'd1, Fin = 2'd2;
    reg[1:0] nstate, pstate;
    always @(RX,counter_done, pstate) begin
        cnt_en <= 0;
        done <= 0;
        shreg_en <= 0;
        cnt_rst <=1;
        nstate <= Idle;
        case (pstate)
            Idle: begin nstate <= RX ? Idle : Get_data;
                cnt_rst <= 0;
            end
            Get_data: begin
                nstate <= counter_done ? Fin : Get_data;
                cnt_en <= 1;
                shreg_en <= 1;
            end 
            Fin: begin
                nstate <= RX ? Idle : Fin;
                done <= 1;
            end
        endcase
    end
    always @(posedge clk) begin
        if(~rst)
            pstate <= Idle;
        else
            pstate <= nstate;
    end
endmodule

module async_receiver(
    input clk,
    input rst,
    input RxD,
    output RxD_data_ready ,
    output [7:0] RxD_data  // data received, valid only (for one clock cycle) when RxD_data_ready is asserted
);
    wire cnt_en, cnt_done, shreg_en, cnt_rst;
    receiver_dp dp(clk, rst, RxD, cnt_en, shreg_en,cnt_rst, RxD_data, cnt_done);
    receiver_sm sm(clk, rst, RxD, cnt_done, cnt_en, shreg_en, RxD_data_ready, cnt_rst);
endmodule