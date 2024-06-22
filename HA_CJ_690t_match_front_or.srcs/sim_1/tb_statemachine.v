`timescale 1ns/1ns
module tb_statemachine;

// localparam CLKMGT_HPERIOD = 1000.0 / 135.0 / 2.0;
localparam CLK_HPERIOD = 1000.0 / 100.0 / 2.0;

reg F1_EMCCLK;
reg rstn;
wire pixl_rstn;
initial begin
  F1_EMCCLK = 1'b0;
  rstn = 1'b0;
  #100 rstn = 1'b1;
end
always #CLK_HPERIOD F1_EMCCLK = ~F1_EMCCLK;
wire	sys_clk50m;

clk_wiz_0 clk_wiz_0 (
    .clk_out2   (sys_clk50m   ),
    .clk_out1   (sys_main_clk   ),
    .clk_in1    (F1_EMCCLK      )
);
wire clk10m,clk20m,clk100m,clk200m,pll_locked;
  clk_wiz_1 clk_wiz_1_inst
   (
    // Clock out ports
    .clk_out1(clk10m    ),     // output clk_out1
    .clk_out2(clk20m    ),     // output clk_out2
    .clk_out3(clk100m   ),     // output clk_out3
    .clk_out4(clk200m   ),     // output clk_out4
    // Status and control signals
    .reset(1'b0), // input reset
    .locked(pll_locked),       // output locked
   // Clock in ports
    .clk_in1(sys_clk50m));      // input clk_in1

assign pixl_rstn = rstn;
pixl_top_virtual #(.VA(500)) dut( 
    .rstn       ( pixl_rstn &&    pll_locked ),
    .clk10m     ( clk10m     ),
    .clk20m     ( clk20m     ),
    .clk100m    ( clk100m    ),
    .clk200m    ( clk200m    ),
	.clk125m	(sys_main_clk),

    .fifo_wr_ready      (1'b1),
	.pixl_data_out		(pixl_data_out),
	.pixl_data_out_en	(pixl_data_out_en)
);


endmodule
