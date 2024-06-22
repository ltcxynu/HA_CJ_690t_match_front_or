-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
-- Date        : Mon Jun 17 10:46:42 2024
-- Host        : LAPTOP-INPBU3O4 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/study/shixi/690t/HA_CJ_690t_match/HA_CJ_690t_match/HA_CJ_690t_match.srcs/sources_1/ip/vio_1/vio_1_stub.vhdl
-- Design      : vio_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx690tffg1157-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_1 is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_out1 : out STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_out2 : out STD_LOGIC_VECTOR ( 4 downto 0 );
    probe_out3 : out STD_LOGIC_VECTOR ( 4 downto 0 )
  );

end vio_1;

architecture stub of vio_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[4:0],probe_in1[4:0],probe_in2[4:0],probe_in3[4:0],probe_out0[4:0],probe_out1[4:0],probe_out2[4:0],probe_out3[4:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2021.2";
begin
end;
