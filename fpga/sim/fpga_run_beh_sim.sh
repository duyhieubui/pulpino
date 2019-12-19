export VSIM_DIR=.
export USE_ZERO_RISCY=0
export RISCY_RV32F=0
export ZERO_RV32M=0
export ZERO_RV32E=0
export PL_NETLIST=""
export TB_TEST=""
vsim -c -64 -do 'source tcl_files/run_spi.tcl; run -a; exit;'
