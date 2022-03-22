// Project F: FPGA Graphics - Simple 640x480p60 Display Test Bench (XC7)
// (C)2022 Will Green, open source hardware released under the MIT License
// Learn more at https://projectf.io/posts/fpga-graphics/

`default_nettype none
`timescale 1ns / 1ps

module test();

    parameter CLK_PERIOD = 10;  // 10 ns == 100 MHz
    parameter CORDW = 10;  // screen coordinate width in bits
    //Horizontal timing parameters
    localparam H_SYNC_TIME = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_FRONT_PORCH = 16;
    localparam H_ADDR_VIDEO_TIME = 640;
    localparam H_TOTAL = H_SYNC_TIME + H_BACK_PORCH + H_FRONT_PORCH + H_ADDR_VIDEO_TIME;

    logic clk;
    logic rst;
    // generate pixel clock
    logic rgb_en, clk_pix, v_sync, h_sync;
    display_480p display_inst (.clk, .h_sync, .rst, .v_sync, .rgb_en, .clk_pix);
   
    logic [3:0] vga_r;
    logic [3:0] vga_g;
    logic [3:0] vga_b;
    assign vga_g[3:0] = 4'h0;
    assign vga_b[3:0] = 4'h0;

    always_ff @( posedge clk_pix ) begin : RGB_Handling
        if(rgb_en) vga_r[3:0] <= 4'hF;
        else vga_r[3:0] <=  4'h0;
    end
    //Clock test
    // logic clk_pix;
    // clock_divider clk_div_inst (.clk_in(clk), .clk_out(clk_pix)); //instantiate a clock divider to get a 25MHz clock on clk_pix
    // logic increment_y;
    // logic [9:0] pos_x;
    // //Counter test
    // counter #(.N($clog2(H_TOTAL)), .MAX(H_TOTAL)) h_counter (.clk, .rst(0), .en(1), .count(pos_x), .end_count(increment_y));
    

    // generate clock
    always #(CLK_PERIOD / 2) clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #100
        rst = 0;
        #1000_000_000 $finish;  // 18 ms (one frame is 16.7 ms)
    end
endmodule