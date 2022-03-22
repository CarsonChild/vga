`timescale 1ns / 1ps

module clock_divider #(parameter N = 2)(
        input wire logic clk_in, rst,
        output     logic clk_out
    );

    logic [N-1:0] count;

    always_ff @( posedge clk_in ) begin : Increment_Count
        if(~rst) count[N-1:0] <= count[N-1:0] + 1;          //increment count every clock cycle
        else count[N-1:0] <= '0;                            //reset count when rst is high
    end

    assign clk_out = count[N-1];                            //clk_out equals the last bit

endmodule
