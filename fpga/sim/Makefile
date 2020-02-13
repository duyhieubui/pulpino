../ips/arty_mmcm/ip/arty_mmcm.dcp:
	make -C ../ips/arty_mmcm
../ips/xilinx_mem_8192x32/ip/xilinx_mem_8192x32.dcp:
	make -C ../ips/xilinx_mem_8192x32
compile_simlib: ../ips/arty_mmcm/ip/arty_mmcm.dcp ../ips/xilinx_mem_8192x32/ip/xilinx_mem_8192x32.dcp
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
