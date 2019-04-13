# Start GUI
start_gui

# Project creation
create_project csi2_zybo_z7_example . -part xc7z020clg400-1

# Creating new block design
create_bd_design "csi2_zybo_z7_example"

# Adding ZYNQ-7000 Processing System
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 zynq_ps

# Congiguring PS
source ./zynq_config.tcl

# Make PS signals external
make_bd_intf_pins_external [list       \
  [get_bd_intf_pins zynq_ps/DDR]       \
  [get_bd_intf_pins zynq_ps/FIXED_IO]]

# Add local repository with CSI2 IP-core
set_property ip_repo_paths [list \
  ../]                           \
[current_project]
update_ip_catalog 

# Add Clock Wizard to create 74.25 MHz pixel clock
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 px_clk_mmcm
set_property -dict [list                       \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {74.25}    \
  CONFIG.USE_LOCKED                 {false}    \
  CONFIG.USE_RESET                  {false}]   \
[get_bd_cells px_clk_mmcm]

# Add Processing System Reset instances to synchronize resets
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ref_clk_rst
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 px_clk_rst

# Add CSI2-RX IP-core
create_bd_cell -type ip -vlnv hellgate:user:csi2_2_lane_rx:1.0 csi2_2_lane_rx

# Add JTAG-AXI Controller
create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi
set_property -dict [list CONFIG.PROTOCOL {2}] [get_bd_cells jtag_axi]

## Add AXI4-Interconnect to connect JTAG controller and CSI2 IP-core
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect
set_property -dict [list CONFIG.NUM_MI {2}] [get_bd_cells axi_interconnect]

# Connceting modules together
connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins px_clk_mmcm/clk_in1]
connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins csi2_2_lane_rx/ref_clk_i]
connect_bd_net [get_bd_pins zynq_ps/FCLK_CLK0] [get_bd_pins ref_clk_rst/slowest_sync_clk]
connect_bd_net [get_bd_pins zynq_ps/FCLK_RESET0_N] [get_bd_pins ref_clk_rst/ext_reset_in]
connect_bd_net [get_bd_pins zynq_ps/FCLK_RESET0_N] [get_bd_pins px_clk_rst/ext_reset_in]
connect_bd_net [get_bd_pins px_clk_mmcm/clk_out1] [get_bd_pins px_clk_rst/slowest_sync_clk]
connect_bd_net [get_bd_pins px_clk_mmcm/clk_out1] [get_bd_pins csi2_2_lane_rx/px_clk_i]
connect_bd_net [get_bd_pins px_clk_mmcm/clk_out1] [get_bd_pins jtag_axi/aclk]
connect_bd_net [get_bd_pins px_clk_mmcm/clk_out1] [get_bd_pins axi_interconnect/ACLK]
connect_bd_net [get_bd_pins px_clk_mmcm/clk_out1] [get_bd_pins axi_interconnect/S00_ACLK]
connect_bd_net [get_bd_pins px_clk_mmcm/clk_out1] [get_bd_pins axi_interconnect/M00_ACLK]
connect_bd_net [get_bd_pins px_clk_mmcm/clk_out1] [get_bd_pins axi_interconnect/M01_ACLK]
connect_bd_net [get_bd_pins ref_clk_rst/peripheral_reset] [get_bd_pins csi2_2_lane_rx/ref_srst_i]
connect_bd_net [get_bd_pins px_clk_rst/peripheral_aresetn] [get_bd_pins jtag_axi/aresetn]
connect_bd_net [get_bd_pins px_clk_rst/interconnect_aresetn] [get_bd_pins axi_interconnect/M00_ARESETN]
connect_bd_net [get_bd_pins px_clk_rst/interconnect_aresetn] [get_bd_pins axi_interconnect/M01_ARESETN]
connect_bd_net [get_bd_pins px_clk_rst/interconnect_aresetn] [get_bd_pins axi_interconnect/S00_ARESETN]
connect_bd_net [get_bd_pins px_clk_rst/interconnect_aresetn] [get_bd_pins axi_interconnect/ARESETN]
connect_bd_net [get_bd_pins px_clk_rst/peripheral_reset] [get_bd_pins csi2_2_lane_rx/px_srst_i]
connect_bd_intf_net [get_bd_intf_pins jtag_axi/M_AXI] -boundary_type upper [get_bd_intf_pins axi_interconnect/S00_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect/M00_AXI] [get_bd_intf_pins csi2_2_lane_rx/sccb_ctrl]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins axi_interconnect/M01_AXI] [get_bd_intf_pins csi2_2_lane_rx/csi2_csr]

make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/dphy_clk_p_i]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/dphy_clk_n_i]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/dphy_lp_clk_p_i]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/dphy_lp_clk_n_i]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/dphy_data_p_i]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/dphy_lp_data_p_i]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/dphy_data_n_i]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/dphy_lp_data_n_i]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/cam_pwup_o]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/sccb_scl_io]
make_bd_pins_external  [get_bd_pins csi2_2_lane_rx/sccb_sda_io]
make_bd_intf_pins_external  [get_bd_intf_pins csi2_2_lane_rx/video]
set_property CONFIG.FREQ_HZ {74250000} [get_bd_intf_ports video_0]

# Mapping slave address space
assign_bd_address [get_bd_addr_segs {csi2_2_lane_rx/sccb_ctrl/sccb_ctrl }]
set_property offset 0x00000000 [get_bd_addr_segs {jtag_axi/Data/SEG_csi2_2_lane_rx_sccb_ctrl}]
assign_bd_address [get_bd_addr_segs {csi2_2_lane_rx/csi2_csr/csi2_csr }]
set_property offset 0x00010000 [get_bd_addr_segs {jtag_axi/Data/SEG_csi2_2_lane_rx_csi2_csr}]

# Saving block design
regenerate_bd_layout
save_bd_design

# Create HDL Wraper
make_wrapper -files [get_files /home/liv/fpga/csi2/example/csi2_zybo_z7_example.srcs/sources_1/bd/csi2_zybo_z7_example/csi2_zybo_z7_example.bd] -top
add_files -norecurse /home/liv/fpga/csi2/example/csi2_zybo_z7_example.srcs/sources_1/bd/csi2_zybo_z7_example/hdl/csi2_zybo_z7_example_wrapper.v
update_compile_order -fileset sources_1

# Generate Output Products
#generate_target all [get_files  ./zybo_z7_video_proc.srcs/sources_1/bd/design_1/design_1.bd]
#catch { config_ip_cache -export [get_ips -all design_1_processing_system7_0_0] }
#catch { config_ip_cache -export [get_ips -all design_1_clk_wiz_0_0] }
#catch { config_ip_cache -export [get_ips -all design_1_proc_sys_reset_0_0] }
#catch { config_ip_cache -export [get_ips -all design_1_proc_sys_reset_1_0] }
#catch { config_ip_cache -export [get_ips -all design_1_proc_sys_reset_2_0] }
#catch { config_ip_cache -export [get_ips -all design_1_csi2_2_lane_rx_0_0] }
#catch { config_ip_cache -export [get_ips -all design_1_cci_master_0_0] }
#catch { config_ip_cache -export [get_ips -all design_1_jtag_axi_0_0] }
#export_ip_user_files -of_objects [get_files ./zybo_z7_video_proc.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
#create_ip_run [get_files -of_objects [get_fileset sources_1] ./zybo_z7_video_proc.srcs/sources_1/bd/design_1/design_1.bd]
#launch_runs -jobs 4 {                      \
#   design_1_processing_system7_0_0_synth_1 \
#   design_1_clk_wiz_0_0_synth_1            \
#   design_1_proc_sys_reset_0_0_synth_1     \
#   design_1_proc_sys_reset_1_0_synth_1     \
#   design_1_proc_sys_reset_2_0_synth_1     \
#   design_1_csi2_2_lane_rx_0_0_synth_1     \
#   design_1_cci_master_0_0_synth_1         \
#   design_1_jtag_axi_0_0_synth_1}
#wait_on_run design_1_processing_system7_0_0_synth_1
#wait_on_run design_1_clk_wiz_0_0_synth_1
#wait_on_run design_1_proc_sys_reset_0_0_synth_1
#wait_on_run design_1_proc_sys_reset_1_0_synth_1
#wait_on_run design_1_csi2_2_lane_rx_0_0_synth_1
#wait_on_run design_1_cci_master_0_0_synth_1
#wait_on_run design_1_jtag_axi_0_0_synth_1
#
## RTL Elaboration
#create_ip_run [get_files -of_objects [get_fileset sources_1] ./zybo_z7_video_proc.srcs/sources_1/bd/design_1/design_1.bd]
#synth_design -rtl -name rtl_1
#
## Pin placement
#place_ports {dphy_data_p_i_0[0]} M19
#place_ports {dphy_data_p_i_0[1]} L16
#place_ports dphy_clk_p_i_0       J18
#set_property IOSTANDARD LVDS_25 [get_ports [list \
#  {dphy_data_p_i_0[1]}                           \
#  {dphy_data_p_i_0[0]}                           \
#  dphy_clk_p_i_0]]
#place_ports {video_tdata_o_0[15]} V8
#place_ports {video_tdata_o_0[14]} W8
#place_ports {video_tdata_o_0[13]} U7
#place_ports {video_tdata_o_0[12]} V7
#place_ports {video_tdata_o_0[11]} Y7
#place_ports {video_tdata_o_0[10]} Y6
#place_ports {video_tdata_o_0[9]}  V6
#place_ports {video_tdata_o_0[8]}  W6
#place_ports {video_tdata_o_0[7]}  V15
#place_ports {video_tdata_o_0[6]}  W15
#place_ports {video_tdata_o_0[5]}  T11
#place_ports {video_tdata_o_0[4]}  T10
#place_ports {video_tdata_o_0[3]}  W14
#place_ports {video_tdata_o_0[3]}  Y14
#place_ports {video_tdata_o_0[2]}  T12
#place_ports {video_tdata_o_0[1]}  U12
#place_ports {video_tdata_o_0[0]}  T14
#place_ports {video_tkeep_o_0[1]}  T15
#place_ports {video_tkeep_o_0[0]}  P14
#place_ports {video_tstrb_o_0[1]}  R14
#place_ports {video_tstrb_o_0[0]}  U14
#place_ports video_tdest_o_0       U15
#place_ports video_tid_o_0         V17
#place_ports video_tlast_o_0       V18
#place_ports video_tready_i_0      G15
#place_ports video_tuser_o_0       W16
#place_ports video_tvalid_o_0      J15
#place_ports sda_io_0              F19
#place_ports scl_io_0              F20
#place_ports cam_pwup_o_0          G20
#set_property IOSTANDARD LVCMOS33 [get_ports [list \
#  {video_tdata_o_0[15]}                           \
#  {video_tdata_o_0[14]}                           \
#  {video_tdata_o_0[13]}                           \
#  {video_tdata_o_0[12]}                           \
#  {video_tdata_o_0[11]}                           \
#  {video_tdata_o_0[10]}                           \
#  {video_tdata_o_0[9]}                            \
#  {video_tdata_o_0[8]}                            \
#  {video_tdata_o_0[7]}                            \
#  {video_tdata_o_0[6]}                            \
#  {video_tdata_o_0[5]}                            \
#  {video_tdata_o_0[4]}                            \
#  {video_tdata_o_0[3]}                            \
#  {video_tdata_o_0[2]}                            \
#  {video_tdata_o_0[1]}                            \
#  {video_tdata_o_0[0]}                            \
#  {video_tkeep_o_0[1]}                            \
#  {video_tkeep_o_0[0]}                            \
#  {video_tstrb_o_0[1]}                            \
#  {video_tstrb_o_0[0]}                            \
#  video_tvalid_o_0                                \
#  video_tdest_o_0                                 \
#  video_tid_o_0                                   \
#  video_tlast_o_0                                 \
#  video_tready_i_0                                \
#  video_tuser_o_0                                 \
#  sda_io_0                                        \
#  scl_io_0                                        \
#  cam_pwup_o_0]]
#set_property DIFF_TERM false [get_ports dphy_data_p_i_0[0]]
#set_property DIFF_TERM false [get_ports dphy_data_p_i_0[1]]
#set_property DIFF_TERM false [get_ports dphy_clk_p_i_0]
#place_ports dphy_lp_clk_p_i_0       H20
#place_ports dphy_lp_clk_n_i_0       J19
#place_ports {dphy_lp_data_p_i_0[0]} L19
#place_ports {dphy_lp_data_p_i_0[1]} J20
#place_ports {dphy_lp_data_n_i_0[0]} M18
#place_ports {dphy_lp_data_n_i_0[1]} L20
#set_property IOSTANDARD HSUL_12 [get_ports [list \
#  dphy_lp_clk_p_i_0                              \
#  dphy_lp_clk_n_i_0                              \
#  {dphy_lp_data_p_i_0[0]}                        \
#  {dphy_lp_data_p_i_0[1]}                        \
#  {dphy_lp_data_n_i_0[0]}                        \
#  {dphy_lp_data_n_i_0[1]}]]
#set_property INTERNAL_VREF 0.6 [get_iobanks 35]
#
## Creating directory for constraints
#file mkdir ./zybo_z7_video_proc.srcs/constrs_1/new
#
## Creating constraints file
#close [ open ./zybo_z7_video_proc.srcs/constrs_1/new/zybo_z7_video_proc.xdc w ]
#
## Adding this file to project
#close [ open ./zybo_z7_video_proc.srcs/constrs_1/new/zybo_z7_video_proc.xdc w ]
#
## Setting this file as target constraint
#set_property target_constrs_file ./zybo_z7_video_proc.srcs/constrs_1/new/zybo_z7_video_proc.xdc [current_fileset -constrset]
#
## Saving previous constraints to file
#save_constraints -force
#
## Timing constraints
#create_clock -period 2.976 -name dphy_clk -waveform {0.000 1.488} [get_ports dphy_clk_p_i_0]
#
#set_false_path -from [get_clocks [list                              \
#  [get_clocks -of_objects                                           \
#  [get_pins design_1_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]]] -to \
#  [get_clocks design_1_i/clk_wiz_0/inst/clk_in1]
#
#set_false_path -from [get_clocks [list                              \
#  [get_clocks -of_objects                                           \
#  [get_pins design_1_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]]] -to \
#  [get_clocks design_1_i/clk_wiz_0/inst/clk_in1] 
#
#set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks [list                 \
#  [get_clocks -of_objects                                                          \
#  [get_pins design_1_i/csi2_2_lane_rx_0/inst/csi2_rx/phy/clk_phy/clk_divider/O]]]]
#
#set_false_path -from [get_clocks [list                                                 \
#  [get_clocks -of_objects                                                              \
#  [get_pins design_1_i/csi2_2_lane_rx_0/inst/csi2_rx/phy/clk_phy/clk_divider/O]]]] -to \
#  [get_clocks clk_fpga_0]                                                              
#
#set_false_path -from [get_clocks [list                                             \
#  [get_clocks -of_objects                                                          \
#  [get_pins design_1_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]]] -to                \
#  [get_clocks [list                                                                \
#  [get_clocks -of_objects                                                          \
#  [get_pins design_1_i/csi2_2_lane_rx_0/inst/csi2_rx/phy/clk_phy/clk_divider/O]]]] 
#
#set_false_path -from [get_clocks [list                                                 \
#  [get_clocks -of_objects                                                              \
#  [get_pins design_1_i/csi2_2_lane_rx_0/inst/csi2_rx/phy/clk_phy/clk_divider/O]]]] -to \
#  [get_clocks [list                                                                    \
#  [get_clocks -of_objects [get_pins design_1_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]]]
#
#save_constraints -force
#
## Run Synthesis
#launch_runs synth_1 -jobs 4
#wait_on_run synth_1
#
## Generate bitstream
#launch_runs impl_1 -to_step write_bitstream -jobs 4
#wait_on_run impl_1
#
## Export Hardware
#file mkdir ./zybo_z7_video_proc.sdk
#file copy -force ./zybo_z7_video_proc.runs/impl_1/design_1_wrapper.sysdef ./zybo_z7_video_proc.sdk/design_1_wrapper.hdf
#
#exit
