build:
	git clean -fdx
	vivado -mode tcl -source build.tcl
	xsdk -batch -source sdk.tcl
prog:
	program_flash -f ./BOOT.bin -offset 0 -flash_type qspi-x4-single       \
	-fsbl ./csi2_zybo_z7_example.sdk/zybo_fsbl/Debug/zybo_fsbl.elf         \
	-blank_check -verify -cable type xilinx_tcf url TCP:127.0.0.1:3121 esn \
	Digilent/210351A6C9FAA/ -debugdevice deviceNr 2
.PHONY: build prog
