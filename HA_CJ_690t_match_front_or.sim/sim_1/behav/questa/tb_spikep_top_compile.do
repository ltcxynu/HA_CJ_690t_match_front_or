######################################################################
#
# File name : tb_spikep_top_compile.do
# Created on: Tue Jun 18 10:40:31 +0800 2024
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog  -mfcu -sv -work xpm  "+incdir+../../../../HA_CJ_690t_match.srcs/sources_1/ip/clk_wiz_1" "+incdir+../../../../HA_CJ_690t_match.srcs/sources_1/ip/clk_wiz_0" \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vlog  -mfcu -work xil_defaultlib  "+incdir+../../../../HA_CJ_690t_match.srcs/sources_1/ip/clk_wiz_1" "+incdir+../../../../HA_CJ_690t_match.srcs/sources_1/ip/clk_wiz_0" \
"../../../../HA_CJ_690t_match.srcs/sources_1/ip/ila_2/sim/ila_2.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/ip/vio_2/sim/vio_2.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/ip/fifo512bit_1k/fifo512bit_1k_sim_netlist.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/ip/ila_1/sim/ila_1.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/ip/vio_1/sim/vio_1.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/ip/clk_wiz_1/clk_wiz_1_sim_netlist.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_sim_netlist.v" \
"../../../../HA_CJ_690t_match.srcs/sim_1/cisBfm.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/imports/sources_1/new/mem_1r1w_2000x509.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/imports/sources_1/new/pixl_receive.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/imports/sources_1/new/pixl_top.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/imports/sources_1/new/pp_pix.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/imports/sources_1/new/pp_ram2_r_w_ctrl.v" \
"../../../../HA_CJ_690t_match.srcs/sources_1/imports/sources_1/imports/code/spi_config.v" \
"../../../../HA_CJ_690t_match.srcs/sim_1/virtul_top_690t.v" \
"../../../../HA_CJ_690t_match.srcs/sim_1/tb_spike_top_690t.v" \

# compile glbl module
vlog -work xil_defaultlib "glbl.v"

quit -force

