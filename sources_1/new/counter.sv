`timescale 1ns / 1ps

module counter #(parameter N = 8, parameter MAX = 2^N - 1)(
        input wire logic clk, rst, en,
        output     logic [N-1:0] count,
        output     logic end_count            
    );
    
    always_ff @( posedge clk ) begin : Increment_Count
        if (~rst && en) begin
            if(count[N-1:0] == MAX-1) begin
                count[N-1:0] <= '0;
            end
            else begin
                count[N-1:0] <= count[N-1:0] + 1;
            end
        end
        else if (rst) begin
            count[N-1:0] <= '0;
        end
    end
    assign end_count = count[N-1:0] == MAX-1;               //high for 1 cycle when count reaches MAX-1
endmodule
