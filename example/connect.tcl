open_project csi2_zybo_z7_example.xpr
open_hw
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210351A6C9FAA]
set_property PARAM.FREQUENCY 30000000 [get_hw_targets */xilinx_tcf/Digilent/210351A6C9FAA]
open_hw_target
set_property PROGRAM.FILE {./csi2_zybo_z7_example.runs/impl_1/csi2_zybo_z7_example_wrapper.bit} [get_hw_devices xc7z020_1]
set_property PROBES.FILE {./csi2_zybo_z7_example.runs/impl_1/csi2_zybo_z7_example_wrapper.ltx} [get_hw_devices xc7z020_1]
set_property FULL_PROBES.FILE {./csi2_zybo_z7_example.runs/impl_1/csi2_zybo_z7_example_wrapper.ltx} [get_hw_devices xc7z020_1]
current_hw_device [get_hw_devices xc7z020_1]
refresh_hw_device [lindex [get_hw_devices xc7z020_1] 0]
source ./ov5640_jtag_setup.tcl

