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

clear
source ${PULP_PATH}/vsim/vcompile/colors.csh

rm -rf modelsim_libs
vlib modelsim_libs

rm -rf work
vlib work

rm -rf xilinx_libs
vlib xilinx_libs
echo ""
echo "${Green}--> Compiling PULPino Platform... ${NC}"
echo ""

# IP blocks
source ${PULP_PATH}/vsim/vcompile/vcompile_ips.csh  || exit 1
vivado -mode tcl -source tcl_files/xilinx_compile_simlib.tcl
rm -rf xilinx_libs/blk_mem_gen_v8_3_1
vlib xilinx_libs/blk_mem_gen_v8_3_1
vmap blk_mem_gen_v8_3_1 xilinx_libs/blk_mem_gen_v8_3_1
vcom -work xilinx_libs/blk_mem_gen_v8_3_1 /home/tools/xilinx/Vivado/2015.4/data/ip/xilinx/blk_mem_gen_v8_3/simulation/blk_mem_gen_v8_3.vhd
vcom -work xilinx_libs ../ips/xilinx_mem_8192x32/xilinx_mem_8192x32.srcs/sources_1/ip/xilinx_mem_8192x32/sim/xilinx_mem_8192x32.vhd
source ${PULP_PATH}/vsim/vcompile/rtl/vcompile_pulpino.sh  || exit 1
vlog -work $MSIM_LIBS_PATH/pulpino_lib ../rtl/pulpino_wrap.v
source ${PULP_PATH}/vsim/vcompile/rtl/vcompile_tb.sh       || exit 1

echo ""
echo "${Green}--> PULPino platform compilation complete! ${NC}"
echo ""
