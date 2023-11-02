module Controller (
    input Input_Valid,
    tc,
    clock,
    reset,
    output reg Output_Valid,
    input_reset,
    input_enable,
    output_reset,
    output_enable,
    counter_reset,
    counter_enable,
    multiplier_reset,
    multiplier_enable
);
  reg [2:0] ps, ns;
  parameter idle = 0, init = 1, shifting = 2, loading = 3, multiplying = 4, adding = 5, finish = 6;
  always @(posedge clock) begin
    if (reset) ps <= idle;
    else ps <= ns;
  end
  always @(ps, Input_Valid, tc, reset) begin
    ns = idle;
    input_reset = 0;
    input_enable = 0;
    output_reset = 0;
    output_enable = 0;
    counter_reset = 0;
    counter_enable = 0;
    multiplier_reset = 0;
    multiplier_enable = 0;
    Output_Valid = 0;
    if (reset) input_reset = 1;
    else
      case (ps)
        idle:
        if (Input_Valid) ns = init;
        else ns = idle;
        init: begin
          ns = shifting;
          output_reset = 1;
          counter_reset = 1;
          multiplier_reset = 1;
          input_enable = 1;
          output_enable = 1;
        end
        shifting: begin
          ns = loading;
        end
        loading: begin
          if (tc) ns = finish;
          else ns = multiplying;
        end
        multiplying: begin
          if (tc) ns = finish;
          else ns = adding;
        end
        adding: begin
          begin
            ns = loading;
            output_enable = 1;
            counter_enable = 1;
            multiplier_enable = 1;
          end
        end
        finish: begin
          ns = idle;
          Output_Valid = 1;
        end
        default: ns = idle;
      endcase
  end
endmodule
