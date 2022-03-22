`timescale 1ns / 1ps

module top(
    input  wire logic clk, btn_rst,                         //clk is 100MHz on Arty A7, btn_rst is active low
    output      logic vga_h_sync,    
    output      logic vga_v_sync,    
    output      logic [3:0] vga_r,  
    output      logic [3:0] vga_g,  
    output      logic [3:0] vga_b   
    );
    
    logic [9:0] pos_x, pos_y;
    logic rgb_en, clk_pix, h_sync, v_sync;

    //Initialize display module
    display_480p display_inst (.clk, .rst(!btn_rst), .h_sync, .v_sync, .pos_x, .pos_y, .rgb_en, .clk_pix);

    always_ff @( posedge clk_pix ) begin : RGB_Handling
        vga_h_sync <= h_sync;
        vga_v_sync <= v_sync;

        if(rgb_en) begin                                    //if rgb_en, then output is white
            vga_r[3:0] <= 4'hF;
            vga_g[3:0] <= 4'hF;
            vga_b[3:0] <= 4'hF;
        end
        else begin                                          //if !rgb_en, then RGB pins need to be set to 0
            vga_r[3:0] <= 4'h0;
            vga_g[3:0] <= 4'h0;
            vga_b[3:0] <= 4'h0;
        end
    end
endmodule
