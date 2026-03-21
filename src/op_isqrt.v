module op_isqrt (
    input [6:0] a_in, 
    input [6:0] b_in, 
    input clk, 
    input rst_n, 
    input start, 
    output reg [7:0] result, 
    output reg done
    );

    reg [7:0] current_val;
    reg [7:0] root_counter;
    reg [1:0] state;

    wire [7:0] current_odd = {root_counter[6:0], 1'b1};

    localparam STATE_LOAD = 2'd0;
    localparam STATE_CALC = 2'd1;
    localparam STATE_DONE = 2'd2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 8'd0;
            done <= 1'b0;
            current_val <= 8'd0;
            root_counter <= 8'd0;
            state <= STATE_LOAD;
        end
        else begin
            case (state)
                STATE_LOAD : begin
                    done <= 1'b0;
                    if (start == 1'b1) begin
                        current_val <= {1'b0, a_in} + {1'b0, b_in};
                        root_counter <= 8'd0;
                        state <= STATE_CALC;
                    end
                end

                STATE_CALC : begin
                    if (current_val >= current_odd) begin
                        current_val <= current_val - current_odd;
                        root_counter <= root_counter + 8'd1;
                    end
                    else begin
                        result <= root_counter;
                        state <= STATE_DONE;
                    end
                end

                STATE_DONE : begin
                    done <= 1'b1;
                    if (start == 1'b0) begin
                        state <= STATE_LOAD;
                    end
                end

                default: state <= STATE_LOAD;
            endcase
        end
    end
    
endmodule