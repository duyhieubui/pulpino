compile_simlib:
	tcsh ./vcompile/build_fpga_simlib.sh

vcompile.fpga:
	tcsh ./vcompile/build_fpga_sim.csh

run:
	bash fpga_run_beh_sim.sh

clean:
	-rm -rf *.log
	-rm -rf *.bak
	-rm -rf *.jou
	-rm -rf *.wlf
	-rm -rf modelsim_libs
	-rm -rf xilinx_libs
	-rm -rf work
	-rm -rf *.vstf
