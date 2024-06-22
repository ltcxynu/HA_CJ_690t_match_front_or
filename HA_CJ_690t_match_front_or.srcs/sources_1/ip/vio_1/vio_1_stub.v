// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Mon Jun 17 10:46:42 2024
// Host        : LAPTOP-INPBU3O4 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/study/shixi/690t/HA_CJ_690t_match/HA_CJ_690t_match/HA_CJ_690t_match.srcs/sources_1/ip/vio_1/vio_1_stub.v
// Design      : vio_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1157-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2021.2" *)
module vio_1(clk, probe_in0, probe_in1, probe_in2, probe_in3, 
  probe_out0, probe_out1, probe_out2, probe_out3)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[4:0],probe_in1[4:0],probe_in2[4:0],probe_in3[4:0],probe_out0[4:0],probe_out1[4:0],probe_out2[4:0],probe_out3[4:0]" */;
  input clk;
  input [4:0]probe_in0;
  input [4:0]probe_in1;
  input [4:0]probe_in2;
  input [4:0]probe_in3;
  output [4:0]probe_out0;
  output [4:0]probe_out1;
  output [4:0]probe_out2;
  output [4:0]probe_out3;
endmodule
