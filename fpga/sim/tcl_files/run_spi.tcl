#!/bin/bash
# \
exec vsim -64 -do "$0"

set TB            tb
set TB_TEST       ""
set VSIM_FLAGS    "-GTEST=\"$TB_TEST\""
# set MEMLOAD       "SPI"
set MEMLOAD       "STANDALONE"

source ./tcl_files/config/vsim.tcl
