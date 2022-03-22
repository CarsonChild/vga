`timescale 1ns / 1ps

module display_480p(
        input wire logic clk, rst,
        output     logic h_sync, v_sync, rgb_en,
        output     logic [H_N_BITS-1:0] pos_x,
        output     logic [V_N_BITS-1:0] pos_y,
        output     logic clk_pix
    );

    //Horizontal timing parameters
    localparam H_SYNC_TIME = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_FRONT_PORCH = 16;
    localparam H_ADDR_VIDEO_TIME = 640;
    localparam H_TOTAL = H_SYNC_TIME + H_BACK_PORCH + H_FRONT_PORCH + H_ADDR_VIDEO_TIME;
    localparam H_N_BITS = $clog2(H_TOTAL);

    //Vertical timing parameters
    localparam V_SYNC_TIME = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_FRONT_PORCH = 10;
    localparam V_ADDR_VIDEO_TIME = 480;
    localparam V_TOTAL = V_SYNC_TIME + V_BACK_PORCH + V_FRONT_PORCH + V_ADDR_VIDEO_TIME;
    localparam V_N_BITS = $clog2(V_TOTAL);

    //Clock divider
    clock_divider clk_div_inst (.clk_in(clk), .rst, .clk_out(clk_pix)); //instantiate a clock divider to get a 25MHz clock on clk_pix
    
    logic increment_y;

    //H and V counters
    counter #(.N(H_N_BITS), .MAX(H_TOTAL)) h_counter (.clk(clk_pix), .rst, .en(1), .count(pos_x), .end_count(increment_y));
    counter #(.N(V_N_BITS), .MAX(V_TOTAL)) v_counter (.clk(clk_pix), .rst, .en(increment_y), .count(pos_y), .end_count());
    
    //Handle h_sync
    always_ff @( posedge clk_pix ) begin : H_Sync_Logic
        if(pos_x < H_SYNC_TIME) h_sync <= 0;
        else h_sync <= 1;
    end

    //Handle v_sync
    always_ff @( posedge clk_pix ) begin : V_Sync_Logic
        if(pos_y < V_SYNC_TIME) v_sync <= 0;
        else v_sync <= 1;
    end

    //Handle rgb_en
    always_ff @( posedge clk_pix ) begin : RGB_Enable_Logic
        if(pos_x >= H_SYNC_TIME + H_BACK_PORCH && pos_x < H_TOTAL - H_FRONT_PORCH) begin
            if (pos_y >= V_SYNC_TIME + V_BACK_PORCH && pos_y < V_TOTAL - V_FRONT_PORCH) begin
                rgb_en <= 1;
            end
        end
        else rgb_en <= 0;
    end

endmodule
