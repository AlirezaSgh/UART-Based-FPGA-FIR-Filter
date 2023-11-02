module mux5to1 (input[2:0] sel, input[7:0] in0,in1,in2,in3,in4,output reg[7:0] out);
    always @(sel, in0,in1,in2,in3,in4) begin
        case (sel)
            3'd0: out = in0;
            3'd1: out = in1;
            3'd2: out = in2;
            3'd3: out = in3;
            3'd4: out = in4;
            // 3'd5: out = in5;
            default: out = in0;
        endcase
    end
endmodule