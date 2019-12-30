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

vmap xilinx_libs xilinx_libs
vmap secureip xilinx_libs/secureip
vmap unifast xilinx_libs/unifast
vmap unimacro xilinx_libs/unimacro
vmap unisim xilinx_libs/unisim

vmap unifast_ver xilinx_libs/unifast_ver
vmap unimacro_ver xilinx_libs/unimacro_ver
vmap unisim_ver xilinx_libs/unisims_ver

source ${PULP_PATH}/vsim/vcompile/rtl/vcompile_pulpino.sh  || exit 1
vlog -sv -work $MSIM_LIBS_PATH/pulpino_lib ../rtl/pulpino_wrap.v
vlog -work work spansion_spi_flash/S25fl128s/model/s25fl128s.v
vlog -sv -work $MSIM_LIBS_PATH/pulpino_lib ../rtl/arty_top.sv
source ${PULP_PATH}/vsim/vcompile/rtl/vcompile_tb.sh       || exit 1
vlog $XILINX_VIVADO/data/verilog/src/glbl.v

echo ""
echo "${Green}--> PULPino platform compilation complete! ${NC}"
echo ""
