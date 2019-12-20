## uncomment this line for rebuild of xilinx libs
rm -rf xilinx_libs
vlib xilinx_libs
vivado -mode tcl -source tcl_files/xilinx_compile_simlib.tcl

rm -rf xilinx_libs/blk_mem_gen_v8_3_1
vlib xilinx_libs/blk_mem_gen_v8_3_1
vmap blk_mem_gen_v8_3_1 xilinx_libs/blk_mem_gen_v8_3_1
vcom -work xilinx_libs/blk_mem_gen_v8_3_1 /home/tools/xilinx/Vivado/2015.4/data/ip/xilinx/blk_mem_gen_v8_3/simulation/blk_mem_gen_v8_3.vhd
vcom -work xilinx_libs ../ips/xilinx_mem_8192x32/xilinx_mem_8192x32.srcs/sources_1/ip/xilinx_mem_8192x32/sim/xilinx_mem_8192x32.vhd
vlog -work xilinx_libs ../ips/arty_mmcm/arty_mmcm.srcs/sources_1/ip/arty_mmcm/arty_mmcm_clk_wiz.v
vlog -work xilinx_libs ../ips/arty_mmcm/arty_mmcm.srcs/sources_1/ip/arty_mmcm/arty_mmcm.v
