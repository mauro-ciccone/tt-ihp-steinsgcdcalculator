module bin_to_bcd (
    input  wire [7:0]  bin,
    output reg  [11:0] bcd // 12 bits total: [11:8] Hundreds, [7:4] Tens, [3:0] Units
);

    integer i;

    always @(*) begin
        // Initialize BCD to zero before we start shifting
        bcd = 12'd0;
        
        // Shift 8 times (once for each bit in the input binary number)
        for (i = 7; i >= 0; i = i - 1) begin
            
            // If any BCD digit is >= 5, add 3
            if (bcd[3:0] >= 5) 
                bcd[3:0] = bcd[3:0] + 3;
                
            if (bcd[7:4] >= 5) 
                bcd[7:4] = bcd[7:4] + 3;
                
            if (bcd[11:8] >= 5) 
                bcd[11:8] = bcd[11:8] + 3;
                
            // Shift the entire BCD register left by 1, and pull in the next binary bit
            bcd = {bcd[10:0], bin[i]};
        end
    end

endmodule