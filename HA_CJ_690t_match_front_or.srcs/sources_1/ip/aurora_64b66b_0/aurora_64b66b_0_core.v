 ///////////////////////////////////////////////////////////////////////////////
 //
 // Project:  Aurora 64B/66B
 // Company:  Xilinx
 //
 //
 //
 // (c) Copyright 2008 - 2009 Xilinx, Inc. All rights reserved.
 //
 // This file contains confidential and proprietary information
 // of Xilinx, Inc. and is protected under U.S. and
 // international copyright and other intellectual property
 // laws.
 //
 // DISCLAIMER
 // This disclaimer is not a license and does not grant any
 // rights to the materials distributed herewith. Except as
 // otherwise provided in a valid license issued to you by
 // Xilinx, and to the maximum extent permitted by applicable
 // law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
 // WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
 // AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
 // BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
 // INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
 // (2) Xilinx shall not be liable (whether in contract or tort,
 // including negligence, or under any other theory of
 // liability) for any loss or damage of any kind or nature
 // related to, arising under or in connection with these
 // materials, including for any direct, or any indirect,
 // special, incidental, or consequential loss or damage
 // (including loss of data, profits, goodwill, or any type of
 // loss or damage suffered as a result of any action brought
 // by a third party) even if such damage or loss was
 // reasonably foreseeable or Xilinx had been advised of the
 // possibility of the same.
 //
 // CRITICAL APPLICATIONS
 // Xilinx products are not designed or intended to be fail-
 // safe, or for use in any application requiring fail-safe
 // performance, such as life-support or safety devices or
 // systems, Class III medical devices, nuclear facilities,
 // applications related to the deployment of airbags, or any
 // other applications that could lead to death, personal
 // injury, or severe property or environmental damage
 // (individually and collectively, "Critical
 // Applications"). Customer assumes the sole risk and
 // liability of any use of Xilinx products in Critical
 // Applications, subject only to applicable laws and
 // regulations governing limitations on product liability.
 //
 // THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
 // PART OF THIS FILE AT ALL TIMES.

 //
 ///////////////////////////////////////////////////////////////////////////////
 //
 //  aurora_64b66b_0
 //
 //
 //
 //  Description: This is the top level interface module
 //
 //
 ///////////////////////////////////////////////////////////////////////////////

 // aurora core  file

 `timescale 1 ns / 10 ps

   (* core_generation_info = "aurora_64b66b_0,aurora_64b66b_v12_0_8,{c_aurora_lanes=3,c_column_used=right,c_gt_clock_1=GTHQ4,c_gt_clock_2=None,c_gt_loc_1=X,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=1,c_gt_loc_18=2,c_gt_loc_19=X,c_gt_loc_2=X,c_gt_loc_20=3,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=X,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=X,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=10.0,c_gt_type=v7gth,c_qpll=true,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=125.0,c_simplex=false,c_simplex_mode=TX,c_stream=true,c_ufc=false,c_user_k=false,flow_mode=None,interface_mode=Streaming,dataflow_config=Duplex}" *)
(* DowngradeIPIdentifiedWarnings="yes" *)
 module aurora_64b66b_0_core #
 (

      parameter     STABLE_CLOCK_PERIOD = 8,            //Period of the stable clock driving this state-machine, unit is [ns]
      parameter   SIM_GTXRESET_SPEEDUP=   "TRUE",      // Set to 1 to speed up sim reset
 
      parameter CC_FREQ_FACTOR = 5'd24, // Its highly RECOMMENDED that this value be NOT changed.
                                        // Changing it to a value greater than 24 may result in soft errors.  
                                        // User may reduce to a value lower than 24 if channel needs to be 
                                        // established in noisy environment
                                        // Min value is 4.  
                                        // The current GAP in between two consecutive DO_CC posedge events is 4992 user_clk cycles.
 
     parameter   EXAMPLE_SIMULATION =   0      
      //pragma translate_off
        | 1
      //pragma translate_on
 )
 (
     // AXI TX Interface
     s_axi_tx_tdata,
     s_axi_tx_tvalid,
     s_axi_tx_tready,
 
     // AXI RX Interface
     m_axi_rx_tdata,
     m_axi_rx_tvalid,
 
 
 
 
 

     // GTX Serial I/O
     rxp,
     rxn,
     txp,
     txn,

    // GTX Reference Clock Interface
     gt_refclk1,

     // Error Detection Interface
     hard_err,
     soft_err,

     // Status
     channel_up,
     lane_up,
     // System Interface
     mmcm_not_locked,
     user_clk,
     sync_clk,
     sysreset_to_core,
     gt_rxcdrovrden_in,
     power_down,
     loopback,
     pma_init,
//---{

// I am in AURORA TOP file in 7 series port instance
    gt_qpllclk_quad5_in,
    gt_qpllrefclk_quad5_in,

    gt_to_common_qpllreset_out,
    gt_qplllock_in,//
    gt_qpllrefclklost_in,
    

//---}
     drp_clk_in,
 
     // AXI4-Lite Interface

     // Write Address Channel
       s_axi_awaddr,
       s_axi_awvalid,
       s_axi_awready,
       s_axi_awaddr_lane1,
       s_axi_awvalid_lane1,
       s_axi_awready_lane1,
       s_axi_awaddr_lane2,
       s_axi_awvalid_lane2,
       s_axi_awready_lane2,
     // Write Data Channel
       s_axi_wdata,
       s_axi_wstrb,
       s_axi_wvalid,
       s_axi_wready,
       s_axi_bvalid,
       s_axi_bresp,
       s_axi_bready,
       s_axi_wdata_lane1,
       s_axi_wstrb_lane1,
       s_axi_wvalid_lane1,
       s_axi_wready_lane1,
       s_axi_bvalid_lane1,
       s_axi_bresp_lane1,
       s_axi_bready_lane1,
       s_axi_wdata_lane2,
       s_axi_wstrb_lane2,
       s_axi_wvalid_lane2,
       s_axi_wready_lane2,
       s_axi_bvalid_lane2,
       s_axi_bresp_lane2,
       s_axi_bready_lane2,
     // Read Address Channel
       s_axi_araddr,
       s_axi_arvalid,
       s_axi_arready,
       s_axi_araddr_lane1,
       s_axi_arvalid_lane1,
       s_axi_arready_lane1,
       s_axi_araddr_lane2,
       s_axi_arvalid_lane2,
       s_axi_arready_lane2,
     // Read Data Channel
       s_axi_rdata,
       s_axi_rvalid,
       s_axi_rresp,
       s_axi_rready,
       s_axi_rdata_lane1,
       s_axi_rvalid_lane1,
       s_axi_rresp_lane1,
       s_axi_rready_lane1,
       s_axi_rdata_lane2,
       s_axi_rvalid_lane2,
       s_axi_rresp_lane2,
       s_axi_rready_lane2,



    init_clk,
    link_reset_out,



       gt_pll_lock,
       sys_reset_out,



       tx_out_clk
 );


 localparam INTER_CB_GAP = 5'd9;
 localparam BACKWARD_COMP_MODE1 = 1'b0; //disable check for interCB gap
 localparam BACKWARD_COMP_MODE2 = 1'b0; //reduce RXCDR lock time, Block Sync SH max count, disable CDR FSM in wrapper
 localparam BACKWARD_COMP_MODE3 = 1'b0; //clear hot-plug counter with any valid btf detected

 `define DLY #1

 //***********************************Port Declarations*******************************

     // TX AXI Interface
       input  [0:191]    s_axi_tx_tdata; 
       input             s_axi_tx_tvalid;
       output            s_axi_tx_tready;

     // RX AXI Interface
       output [0:191]    m_axi_rx_tdata; 
       output             m_axi_rx_tvalid;





     // GTX Serial I/O
       input  [0:2]      rxp;
       input  [0:2]      rxn;

       output  [0:2]      txp;
       output  [0:2]      txn;

     // GTX Reference Clock Interface
       input              gt_refclk1;

     // Error Detection Interface
       output            hard_err;
       output            soft_err;

     // Status
       output             channel_up;
       output  [0:2]      lane_up;

     // System Interface
       input               mmcm_not_locked;
       input               user_clk;
       input               sync_clk;
       input               sysreset_to_core;
       input               gt_rxcdrovrden_in;
       input               power_down;
       input    [2:0]      loopback;
       input               pma_init;
       output              sys_reset_out;
//---{


    input                     gt_qpllclk_quad5_in;
    input                     gt_qpllrefclk_quad5_in;

    output                    gt_to_common_qpllreset_out;
    input                     gt_qplllock_in;//
    input                     gt_qpllrefclklost_in;//
//---}
       input    drp_clk_in;

     //-------------------- AXI4-Lite Interface -------------------------------

     //-------------------- Write Address Channel --------------------------
       input     [31:0]       s_axi_awaddr;
       input                 s_axi_awvalid;
       output                s_axi_awready;
       input     [31:0]       s_axi_awaddr_lane1;
       input                 s_axi_awvalid_lane1;
       output                s_axi_awready_lane1;
       input     [31:0]       s_axi_awaddr_lane2;
       input                 s_axi_awvalid_lane2;
       output                s_axi_awready_lane2;
     //-------------------- Write Data Channel -----------------------------
       input     [31:0]      s_axi_wdata;
       input     [3:0]      s_axi_wstrb;
       input                 s_axi_wvalid;
       output                s_axi_wready;
       output                s_axi_bvalid;
       output    [1:0]            s_axi_bresp;
       input                 s_axi_bready;
       input     [31:0]      s_axi_wdata_lane1;
       input     [3:0]      s_axi_wstrb_lane1;
       input                 s_axi_wvalid_lane1;
       output                s_axi_wready_lane1;
       output                s_axi_bvalid_lane1;
       output    [1:0]            s_axi_bresp_lane1;
       input                 s_axi_bready_lane1;
       input     [31:0]      s_axi_wdata_lane2;
       input     [3:0]      s_axi_wstrb_lane2;
       input                 s_axi_wvalid_lane2;
       output                s_axi_wready_lane2;
       output                s_axi_bvalid_lane2;
       output    [1:0]            s_axi_bresp_lane2;
       input                 s_axi_bready_lane2;
     //-------------------- Read Address Channel ---------------------------
       input      [31:0]      s_axi_araddr;
       input                 s_axi_arvalid;
       output                s_axi_arready;
       input      [31:0]      s_axi_araddr_lane1;
       input                 s_axi_arvalid_lane1;
       output                s_axi_arready_lane1;
       input      [31:0]      s_axi_araddr_lane2;
       input                 s_axi_arvalid_lane2;
       output                s_axi_arready_lane2;
     //-------------------- Read Data Channel -----------------------------
       output      [31:0]     s_axi_rdata;
       output                 s_axi_rvalid;
       output    [1:0]            s_axi_rresp;
       input                  s_axi_rready;
       output      [31:0]     s_axi_rdata_lane1;
       output                 s_axi_rvalid_lane1;
       output    [1:0]            s_axi_rresp_lane1;
       input                  s_axi_rready_lane1;
       output      [31:0]     s_axi_rdata_lane2;
       output                 s_axi_rvalid_lane2;
       output    [1:0]            s_axi_rresp_lane2;
       input                  s_axi_rready_lane2;


       output              gt_pll_lock;
       output              tx_out_clk;





       input              init_clk;
       output             link_reset_out;

 //*********************************Wire Declarations**********************************

       wire                drp_clk;
       wire                rst_drp;
       wire    [0:191]    tx_d_i2;
       wire               tx_src_rdy_n_i2;
       wire               tx_dst_rdy_n_i2;
       wire    [0:4]      tx_rem_i2;
       wire    [0:4]      tx_rem_i3;
       wire               tx_sof_n_i2;
       wire               tx_eof_n_i2;
       wire    [0:191]    rx_d_i2;
       wire               rx_src_rdy_n_i2;
       wire    [0:4]      rx_rem_i2;
       wire    [0:4]      rx_rem_i3;
       wire               rx_sof_n_i2;
       wire               rx_eof_n_i2;

       wire    [0:191]    tx_d_i;
       wire               tx_src_rdy_n_i;
       wire               tx_dst_rdy_n_i;



       wire    [0:191]    rx_d_i;
       wire               rx_src_rdy_n_i;



       wire    [0:2]      ch_bond_done_i;
       wire               en_chan_sync_i;
       wire               chan_bond_reset_i;
       wire    [0:191]    tx_data_i;
       wire    [0:191]    rx_data_i;
       wire    [0:191]    tx_pe_data_i;
       wire    [0:2]      tx_pe_data_v_i;
       wire    [0:191]    rx_pe_data_i;
       wire    [0:2]      rx_pe_data_v_i;
       wire               channel_up_rx_if;
       wire               channel_up_tx_if;
       wire                system_reset_c;
       wire    [0:2]      tx_buf_err_i;
       wire    [0:2]      rx_lossofsync_i;
       wire    [0:2]      check_polarity_i;
       wire    [0:2]      rx_neg_i;
       wire    [0:2]      rx_polarity_i;
       wire    [0:2]      tx_header_1_i;
       wire    [0:2]      tx_header_0_i;
       wire    [0:2]      gt_pll_lock_i;
       wire    [0:2]      gt_pll_lock_ii;
       wire    [0:2]      tx_reset_i;
       wire    [0:2]      hard_err_i;
       wire    [0:2]      soft_err_i;
       wire    [0:2]      lane_up_i;
       wire    [0:2]      raw_tx_out_clk_i;
       wire               reset_lanes_i;
       wire    [0:2]      rx_buf_err_i;
       wire    [0:2]      rx_header_1_i;
       wire    [0:2]      rx_header_0_i;
       wire    [0:2]      rx_reset_i;
       wire               gen_na_idles_i;




       wire    [0:2]      gen_ch_bond_i;
       wire    [0:2]      got_na_idles_i;
       wire    [0:2]      got_idles_i;
       wire    [0:2]      got_cc_i;
       wire    [0:2]      rxdatavalid_to_ll_i;
       wire    [0:2]      remote_ready_i;
       wire    [0:2]      got_cb_i;
       wire    [0:2]      gen_cc_i;





     //Datavalid signal is routed to Local Link
       wire    [0:2]      rxdatavalid_i;
       wire               rxdatavalid_to_lanes_i;
       wire               txdatavalid_i;
       wire               txdatavalid_to_ll_i;
       wire               txdatavalid_symgen_i;
       wire               txclk_locked_c;

       wire               drp_clk_i;
       wire    [8:0] drpaddr_in_i;
       wire    [15:0]     drpdi_in_i;
       wire    [15:0]     drpdo_out_i;
       wire               drprdy_out_i;
       wire               drpen_in_i;
       wire               drpwe_in_i;
       wire    [8:0] drpaddr_in_lane1_i;
       wire    [15:0]     drpdi_in_lane1_i;
       wire    [15:0]     drpdo_out_lane1_i;
       wire               drprdy_out_lane1_i;
       wire               drpen_in_lane1_i;
       wire               drpwe_in_lane1_i;
       wire    [8:0] drpaddr_in_lane2_i;
       wire    [15:0]     drpdi_in_lane2_i;
       wire    [15:0]     drpdo_out_lane2_i;
       wire               drprdy_out_lane2_i;
       wire               drpen_in_lane2_i;
       wire               drpwe_in_lane2_i;


       wire               do_cc_i;
       wire               link_reset_i;
       wire               reset;
       wire               mmcm_not_locked_i;

       reg                soft_err;
       wire               sysreset_to_core_sync;
       wire               pma_init_sync;



 //*********************************Main Body of Code**********************************
     assign reset = sys_reset_out;


     // Connect top level logic
     assign channel_up  =   channel_up_rx_if;
     assign txclk_locked_c = !mmcm_not_locked ;

     always @(posedge user_clk)
       if(reset)
           soft_err  <= `DLY 1'b0;
       else
           soft_err  <= `DLY (|soft_err_i) & channel_up_tx_if;


     // Connect the TXOUTCLK of lane 0 to TX_OUT_CLK
       assign  tx_out_clk  =   raw_tx_out_clk_i[1];
 
 
 
       assign  gt_pll_lock =   gt_pll_lock_i [0];
       assign  rxdatavalid_to_lanes_i = |rxdatavalid_i;


    aurora_64b66b_0_rst_sync #
    (
        .c_mtbf_stages (5)
    )reset_pb_sync
    (
        .prmry_in     (sysreset_to_core),
        .scndry_aclk  (user_clk),
        .scndry_out   (sysreset_to_core_sync)
    );

    aurora_64b66b_0_rst_sync #
    (
        .c_mtbf_stages (5)
    )gt_reset_sync
    (
        .prmry_in     (pma_init),
        .scndry_aclk  (init_clk),
        .scndry_out   (pma_init_sync)
    );

    wire fsm_resetdone;
    // RESET_LOGIC instance
    aurora_64b66b_0_RESET_LOGIC core_reset_logic_i
    (
        .RESET                  (sysreset_to_core_sync),
        .USER_CLK               (user_clk),
        .INIT_CLK               (init_clk),
        .FSM_RESETDONE          (fsm_resetdone),
        .POWER_DOWN             (power_down),
        .LINK_RESET_IN          (link_reset_i),
        .SYSTEM_RESET           (sys_reset_out)
    );

 
      assign link_reset_out   =  link_reset_i;
 

     //_________________________Instantiate Lane 0______________________________

      assign         lane_up [0] =   lane_up_i [0];

aurora_64b66b_0_AURORA_LANE aurora_lane_0_i
     (
         // TX STREAM
           .TX_PE_DATA(tx_pe_data_i[0:63]),
           .TX_PE_DATA_V(tx_pe_data_v_i [0]),



           .CHANNEL_UP(channel_up_tx_if),
           .GEN_CC(gen_cc_i [0]),

         // RX STREAM
           .RX_PE_DATA(rx_pe_data_i[0:63]),
           .RX_PE_DATA_V(rx_pe_data_v_i [0]),




         // GTX Interface
           .RX_DATA(rx_data_i[0:63]),
           .RX_HEADER_1(rx_header_1_i [0]),
           .RX_HEADER_0(rx_header_0_i [0]),
           .TX_BUF_ERR(|tx_buf_err_i),
           .RX_BUF_ERR(|rx_buf_err_i),
           .CHECK_POLARITY(check_polarity_i [0]),
           .RX_NEG(rx_neg_i [0]),
           .RX_POLARITY(rx_polarity_i [0]),
           .RX_RESET(rx_reset_i [0]),
           .TX_HEADER_1(tx_header_1_i [0]),
           .TX_HEADER_0(tx_header_0_i [0]),
           .TX_DATA(tx_data_i[0:63]),
           .TX_RESET(tx_reset_i [0]),
           .RX_LOSSOFSYNC(rx_lossofsync_i [0]),

         // Global Logic Interface
           .GEN_NA_IDLE(gen_na_idles_i),
           .GEN_CH_BOND(gen_ch_bond_i [0]),
           .LANE_UP(lane_up_i [0]),
           .HARD_ERR(hard_err_i [0]),
           .SOFT_ERR(soft_err_i [0]),
           .GOT_NA_IDLE(got_na_idles_i [0]),
           .GOT_CC(got_cc_i [0]),
           .REMOTE_READY(remote_ready_i [0]),
           .GOT_CB(got_cb_i [0]),
           .GOT_IDLE(got_idles_i [0]),

         // System Interface
           .USER_CLK(user_clk),
           .RESET_LANES(reset_lanes_i),
           .GTXRESET_IN(pma_init_sync),
           .RESET(reset),
           .TXDATAVALID_SYMGEN_IN(txdatavalid_symgen_i),
           .RXDATAVALID_IN(rxdatavalid_to_lanes_i)
     );


     //_________________________Instantiate Lane 1______________________________

      assign         lane_up [1] =   lane_up_i [1];

aurora_64b66b_0_AURORA_LANE aurora_lane_1_i
     (
         // TX STREAM
           .TX_PE_DATA(tx_pe_data_i[64:127]),
           .TX_PE_DATA_V(tx_pe_data_v_i [1]),



           .CHANNEL_UP(channel_up_tx_if),
           .GEN_CC(gen_cc_i [1]),

         // RX STREAM
           .RX_PE_DATA(rx_pe_data_i[64:127]),
           .RX_PE_DATA_V(rx_pe_data_v_i [1]),




         // GTX Interface
           .RX_DATA(rx_data_i[64:127]),
           .RX_HEADER_1(rx_header_1_i [1]),
           .RX_HEADER_0(rx_header_0_i [1]),
           .TX_BUF_ERR(|tx_buf_err_i),
           .RX_BUF_ERR(|rx_buf_err_i),
           .CHECK_POLARITY(check_polarity_i [1]),
           .RX_NEG(rx_neg_i [1]),
           .RX_POLARITY(rx_polarity_i [1]),
           .RX_RESET(rx_reset_i [1]),
           .TX_HEADER_1(tx_header_1_i [1]),
           .TX_HEADER_0(tx_header_0_i [1]),
           .TX_DATA(tx_data_i[64:127]),
           .TX_RESET(tx_reset_i [1]),
           .RX_LOSSOFSYNC(rx_lossofsync_i [1]),

         // Global Logic Interface
           .GEN_NA_IDLE(gen_na_idles_i),
           .GEN_CH_BOND(gen_ch_bond_i [1]),
           .LANE_UP(lane_up_i [1]),
           .HARD_ERR(hard_err_i [1]),
           .SOFT_ERR(soft_err_i [1]),
           .GOT_NA_IDLE(got_na_idles_i [1]),
           .GOT_CC(got_cc_i [1]),
           .REMOTE_READY(remote_ready_i [1]),
           .GOT_CB(got_cb_i [1]),
           .GOT_IDLE(got_idles_i [1]),

         // System Interface
           .USER_CLK(user_clk),
           .RESET_LANES(reset_lanes_i),
           .GTXRESET_IN(pma_init_sync),
           .RESET(reset),
           .TXDATAVALID_SYMGEN_IN(txdatavalid_symgen_i),
           .RXDATAVALID_IN(rxdatavalid_to_lanes_i)
     );


     //_________________________Instantiate Lane 2______________________________

      assign         lane_up [2] =   lane_up_i [2];

aurora_64b66b_0_AURORA_LANE aurora_lane_2_i
     (
         // TX STREAM
           .TX_PE_DATA(tx_pe_data_i[128:191]),
           .TX_PE_DATA_V(tx_pe_data_v_i [2]),



           .CHANNEL_UP(channel_up_tx_if),
           .GEN_CC(gen_cc_i [2]),

         // RX STREAM
           .RX_PE_DATA(rx_pe_data_i[128:191]),
           .RX_PE_DATA_V(rx_pe_data_v_i [2]),




         // GTX Interface
           .RX_DATA(rx_data_i[128:191]),
           .RX_HEADER_1(rx_header_1_i [2]),
           .RX_HEADER_0(rx_header_0_i [2]),
           .TX_BUF_ERR(|tx_buf_err_i),
           .RX_BUF_ERR(|rx_buf_err_i),
           .CHECK_POLARITY(check_polarity_i [2]),
           .RX_NEG(rx_neg_i [2]),
           .RX_POLARITY(rx_polarity_i [2]),
           .RX_RESET(rx_reset_i [2]),
           .TX_HEADER_1(tx_header_1_i [2]),
           .TX_HEADER_0(tx_header_0_i [2]),
           .TX_DATA(tx_data_i[128:191]),
           .TX_RESET(tx_reset_i [2]),
           .RX_LOSSOFSYNC(rx_lossofsync_i [2]),

         // Global Logic Interface
           .GEN_NA_IDLE(gen_na_idles_i),
           .GEN_CH_BOND(gen_ch_bond_i [2]),
           .LANE_UP(lane_up_i [2]),
           .HARD_ERR(hard_err_i [2]),
           .SOFT_ERR(soft_err_i [2]),
           .GOT_NA_IDLE(got_na_idles_i [2]),
           .GOT_CC(got_cc_i [2]),
           .REMOTE_READY(remote_ready_i [2]),
           .GOT_CB(got_cb_i [2]),
           .GOT_IDLE(got_idles_i [2]),

         // System Interface
           .USER_CLK(user_clk),
           .RESET_LANES(reset_lanes_i),
           .GTXRESET_IN(pma_init_sync),
           .RESET(reset),
           .TXDATAVALID_SYMGEN_IN(txdatavalid_symgen_i),
           .RXDATAVALID_IN(rxdatavalid_to_lanes_i)
     );



     //_________________________Instantiate GTX Wrapper ______________________________

aurora_64b66b_0_WRAPPER  #
     (
        .INTER_CB_GAP                           (INTER_CB_GAP),
        .BACKWARD_COMP_MODE1                    (BACKWARD_COMP_MODE1),
        .BACKWARD_COMP_MODE2                    (BACKWARD_COMP_MODE2),
        .BACKWARD_COMP_MODE3                    (BACKWARD_COMP_MODE3),
        .STABLE_CLOCK_PERIOD      (STABLE_CLOCK_PERIOD),           // Period of the stable clock driving this state-machine, unit is [ns]
        .SIM_GTXRESET_SPEEDUP                   (SIM_GTXRESET_SPEEDUP),
        .EXAMPLE_SIMULATION                     (EXAMPLE_SIMULATION)
     )
aurora_64b66b_0_wrapper_i
     (




         // Aurora Lane Interface
           .CHECK_POLARITY_IN    (check_polarity_i [0]),
           .RX_NEG_OUT           (rx_neg_i [0]),
           .RXPOLARITY_IN        (rx_polarity_i [0]),
           .RXRESET_IN           (rx_reset_i [0]),
           .TXDATA_IN          (tx_data_i[0:63]),
           .TXRESET_IN           (tx_reset_i [0]),
           .RXDATA_OUT           (rx_data_i[0:63]),
           .RXBUFERR_OUT         (rx_buf_err_i [0]),
           .TXBUFERR_OUT         (tx_buf_err_i [0]),

         // Global Logic Interface
           .CHBONDDONE_OUT       (ch_bond_done_i [0]),
           .ENCHANSYNC_IN        (en_chan_sync_i),
         // Serial IO
           .RX1N_IN              (rxn [0]),
           .RX1P_IN              (rxp [0]),
           .TX1N_OUT             (txn [0]),
           .TX1P_OUT             (txp [0]),
         // Aurora Lane Interface
           .CHECK_POLARITY_IN_LANE1    (check_polarity_i [1]),
           .RX_NEG_OUT_LANE1           (rx_neg_i [1]),
           .RXPOLARITY_IN_LANE1        (rx_polarity_i [1]),
           .RXRESET_IN_LANE1           (rx_reset_i [1]),
           .TXDATA_IN_LANE1          (tx_data_i[64:127]),
           .TXRESET_IN_LANE1           (tx_reset_i [1]),
           .RXDATA_OUT_LANE1           (rx_data_i[64:127]),
           .RXBUFERR_OUT_LANE1         (rx_buf_err_i [1]),
           .TXBUFERR_OUT_LANE1         (tx_buf_err_i [1]),

         // Global Logic Interface
           .CHBONDDONE_OUT_LANE1       (ch_bond_done_i [1]),
           .ENCHANSYNC_IN_LANE1        (en_chan_sync_i),
         // Serial IO
           .RX1N_IN_LANE1              (rxn [1]),
           .RX1P_IN_LANE1              (rxp [1]),
           .TX1N_OUT_LANE1             (txn [1]),
           .TX1P_OUT_LANE1             (txp [1]),
         // Aurora Lane Interface
           .CHECK_POLARITY_IN_LANE2    (check_polarity_i [2]),
           .RX_NEG_OUT_LANE2           (rx_neg_i [2]),
           .RXPOLARITY_IN_LANE2        (rx_polarity_i [2]),
           .RXRESET_IN_LANE2           (rx_reset_i [2]),
           .TXDATA_IN_LANE2          (tx_data_i[128:191]),
           .TXRESET_IN_LANE2           (tx_reset_i [2]),
           .RXDATA_OUT_LANE2           (rx_data_i[128:191]),
           .RXBUFERR_OUT_LANE2         (rx_buf_err_i [2]),
           .TXBUFERR_OUT_LANE2         (tx_buf_err_i [2]),

         // Global Logic Interface
           .CHBONDDONE_OUT_LANE2       (ch_bond_done_i [2]),
           .ENCHANSYNC_IN_LANE2        (en_chan_sync_i),
         // Serial IO
           .RX1N_IN_LANE2              (rxn [2]),
           .RX1P_IN_LANE2              (rxp [2]),
           .TX1N_OUT_LANE2             (txn [2]),
           .TX1P_OUT_LANE2             (txp [2]),
           //-----------
           // Clocks and Clock Status
           .TXUSRCLK_IN                            (sync_clk),
           .TXUSRCLK2_IN                           (user_clk),
           .RXLOSSOFSYNC_OUT     (rx_lossofsync_i [0]),
           .TXOUTCLK1_OUT        (raw_tx_out_clk_i [0]),
           .RXLOSSOFSYNC_OUT_LANE1     (rx_lossofsync_i [1]),
           .TXOUTCLK1_OUT_LANE1        (raw_tx_out_clk_i [1]),
           .RXLOSSOFSYNC_OUT_LANE2     (rx_lossofsync_i [2]),
           .TXOUTCLK1_OUT_LANE2        (raw_tx_out_clk_i [2]),
           //-----------
           .PLLLKDET_OUT         (gt_pll_lock_i [0]),
           .PLLLKDET_OUT_LANE1         (gt_pll_lock_i [1]),
           .PLLLKDET_OUT_LANE2         (gt_pll_lock_i [2]),
           //-----------
           // System Interface
           .GTXRESET_IN                            (pma_init_sync),
           //-----------
           .CHAN_BOND_RESET                        (chan_bond_reset_i),
           .LOOPBACK_IN                            (loopback),
           .CHANNEL_UP_RX_IF(channel_up_rx_if),
           .CHANNEL_UP_TX_IF(channel_up_tx_if),
           .POWERDOWN_IN                           (power_down),
           .REFCLK1_IN                             (gt_refclk1),

//---{

       .gt_qpllclk_quad5_in        (gt_qpllclk_quad5_in        ),
       .gt_qpllrefclk_quad5_in     (gt_qpllrefclk_quad5_in     ),

       .gt_to_common_qpllreset_out  (gt_to_common_qpllreset_out  ),
       .gt_qplllock_in       (gt_qplllock_in       ),
       .gt_qpllrefclklost_in (gt_qpllrefclklost_in ),
//---}
           .TXHEADER_IN({tx_header_1_i [0],tx_header_0_i [0]}),
           .RXHEADER_OUT({rx_header_1_i [0],rx_header_0_i [0]}),
           .TXHEADER_IN_LANE1({tx_header_1_i [1],tx_header_0_i [1]}),
           .RXHEADER_OUT_LANE1({rx_header_1_i [1],rx_header_0_i [1]}),
           .TXHEADER_IN_LANE2({tx_header_1_i [2],tx_header_0_i [2]}),
           .RXHEADER_OUT_LANE2({rx_header_1_i [2],rx_header_0_i [2]}),
           .RESET(reset),
           .GT_RXCDROVRDEN_IN(gt_rxcdrovrden_in),
           .FSM_RESETDONE(fsm_resetdone),
           .RXDATAVALID_OUT(rxdatavalid_i [0]),
           .RXDATAVALID_OUT_LANE1(rxdatavalid_i [1]),
           .RXDATAVALID_OUT_LANE2(rxdatavalid_i [2]),
           .TXDATAVALID_OUT(txdatavalid_i),
           .TXCLK_LOCK(txclk_locked_c),

    //---------------------- GT DRP Ports ----------------------
	   .DRP_CLK_IN(drp_clk_in),
           .DRPADDR_IN(drpaddr_in_i),
	   .DRPDI_IN(drpdi_in_i),
           .DRPDO_OUT(drpdo_out_i),
           .DRPRDY_OUT(drprdy_out_i),
           .DRPEN_IN(drpen_in_i),
           .DRPWE_IN(drpwe_in_i),
           .DRPADDR_IN_LANE1(drpaddr_in_lane1_i),
	   .DRPDI_IN_LANE1(drpdi_in_lane1_i),
           .DRPDO_OUT_LANE1(drpdo_out_lane1_i),
           .DRPRDY_OUT_LANE1(drprdy_out_lane1_i),
           .DRPEN_IN_LANE1(drpen_in_lane1_i),
           .DRPWE_IN_LANE1(drpwe_in_lane1_i),
           .DRPADDR_IN_LANE2(drpaddr_in_lane2_i),
	   .DRPDI_IN_LANE2(drpdi_in_lane2_i),
           .DRPDO_OUT_LANE2(drpdo_out_lane2_i),
           .DRPRDY_OUT_LANE2(drprdy_out_lane2_i),
           .DRPEN_IN_LANE2(drpen_in_lane2_i),
           .DRPWE_IN_LANE2(drpwe_in_lane2_i),


         .INIT_CLK                      (init_clk),
         .LINK_RESET_OUT                (link_reset_i),


         .TXDATAVALID_SYMGEN_OUT        (txdatavalid_symgen_i),
           //-----------
           .RXUSRCLK2_IN                           (user_clk)
     );

     assign mmcm_not_locked_i = mmcm_not_locked;


     //_____________________________ AXI DRP SHIM _______________________________
aurora_64b66b_0_AXI_TO_DRP #
     (
        .DATA_WIDTH(32)
     )

     axi_to_drp_i
     (
            // AXI4-Lite input signals
          .S_AXI_AWADDR(s_axi_awaddr),
          .S_AXI_AWVALID(s_axi_awvalid),
          .S_AXI_AWREADY(s_axi_awready),
          .S_AXI_AWADDR_LANE1(s_axi_awaddr_lane1),
          .S_AXI_AWVALID_LANE1(s_axi_awvalid_lane1),
          .S_AXI_AWREADY_LANE1(s_axi_awready_lane1),
          .S_AXI_AWADDR_LANE2(s_axi_awaddr_lane2),
          .S_AXI_AWVALID_LANE2(s_axi_awvalid_lane2),
          .S_AXI_AWREADY_LANE2(s_axi_awready_lane2),
          .S_AXI_WDATA(s_axi_wdata),
          .S_AXI_WSTRB(s_axi_wstrb),
          .S_AXI_WVALID(s_axi_wvalid),
          .S_AXI_WREADY(s_axi_wready),
          .S_AXI_BVALID(s_axi_bvalid),
          .S_AXI_BRESP(s_axi_bresp),
          .S_AXI_BREADY(s_axi_bready),
          .S_AXI_WDATA_LANE1(s_axi_wdata_lane1),
          .S_AXI_WSTRB_LANE1(s_axi_wstrb_lane1),
          .S_AXI_WVALID_LANE1(s_axi_wvalid_lane1),
          .S_AXI_WREADY_LANE1(s_axi_wready_lane1),
          .S_AXI_BVALID_LANE1(s_axi_bvalid_lane1),
          .S_AXI_BRESP_LANE1(s_axi_bresp_lane1),
          .S_AXI_BREADY_LANE1(s_axi_bready_lane1),
          .S_AXI_WDATA_LANE2(s_axi_wdata_lane2),
          .S_AXI_WSTRB_LANE2(s_axi_wstrb_lane2),
          .S_AXI_WVALID_LANE2(s_axi_wvalid_lane2),
          .S_AXI_WREADY_LANE2(s_axi_wready_lane2),
          .S_AXI_BVALID_LANE2(s_axi_bvalid_lane2),
          .S_AXI_BRESP_LANE2(s_axi_bresp_lane2),
          .S_AXI_BREADY_LANE2(s_axi_bready_lane2),
          .S_AXI_ARADDR(s_axi_araddr),
          .S_AXI_ARVALID(s_axi_arvalid),
          .S_AXI_ARREADY(s_axi_arready),
          .S_AXI_ARADDR_LANE1(s_axi_araddr_lane1),
          .S_AXI_ARVALID_LANE1(s_axi_arvalid_lane1),
          .S_AXI_ARREADY_LANE1(s_axi_arready_lane1),
          .S_AXI_ARADDR_LANE2(s_axi_araddr_lane2),
          .S_AXI_ARVALID_LANE2(s_axi_arvalid_lane2),
          .S_AXI_ARREADY_LANE2(s_axi_arready_lane2),
          .S_AXI_RDATA(s_axi_rdata),
          .S_AXI_RVALID(s_axi_rvalid),
          .S_AXI_RRESP(s_axi_rresp),
          .S_AXI_RREADY(s_axi_rready),
          .S_AXI_RDATA_LANE1(s_axi_rdata_lane1),
          .S_AXI_RVALID_LANE1(s_axi_rvalid_lane1),
          .S_AXI_RRESP_LANE1(s_axi_rresp_lane1),
          .S_AXI_RREADY_LANE1(s_axi_rready_lane1),
          .S_AXI_RDATA_LANE2(s_axi_rdata_lane2),
          .S_AXI_RVALID_LANE2(s_axi_rvalid_lane2),
          .S_AXI_RRESP_LANE2(s_axi_rresp_lane2),
          .S_AXI_RREADY_LANE2(s_axi_rready_lane2),

          // DRP Interface
          .DRPADDR_IN(drpaddr_in_i),
          .DRPDI_IN(drpdi_in_i),
          .DRPDO_OUT(drpdo_out_i),
          .DRPRDY_OUT(drprdy_out_i),
          .DRPEN_IN(drpen_in_i),
          .DRPWE_IN(drpwe_in_i),
          .DRPADDR_IN_LANE1(drpaddr_in_lane1_i),
          .DRPDI_IN_LANE1(drpdi_in_lane1_i),
          .DRPDO_OUT_LANE1(drpdo_out_lane1_i),
          .DRPRDY_OUT_LANE1(drprdy_out_lane1_i),
          .DRPEN_IN_LANE1(drpen_in_lane1_i),
          .DRPWE_IN_LANE1(drpwe_in_lane1_i),
          .DRPADDR_IN_LANE2(drpaddr_in_lane2_i),
          .DRPDI_IN_LANE2(drpdi_in_lane2_i),
          .DRPDO_OUT_LANE2(drpdo_out_lane2_i),
          .DRPRDY_OUT_LANE2(drprdy_out_lane2_i),
          .DRPEN_IN_LANE2(drpen_in_lane2_i),
          .DRPWE_IN_LANE2(drpwe_in_lane2_i),

          // System Interface
          .DRP_CLK_IN (drp_clk_in),
          .RESET(rst_drp)
     );


     //__________Instantiate Global Logic to combine Lanes into a Channel______

aurora_64b66b_0_GLOBAL_LOGIC #
     (
        .INTER_CB_GAP(INTER_CB_GAP)
     )   global_logic_i
     (
         //GTX Interface
         .CH_BOND_DONE(ch_bond_done_i),
         .EN_CHAN_SYNC(en_chan_sync_i),
         .CHAN_BOND_RESET(chan_bond_reset_i),

         // Aurora Lane Interface
         .LANE_UP(lane_up_i),
         .HARD_ERR(hard_err_i),
         .GEN_NA_IDLES(gen_na_idles_i),
         .GEN_CH_BOND(gen_ch_bond_i),
         .RESET_LANES(reset_lanes_i),
         .GOT_NA_IDLES(got_na_idles_i),
         .GOT_CCS(got_cc_i),
         .REMOTE_READY(remote_ready_i),
         .GOT_CBS(got_cb_i),
         .GOT_IDLES(got_idles_i),

         // System Interface
         .USER_CLK(user_clk),
         .RESET(reset),
         .CHANNEL_UP_RX_IF(channel_up_rx_if),
         .CHANNEL_UP_TX_IF(channel_up_tx_if),
         .CHANNEL_HARD_ERR(hard_err),
         .TXDATAVALID_IN(txdatavalid_i)
     );

     //_____________________________ TX AXI SHIM _______________________________
     // Converts input AXI4-Stream signals to LocalLink

aurora_64b66b_0_AXI_TO_LL #
     (
        .DATA_WIDTH(192),
        .STRB_WIDTH(24),
        .USE_4_NFC (0),
        .REM_WIDTH (5)
     )

     axi_to_ll_data_i
     (
      .AXI4_S_IP_TX_TVALID(s_axi_tx_tvalid),
      .AXI4_S_IP_TX_TREADY(s_axi_tx_tready),
      .AXI4_S_IP_TX_TDATA(s_axi_tx_tdata),
      .AXI4_S_IP_TX_TKEEP(24'd0),
      .AXI4_S_IP_TX_TLAST(1'b0),

      .LL_OP_DATA(tx_d_i),
      .LL_OP_SOF_N(),
      .LL_OP_EOF_N() ,
      .LL_OP_REM() ,
      .LL_OP_SRC_RDY_N(tx_src_rdy_n_i),
      .LL_IP_DST_RDY_N(tx_dst_rdy_n_i),

      // System Interface
      .USER_CLK(user_clk),
      .CHANNEL_UP(channel_up_tx_if)
     );






 //_____________________________ RX AXI SHIM _______________________________

aurora_64b66b_0_LL_TO_AXI #
     (
        .DATA_WIDTH(192),
        .STRB_WIDTH(24),
        .REM_WIDTH (5)
     )

     ll_to_axi_data_i
     (
      .LL_IP_DATA(rx_d_i),
      .LL_IP_SOF_N(),
      .LL_IP_EOF_N(1'b0),
      
      .LL_IP_REM(5'd0),
      .LL_IP_SRC_RDY_N(rx_src_rdy_n_i),
      .LL_OP_DST_RDY_N(),

      .AXI4_S_OP_TVALID(m_axi_rx_tvalid),
      .AXI4_S_OP_TDATA(m_axi_rx_tdata),
      .AXI4_S_OP_TKEEP(),
      .AXI4_S_OP_TLAST(),
      .AXI4_S_IP_TREADY(1'b0)

     );


    // TX STREAM
aurora_64b66b_0_TX_STREAM tx_stream_i
    (
         .TX_D(tx_d_i),
         .TX_SRC_RDY_N(tx_src_rdy_n_i),
         .TX_DST_RDY_N(tx_dst_rdy_n_i),
         .TX_PE_DATA(tx_pe_data_i),
         .TX_PE_DATA_V(tx_pe_data_v_i),








         .CHANNEL_UP(channel_up_tx_if),
         .DO_CC(do_cc_i),
         .GEN_CC(gen_cc_i),
         .USER_CLK(user_clk),
         .TXDATAVALID_IN(txdatavalid_i)
    );

    // RX STREAM
aurora_64b66b_0_RX_STREAM rx_stream_i
    (
         .RX_D(rx_d_i),
         .RX_SRC_RDY_N(rx_src_rdy_n_i),
         .RX_PE_DATA(rx_pe_data_i),
         .RX_PE_DATA_V(rx_pe_data_v_i),








         .CHANNEL_UP(channel_up_rx_if),
         .USER_CLK(user_clk),
         .RESET(reset_lanes_i)

    );


      assign rst_drp = pma_init_sync;  

    // Standard CC Module
aurora_64b66b_0_STANDARD_CC_MODULE #
(
    .CC_FREQ_FACTOR (CC_FREQ_FACTOR)
)
 standard_cc_module_i
    (
         .DO_CC         (do_cc_i),
         .USER_CLK      (user_clk),
         .CHANNEL_UP    (channel_up_rx_if)
    );

 endmodule
