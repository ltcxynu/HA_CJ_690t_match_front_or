vlib work
vlib activehdl

vlib activehdl/xpm
vlib activehdl/xil_defaultlib

vmap xpm activehdl/xpm
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work xpm  -sv2k12 "+incdir+../../../../HA_CJ_690t_match_front.srcs/sources_1/ip/vio_3/hdl/verilog" "+incdir+../../../../HA_CJ_690t_match_front.srcs/sources_1/ip/vio_3/hdl" \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../HA_CJ_690t_match_front.srcs/sources_1/ip/vio_3/hdl/verilog" "+incdir+../../../../HA_CJ_690t_match_front.srcs/sources_1/ip/vio_3/hdl" \
"../../../../HA_CJ_690t_match_front.srcs/sources_1/ip/vio_3/sim/vio_3.v" \

vlog -work xil_defaultlib \
"glbl.v"

