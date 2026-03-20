module delay_timer (
    input wire clk,
    input wire rst_n,
    input wire enable,
    output reg tick,
    );

    reg [25:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
        counter <= 26'd0;
        tick <= 1'b0;
        end
        else begin
            if (enable == 0) begin
                counter <= 26'd0;
                tick <= 1'b0;
            end
            else begin
                counter <= counter + 1;
                if (counter == 26'd49999999) begin
                    tick <= 1;
                    counter <= 0;
                end
                    else begin
                    tick <= 0;
                end
            end
        end
    end
endmodule