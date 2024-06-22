`timescale 1ns / 1ns
module virtul_top_690t(

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

    ,output    wire          clk_spi // spi鍐呴儴鏃堕挓
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

    ,input               MGT117_P        
    ,input               MGT117_N        
/*  
    ,output [2 : 0]      QSFP1_TX_P      
    ,output [2 : 0]      QSFP1_TX_N      
    ,input  [2 : 0]      QSFP1_RX_P      
    ,input  [2 : 0]      QSFP1_RX_N          

    ,output [2 : 0]      QSFP2_TX_P      
    ,output [2 : 0]      QSFP2_TX_N      
    ,input  [2 : 0]      QSFP2_RX_P      
    ,input  [2 : 0]      QSFP2_RX_N      
*/
    
    ,input               F1_EMCCLK
	
	,output wire [1919:0] pixl_data_out
	,output	wire 		pixl_data_out_en
	,output wire        AXIS_rx_ready

    );


	wire 				test_mode				;
	wire 				soft_reset				;
    wire                sys_main_clk            ;
    wire                GT_125M_BUFG            ;
    wire                gt_125M_clk             ;
    wire                user_clk_i              ;

    wire [255:0]        probe0                  ;
    
 (* mark_debug= "TRUE" *)   wire                channel_up_aurora       ;
 (* mark_debug= "TRUE" *)   wire [2 : 0]        lane_up_aurora          ;
 (* mark_debug= "TRUE" *)   wire                AXIS_tx_ready           ;
                            wire                AXIS_tx_valid           ;
 (* mark_debug= "TRUE" *)   wire [1919:0]       AXIS_tx_data            ;
    
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

    IBUFDS_GTE2 IBUFGDS_GTclk_gt (
        .CEB                (1'b0               ),
        .I                  (MGT117_P           ),
        .IB                 (MGT117_N           ),
        .ODIV2              (),
        .O                  (gt_125M_clk        )
    );


wire	sys_clk50m;

    clk_wiz_0 clk_wiz_0 (
        .clk_out2   (sys_clk50m   ),
        .clk_out1   (sys_main_clk   ),
        .clk_in1    (F1_EMCCLK      )
    );

    assign GT_125M_BUFG             = sys_main_clk ;


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


assign PDLU_EN	= (pixl_rstn_cnt	<	20) ?	1'b0	:	1'b1;
assign PDLU_RSTN	=(pixl_rstn_cnt	<	20) ?	1'b0	:	1'b1;
assign PDLU_pixel_RSTN	=(pixl_rstn_cnt	<	2000) ?	1'b0	:	1'b1;
assign PDRU_Mclk_20M	=clk20m;

assign pixl_rstn	= (pixl_rstn_cnt	<	20000) ?	1'b0	:	1'b1;


// assign PDRU_Mclk_20M	=(pixl_rstn_cnt	<	220100) ?	1'b0	:	clk20m;

// assign PDLU_EN	= 1'b1;
// assign PDLU_RSTN	=rstn;
// assign PDLU_pixel_RSTN	=rstn;
// assign PDRU_Mclk_20M	=clk20m;
//************************************************************

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

	
endmodule