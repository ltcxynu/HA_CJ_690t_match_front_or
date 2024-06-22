`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/19 10:13:48
// Design Name: 
// Module Name: SF51_JR6101_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 100000 - File Created
// Revision 100100 - 增加四路光纤回环测试模块
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SF51_JR6101_top(

	// input clk //50m
	// ,input rstn
//lvds
	input	[20:0]	lvds_p1
	,input	[20:0]	lvds_n1
	,input			clk_p11
	,input			clk_n11
	// ,input			clk_p12
	// ,input			clk_n12
	// ,input			frame_p11
	// ,input			frame_n11
	// ,input			frame_p12
	// ,input			frame_n12

	,input	[20:0]	lvds_p2
	,input	[20:0]	lvds_n2
	,input			clk_p21
	,input			clk_n21
	// ,input			clk_p22
	// ,input			clk_n22
	// ,input			frame_p21
	// ,input			frame_n21
	// ,input			frame_p22
	// ,input			frame_n22

	,input	[20:0]	lvds_p3
	,input	[20:0]	lvds_n3
	,input			clk_p31
	,input			clk_n31
	// ,input			clk_p32
	// ,input			clk_n32
	// ,input			frame_p31
	// ,input			frame_n31
	// ,input			frame_p32
	// ,input			frame_n32

	,input	[20:0]	lvds_p4
	,input	[20:0]	lvds_n4
	,input			clk_p41
	,input			clk_n41
	// ,input			clk_p42
	// ,input			clk_n42
	// ,input			frame_p41
	// ,input			frame_n41
	// ,input			frame_p42
	// ,input			frame_n42


//spi
	,output PDLU_EN
	,output PDLU_pixel_RSTN
	,output PDLU_RSTN
	,output PDRU_Mclk_20M

    ,output    wire          clk_spi // spi内部时钟
    ,output    wire          mosi
    // ,input    wire          miso
	,output wire 			cs1
	,output wire 			cs2
	,output wire 			cs3
	,output wire 			cs4

//status
	,output 			led
//------------------------------------------------------
//qsfp
//    ,input               MGT117_P        
//    ,input               MGT117_N        
//    ,output [2 : 0]      QSFP1_TX_P      
//    ,output [2 : 0]      QSFP1_TX_N      
//    ,input  [2 : 0]      QSFP1_RX_P      
//    ,input  [2 : 0]      QSFP1_RX_N          

//    ,output [2 : 0]      QSFP2_TX_P      
//    ,output [2 : 0]      QSFP2_TX_N      
//    ,input  [2 : 0]      QSFP2_RX_P      
//    ,input  [2 : 0]      QSFP2_RX_N      


    
    ,input               F1_EMCCLK

    );



	wire 				test_mode				;
	wire 				soft_reset				;
    wire                sys_main_clk            ;
    wire                GT_125M_BUFG            ;
    wire                gt_125M_clk             ;
    wire                user_clk_i              ;

    wire [255:0]        probe0                  ;
    
    wire                channel_up_aurora       ;
    wire [2 : 0]        lane_up_aurora          ;
    wire                AXIS_tx_ready           ;
    wire                AXIS_tx_valid           ;
    wire [1919:0]       AXIS_tx_data            ;
    
    wire                AXIS_tx192_ready        ;
    wire                AXIS_tx192_valid        ;
    wire [191:0]        AXIS_tx192_data         ;

    wire                aurora_tx_ready         ;
    wire                aurora_tx_valid         ;
    wire [191:0]        aurora_tx_data          ;
    wire [255:0]        aurora_rx_data          ;
    wire                aurora_rx_valid         ;
    wire                test_valid              ;
    wire [511:0]        test_data               ;
	wire                buf_test_valid              ;
    wire [1919:0]        buf_test_data               ;
    wire [15: 0]        i_delay_param           ;

    wire                gt_rx_afifo_empty;
    wire                gt_rx_afifo_full;
    wire                gt_tx_sfifo_full;
    wire                gt_tx_sfifo_empty;

    wire rst_vio;
//    IBUFDS_GTE2 IBUFGDS_GTclk_gt (
//        .CEB                (1'b0               ),
//        .I                  (MGT117_P           ),
//        .IB                 (MGT117_N           ),
//        .ODIV2              (),
//        .O                  (gt_125M_clk        )
//    );


wire	sys_clk50m;

    clk_wiz_0 clk_wiz_0 (
        .clk_out2   (sys_clk50m   ),
        .clk_out1   (sys_main_clk   ),
        .clk_in1    (F1_EMCCLK      )
    );

    assign GT_125M_BUFG             = sys_main_clk ;
	   //------------------------------相机-----------------------------------

	//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// clk_out1____10.000______0.000______50.0______285.743____164.985
// clk_out2____20.000______0.000______50.0______192.113____164.985
// clk_out3___100.000______0.000______50.0______162.035____164.985
// clk_out4___200.000______0.000______50.0______142.107____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary______________50____________0.010

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
wire clk5m     ;
wire clk10m    ;
wire clk20m    ;
wire clk100m   ;
wire clk200m   ;
wire pll_locked;
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


reg [23:0] led_cnt;
always @ (posedge clk20m)
	led_cnt	<= led_cnt + 1;
assign led = led_cnt[23];
//*************************************************************
wire pixl_rstn;
reg [25:0] pixl_rstn_cnt;
always @ (posedge clk20m)
if(~pll_locked)
	pixl_rstn_cnt	<= 0;
else if(&pixl_rstn_cnt)
	pixl_rstn_cnt	<= pixl_rstn_cnt;
else
	pixl_rstn_cnt	<= pixl_rstn_cnt + 1;

//  clk_wiz_2 clk_wiz_2_inst
//   (
//    // Clock out ports
//    .clk_out1(clk5m),     // output clk_out1
//   // Clock in ports
//    .clk_in1(clk10m)); 

assign PDLU_EN	= (pixl_rstn_cnt	<	20) ?	1'b0	:	1'b1;
assign PDLU_RSTN	=(pixl_rstn_cnt	<	20) ?	1'b0	:	1'b1;
assign PDLU_pixel_RSTN	=(pixl_rstn_cnt	<	2000) ?	1'b0	:	1'b1;
assign PDRU_Mclk_20M	=clk10m;

assign pixl_rstn	= (pixl_rstn_cnt	<	20000) ?	1'b0	:	1'b1;


// assign PDRU_Mclk_20M	=(pixl_rstn_cnt	<	220100) ?	1'b0	:	clk20m;

// assign PDLU_EN	= 1'b1;
// assign PDLU_RSTN	=rstn;
// assign PDLU_pixel_RSTN	=rstn;
// assign PDRU_Mclk_20M	=clk20m;
//************************************************************

wire [1919:0] pixl_data_out;
wire 		pixl_data_out_en;
wire        AXIS_rx_ready;
pixl_top #(.VA(500)) u_pixl_top( 
    .rstn       ( pixl_rstn &&    pll_locked ),
    .clk10m     ( clk10m     ),
    .clk20m     ( clk20m     ),
    .clk100m    ( clk100m    ),
    .clk200m    ( clk200m    ),
	.clk125m	(GT_125M_BUFG),
    .lvds_p1    ( lvds_p1    ),
    .lvds_n1    ( lvds_n1    ),
    .clk_p11    ( clk_p11    ),
    .clk_n11    ( clk_n11    ),
    // .clk_p12    ( clk_p12    ),
    // .clk_n12    ( clk_n12    ),
    // .frame_p11  ( frame_p11  ),
    // .frame_n11  ( frame_n11  ),
    // .frame_p12  ( frame_p12  ),
    // .frame_n12  ( frame_n12  ),
    .lvds_p2    ( lvds_p2    ),
    .lvds_n2    ( lvds_n2    ),
    .clk_p21    ( clk_p21    ),
    .clk_n21    ( clk_n21    ),
    // .clk_p22    ( clk_p22    ),
    // .clk_n22    ( clk_n22    ),
    // .frame_p21  ( frame_p21  ),
    // .frame_n21  ( frame_n21  ),
    // .frame_p22  ( frame_p22  ),
    // .frame_n22  ( frame_n22  ),
    .lvds_p3    ( lvds_p3    ),
    .lvds_n3    ( lvds_n3    ),
    .clk_p31    ( clk_p31    ),
    .clk_n31    ( clk_n31    ),
    // .clk_p32    ( clk_p32    ),
    // .clk_n32    ( clk_n32    ),
    // .frame_p31  ( frame_p31  ),
    // .frame_n31  ( frame_n31  ),
    // .frame_p32  ( frame_p32  ),
    // .frame_n32  ( frame_n32  ),
    .lvds_p4    ( lvds_p4    ),
    .lvds_n4    ( lvds_n4    ),
    .clk_p41    ( clk_p41    ),
    .clk_n41    ( clk_n41    ),
    // .clk_p42    ( clk_p42    ),
    // .clk_n42    ( clk_n42    ),
    // .frame_p41  ( frame_p41  ),
    // .frame_n41  ( frame_n41  ),
    // .frame_p42  ( frame_p42  ),
    // .frame_n42  ( frame_n42  ),
    .fifo_wr_ready      (1'b1),
	.pixl_data_out		(pixl_data_out),
	.pixl_data_out_en	(pixl_data_out_en),

    .clk_spi    ( clk_spi    ),
    .mosi       ( mosi       ),
    .miso       (        ),
    .cs1        ( cs1        ),
    .cs2        ( cs2        ),
    .cs3        ( cs3        ),
    .cs4        ( cs4        )
);




    //------------------------------gt-----------------------------------
    //------------------------------gt-----------------------------------
//    aurora_64b66b_0_support aurora_64b66b_0_block_i (
//        // TX AXI4-S Interface
//        .s_axi_tx_tdata         (aurora_tx_data     ),
//        .s_axi_tx_tvalid        (!gt_tx_sfifo_empty ),
//        .s_axi_tx_tready        (aurora_tx_ready    ),
//        // RX AXI4-S Interface
//        .m_axi_rx_tdata         (),
//        .m_axi_rx_tvalid        (),
//        .m_axi_rx_tready        (),
//        // GT Serial I/O
//        .rxp                    (QSFP1_RX_P         ),
//        .rxn                    (QSFP1_RX_N         ),
//        .txp                    (QSFP1_TX_P         ),
//        .txn                    (QSFP1_TX_N         ),
//        //GT Reference Clock Interface
//        .gt_refclk1_p           (gt_125M_clk        ),
//        // Status
//        .channel_up             (channel_up_aurora  ),
//        .lane_up                (lane_up_aurora     ),
//        // System Interface
//        .user_clk_out           (user_clk_i         ),
//        .reset_pb               (soft_reset         ),//复位
//        .drp_clk_in             (GT_125M_BUFG       ),
//        .init_clk_125M          (GT_125M_BUFG       ),
//        //---------------------- GTXE2 COMMON DRP Ports ----------------------
//        .tx_out_clk             ()
//     ); 



    //测试数据



//	assign buf_test_data	= test_mode ?	pixl_data_out	:	test_data;
//	assign buf_test_valid	= test_mode ?	pixl_data_out_en	:	test_valid;

//    test_data_gen test_data_gen(
//        .i_sys_clk                  (sys_main_clk       ),
//        .i_sys_reset                (soft_reset         ),
//        .i_delay_param              (i_delay_param      ),
//        .o_test_valid               (test_valid         ),
//        .o_test_data                (test_data          )
//    );

/*
    fifo_64B_1024_Y gt_rx_fifo (
      .m_aclk                       (user_clk_i         ),
      .s_aclk                       (sys_main_clk       ),
      .s_aresetn                    (!soft_reset        ),
      .s_axis_tvalid                ( buf_test_valid        ),
      .s_axis_tready                (AXIS_rx_ready),
      .s_axis_tdata                 ( buf_test_data         ),
      .m_axis_tvalid                (AXIS_tx_valid      ),
      .m_axis_tready                (AXIS_tx_ready      ),
      .m_axis_tdata                 (AXIS_tx_data       ) 
    );
*/

//    async_fifo #(
//        .DSIZE                      (1920),
//        .ASIZE                      (10)
//    ) gt_rx_afifo (
//        .w_clk                      (sys_main_clk),
//        .w_rst_n                    (!soft_reset),
//        .w_en                       (buf_test_valid && !gt_rx_afifo_full),
//        .w_data                     (buf_test_data),
//        .r_clk                      (user_clk_i),
//        .r_rst_n                    (!soft_reset),
//        .r_en                       (AXIS_tx_ready && !gt_rx_afifo_empty),
//        .r_data                     (AXIS_tx_data),
//        .r_empty                    (gt_rx_afifo_empty),
//        .w_full                     (gt_rx_afifo_full)
//    );

//    AXI_width_down_chg #(
//        .DATA_LO_WIDTH              (24                 ),//低宽度数据宽�?
//        .DATA_HI_WIDTH              (240                 ),//高宽度数据宽�?
//        .SYS_CLK_Period             (8                  ) //参�?�时钟周期，以ns为单�?
//    ) AXI_width_down_gt_tx (
//        //调试端口
//        .t_data_count               (),
//        //全局
//        .i_sys_clk                  (user_clk_i         ),//参�?�时�?
//        .i_sys_reset                (soft_reset         ),//
//        //低宽度AXIS接口                
//        .mAXIS_LO_ready             (AXIS_tx192_ready   ),
//        .mAXIS_LO_valid             (AXIS_tx192_valid   ),
//        .mAXIS_LO_last              ( ),
//        .mAXIS_LO_keep              (),
//        .mAXIS_LO_data              (AXIS_tx192_data    ),
//        //高宽度AXIS接口
//        .sAXIS_HI_ready             (AXIS_tx_ready      ),
//        .sAXIS_HI_valid             (!gt_rx_afifo_empty ),
//        .sAXIS_HI_last              ('d0 ),
//        .sAXIS_HI_keep              (64'HFFFF_FFFF_FFFF_FFFF),
//        .sAXIS_HI_data              (AXIS_tx_data       ) 
//    );

//    sync_fifo2 #(
//        .ASIZE                      (6),
//        .DSIZE                      (192)
//    ) gt_tx_sfifo (
//        .clk                        (user_clk_i),
//        .rst_n                      (!soft_reset),
//        .wr_en                      (AXIS_tx192_valid && !gt_tx_sfifo_full),
//        .wr_data                    (AXIS_tx192_data),
//        .rd_en                      (aurora_tx_ready && !gt_tx_sfifo_empty),
//        .rd_data                    (aurora_tx_data),
//        .fifo_full                  (gt_tx_sfifo_full),
//        .fifo_empty                 (gt_tx_sfifo_empty)
//    );

///*
//    AXIS_sfifo_256X64 gt_tx_fifo (
//        .s_aclk                     (user_clk_i         ),
//        .s_aresetn                  (!soft_reset        ),
//        .s_axis_tready              (AXIS_tx256_ready   ),
//        .s_axis_tvalid              (AXIS_tx256_valid   ),
//        .s_axis_tdata               (AXIS_tx256_data    ),       
//        .m_axis_tready              (aurora_tx_ready    ),
//        .m_axis_tvalid              (aurora_tx_valid    ),
//        .m_axis_tdata               (aurora_tx_data     )
//    );
//*/
//    aurora_64b66b_0_support aurora_64b66b_0_test (
//        // TX AXI4-S Interface
//        .s_axi_tx_tdata         (),
//        .s_axi_tx_tvalid        (),
//        .s_axi_tx_tready        (),
//        // RX AXI4-S Interface
//        .m_axi_rx_tdata         (aurora_rx_data     ),
//        .m_axi_rx_tvalid        (aurora_rx_valid    ),
//        .m_axi_rx_tready        (),
//        // GT Serial I/O
//        .rxp                    (QSFP2_RX_P         ),
//        .rxn                    (QSFP2_RX_N         ),
//        .txp                    (QSFP2_TX_P         ),
//        .txn                    (QSFP2_TX_N         ),
//        //GT Reference Clock Interface
//        .gt_refclk1_p           (gt_125M_clk        ),
//        // Status
//        .channel_up             (),
//        .lane_up                (),
//        // System Interface
//        .user_clk_out           (),
//        .reset_pb               (soft_reset         ),
//        .drp_clk_in             (GT_125M_BUFG       ),
//        .init_clk_125M          (GT_125M_BUFG       ),
//        //---------------------- GTXE2 COMMON DRP Ports ----------------------
//        .tx_out_clk             ()
//     );

    vio_0 vio_0 (
        .probe_in0                  (lane_up_aurora     ),//4
        .probe_out0                 (i_delay_param      ),//16
        .probe_out1                 (soft_reset         ),//1
        .probe_out2                 (test_mode          ),//1
        .clk                        (sys_main_clk       ) //
    );

//vio_3 vio_reset (
//  .clk(sys_clk50m),                // input wire clk
//  .probe_out0(rst_vio)  // output wire [0 : 0] probe_out0
//);

    


endmodule
