vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu -sv "+incdir+../../../../HA_CJ_690t_match.srcs/sources_1/ip/vio_1/hdl/verilog" "+incdir+../../../../HA_CJ_690t_match.srcs/sources_1/ip/vio_1/hdl" \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"E:/Xilinx/Vivado/2021.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu "+incdir+../../../../HA_CJ_690t_match.srcs/sources_1/ip/vio_1/hdl/verilog" "+incdir+../../../../HA_CJ_690t_match.srcs/sources_1/ip/vio_1/hdl" \
"../../../../HA_CJ_690t_match.srcs/sources_1/ip/vio_1/sim/vio_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

