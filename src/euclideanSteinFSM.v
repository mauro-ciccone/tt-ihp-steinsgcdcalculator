module euclideanSteinFSM (input [3:0] a_in, input [3:0] b_in, input clk, input reset, input start, output reg [3:0] gcd_out, output reg is_done);
    reg [3:0] a_reg, b_reg, divisions;
    reg [1:0] state;

    parameter STATE_LOAD = 2'b00;
    parameter STATE_CALC = 2'b01;
    parameter STATE_DONE = 2'b10;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= STATE_LOAD;
            a_reg <= 4'b0000;
            b_reg <= 4'b0000;
            gcd_out <= 4'b0000;
            is_done <= 1'b0;
            divisions <= 4'b0000;
        end
        else begin
            case (state)
                STATE_LOAD : begin
                    a_reg <= a_in;
                    b_reg <= b_in;
                    is_done <= 1'b0;
                    divisions <= 4'b0000;
                    if (start) begin
                        state <= STATE_CALC;
                    end
                end

                STATE_CALC : begin
                    is_done <= 1'b0;
                    if (b_reg == 0 || a_reg == b_reg) begin
                        state <= STATE_DONE;
                    end
                    else if (a_reg == 0) begin
                        a_reg <= b_reg;
                        state <= STATE_DONE;
                    end
                    else if (a_reg[0] == 0 && b_reg[0] == 0) begin
                        a_reg <= a_reg >> 1;
                        b_reg <= b_reg >> 1;
                        divisions <= divisions + 1;
                    end
                    else if (a_reg[0] == 0 && b_reg[0] == 1) begin
                        a_reg <= a_reg >> 1;
                    end
                    else if (a_reg[0] == 1 && b_reg[0] == 0) begin
                        b_reg <= b_reg >> 1;
                    end
                    else begin
                        if (a_reg > b_reg) begin
                            a_reg <= (a_reg - b_reg) >> 1;
                        end
                        else begin
                            b_reg <= (b_reg - a_reg) >> 1;
                        end
                    end
                end

                STATE_DONE : begin
                    gcd_out <= a_reg << divisions;
                    is_done <= 1'b1;
                    if (!start) begin
                        state <= STATE_LOAD;
                    end
                end

                default: state <= STATE_LOAD;
            endcase
        end
        
    end
    
endmodule