vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../study_item.srcs/sources_1/ip/ila_0/hdl/verilog" \
"D:/sofeware/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/sofeware/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/sofeware/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../../study_item.srcs/sources_1/ip/ila_0/hdl/verilog" \
"../../../../study_item.srcs/sources_1/ip/ila_0/sim/ila_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

