#!/bin/tcsh

if (! $?VSIM_PATH ) then
  setenv VSIM_PATH      `pwd`
endif

if (! $?PULP_PATH ) then
  setenv PULP_PATH      `pwd`/../..
endif

setenv MSIM_LIBS_PATH ${VSIM_PATH}/modelsim_libs

setenv IPS_PATH       ${PULP_PATH}/ips
setenv RTL_PATH       ${PULP_PATH}/rtl
setenv TB_PATH        ${PULP_PATH}/tb
#setenv ASIC_DEFINES   "+define+PULP_FPGA_EMUL +define+PULP_FPGA_TOP"
setenv ASIC_DEFINES   "+define+PULP_FPGA_EMUL"

clear
source ${PULP_PATH}/vsim/vcompile/colors.csh

rm -rf modelsim_libs
vlib modelsim_libs

rm -rf work
vlib work

echo ""
echo "${Green}--> Compiling PULPino Platform... ${NC}"
echo ""

# IP blocks
source ${PULP_PATH}/vsim/vcompile/vcompile_ips.csh  || exit 1
## uncomment this line for rebuild of xilinx libs
rm -rf xilinx_libs
vlib xilinx_libs
vivado -mode tcl -source tcl_files/xilinx_compile_simlib.tcl
vmap xilinx_libs xilinx_libs
vmap secureip xilinx_libs/secureip
vmap unifast xilinx_libs/unifast
vmap unimacro xilinx_libs/unimacro
vmap unisim xilinx_libs/unisim

vmap unifast_ver xilinx_libs/unifast_ver
vmap unimacro_ver xilinx_libs/unimacro_ver
vmap unisim_ver xilinx_libs/unisims_ver

rm -rf xilinx_libs/blk_mem_gen_v8_3_1
vlib xilinx_libs/blk_mem_gen_v8_3_1
vmap blk_mem_gen_v8_3_1 xilinx_libs/blk_mem_gen_v8_3_1
vcom -work xilinx_libs/blk_mem_gen_v8_3_1 /home/tools/xilinx/Vivado/2015.4/data/ip/xilinx/blk_mem_gen_v8_3/simulation/blk_mem_gen_v8_3.vhd
vcom -work xilinx_libs ../ips/xilinx_mem_8192x32/xilinx_mem_8192x32.srcs/sources_1/ip/xilinx_mem_8192x32/sim/xilinx_mem_8192x32.vhd
vlog -work xilinx_libs ../ips/arty_mmcm/arty_mmcm.srcs/sources_1/ip/arty_mmcm/arty_mmcm_clk_wiz.v
vlog -work xilinx_libs ../ips/arty_mmcm/arty_mmcm.srcs/sources_1/ip/arty_mmcm/arty_mmcm.v
source ${PULP_PATH}/vsim/vcompile/rtl/vcompile_pulpino.sh  || exit 1
vlog -sv -work $MSIM_LIBS_PATH/pulpino_lib ../rtl/pulpino_wrap.v
vlog -sv -work $MSIM_LIBS_PATH/pulpino_lib ../rtl/arty_top.v
source ${PULP_PATH}/vsim/vcompile/rtl/vcompile_tb.sh       || exit 1
vlog $XILINX_VIVADO/data/verilog/src/glbl.v

echo ""
echo "${Green}--> PULPino platform compilation complete! ${NC}"
echo ""
