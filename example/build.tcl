# Start GUI
start_gui

# Project creation
create_project csi2_example . -part xc7z020clg400-1

# Creating new block design
create_bd_design "design_1"

# Adding ZYNQ-7000 Processing System
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0

# Congiguring PS
source ./zynq_config.tcl

# Make PS signals external
make_bd_intf_pins_external [list                    \
  [get_bd_intf_pins processing_system7_0/DDR]       \
  [get_bd_intf_pins processing_system7_0/FIXED_IO]]

# Add local repository with CSI2 IP-core
set_property ip_repo_paths [list \
  ../]                           \
[current_project]
update_ip_catalog 

# Add Clock Wizard to create 74.25 MHz pixel clock
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property -dict [list                       \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {74.25}    \
  CONFIG.USE_LOCKED                 {false}    \
  CONFIG.USE_RESET                  {false}]   \
[get_bd_cells clk_wiz_0]

# Add Processing System Reset instances to synchronize resets
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1

# Add CSI2-RX IP-core
create_bd_cell -type ip -vlnv hellgate202:user:csi2_2_lane_rx:1.0 csi2_2_lane_rx_0

# Connceting modules together
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins clk_wiz_0/clk_in1]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins csi2_2_lane_rx_0/ref_clk_i]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins proc_sys_reset_1/ext_reset_in]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins csi2_2_lane_rx_0/px_clk_i]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_reset] [get_bd_pins csi2_2_lane_rx_0/ref_srst_i]
connect_bd_net [get_bd_pins proc_sys_reset_1/peripheral_reset] [get_bd_pins csi2_2_lane_rx_0/px_srst_i]

# Making dphy and video
make_bd_pins_external [list                     \
  [get_bd_pins csi2_2_lane_rx_0/dphy_clk_p_i]   \
  [get_bd_pins csi2_2_lane_rx_0/dphy_clk_n_i]   \
  [get_bd_pins csi2_2_lane_rx_0/dphy_data_p_i]  \
  [get_bd_pins csi2_2_lane_rx_0/dphy_data_n_i]  \
  [get_bd_pins csi2_2_lane_rx_0/video_tvalid_o] \
  [get_bd_pins csi2_2_lane_rx_0/video_tlast_o]  \
  [get_bd_pins csi2_2_lane_rx_0/video_tready_i] \
  [get_bd_pins csi2_2_lane_rx_0/video_tid_o]    \
  [get_bd_pins csi2_2_lane_rx_0/video_tdest_o]  \
  [get_bd_pins csi2_2_lane_rx_0/video_tstrb_o]  \
  [get_bd_pins csi2_2_lane_rx_0/video_tuser_o]  \
  [get_bd_pins csi2_2_lane_rx_0/video_tkeep_o]  \
  [get_bd_pins csi2_2_lane_rx_0/video_tdata_o]]

# Saving block design
regenerate_bd_layout
save_bd_design

# Create HDL Wraper
make_wrapper -files [get_files /home/liv/fpga/csi2/example/csi2_example.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse /home/liv/fpga/csi2/example/csi2_example.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
update_compile_order -fileset sources_1

# Generate Output Products
generate_target all [get_files  /home/liv/fpga/csi2/example/csi2_example.srcs/sources_1/bd/design_1/design_1.bd]
catch { config_ip_cache -export [get_ips -all design_1_processing_system7_0_0] }
catch { config_ip_cache -export [get_ips -all design_1_clk_wiz_0_0] }
catch { config_ip_cache -export [get_ips -all design_1_proc_sys_reset_0_0] }
catch { config_ip_cache -export [get_ips -all design_1_proc_sys_reset_1_0] }
catch { config_ip_cache -export [get_ips -all design_1_csi2_2_lane_rx_0_0] }
export_ip_user_files -of_objects [get_files ./csi2_example.srcs/sources_1/bd/design_1/design_1.bd] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ./csi2_example.srcs/sources_1/bd/design_1/design_1.bd]
launch_runs -jobs 8 {                      \
   design_1_processing_system7_0_0_synth_1 \
   design_1_clk_wiz_0_0_synth_1            \
   design_1_proc_sys_reset_0_0_synth_1     \
   design_1_proc_sys_reset_1_0_synth_1     \
   design_1_csi2_2_lane_rx_0_0_synth_1}
wait_on_run design_1_processing_system7_0_0_synth_1
wait_on_run design_1_clk_wiz_0_0_synth_1
wait_on_run design_1_proc_sys_reset_0_0_synth_1
wait_on_run design_1_proc_sys_reset_1_0_synth_1
wait_on_run design_1_csi2_2_lane_rx_0_0_synth_1

# RTL Elaboration
create_ip_run [get_files -of_objects [get_fileset sources_1] /home/liv/fpga/csi2/example/csi2_example.srcs/sources_1/bd/design_1/design_1.bd]
synth_design -rtl -name rtl_1

# Pin placement
place_ports {dphy_data_p_i_0[0]} M19
place_ports {dphy_data_p_i_0[1]} L16
place_ports dphy_clk_p_i_0       J18
set_property IOSTANDARD LVDS_25 [get_ports [list \
  {dphy_data_p_i_0[1]}                           \
  {dphy_data_p_i_0[0]}                           \
  dphy_clk_p_i_0]]
place_ports {video_tdata_o_0[15]} V8
place_ports {video_tdata_o_0[14]} W8
place_ports {video_tdata_o_0[13]} U7
place_ports {video_tdata_o_0[12]} V7
place_ports {video_tdata_o_0[11]} Y7
place_ports {video_tdata_o_0[10]} Y6
place_ports {video_tdata_o_0[9]}  V6
place_ports {video_tdata_o_0[8]}  W6
place_ports {video_tdata_o_0[7]}  V15
place_ports {video_tdata_o_0[6]}  W15
place_ports {video_tdata_o_0[5]}  T11
place_ports {video_tdata_o_0[4]}  T10
place_ports {video_tdata_o_0[3]}  W14
place_ports {video_tdata_o_0[3]}  Y14
place_ports {video_tdata_o_0[2]}  T12
place_ports {video_tdata_o_0[1]}  U12
place_ports {video_tdata_o_0[0]}  T14
place_ports {video_tkeep_o_0[1]}  T15
place_ports {video_tkeep_o_0[0]}  P14
place_ports {video_tstrb_o_0[1]}  R14
place_ports {video_tstrb_o_0[0]}  U14
place_ports video_tdest_o_0       U15
place_ports video_tid_o_0         V17
place_ports video_tlast_o_0       V18
place_ports video_tready_i_0      V12
place_ports video_tuser_o_0       W16
place_ports video_tvalid_o_0      J15
set_property IOSTANDARD LVCMOS33 [get_ports [list \
  {video_tdata_o_0[15]}                           \
  {video_tdata_o_0[14]}                           \
  {video_tdata_o_0[13]}                           \
  {video_tdata_o_0[12]}                           \
  {video_tdata_o_0[11]}                           \
  {video_tdata_o_0[10]}                           \
  {video_tdata_o_0[9]}                            \
  {video_tdata_o_0[8]}                            \
  {video_tdata_o_0[7]}                            \
  {video_tdata_o_0[6]}                            \
  {video_tdata_o_0[5]}                            \
  {video_tdata_o_0[4]}                            \
  {video_tdata_o_0[3]}                            \
  {video_tdata_o_0[2]}                            \
  {video_tdata_o_0[1]}                            \
  {video_tdata_o_0[0]}                            \
  {video_tkeep_o_0[1]}                            \
  {video_tkeep_o_0[0]}                            \
  {video_tstrb_o_0[1]}                            \
  {video_tstrb_o_0[0]}                            \
  video_tvalid_o_0                                \
  video_tdest_o_0                                 \
  video_tid_o_0                                   \
  video_tlast_o_0                                 \
  video_tready_i_0                                \
  video_tuser_o_0]]
set_property DIFF_TERM false [get_ports dphy_data_p_i_0[0]]
set_property DIFF_TERM false [get_ports dphy_data_p_i_0[1]]
set_property DIFF_TERM false [get_ports dphy_clk_p_i_0]

# Creating directory for constraints
file mkdir /home/liv/fpga/csi2/example/csi2_example.srcs/constrs_1/new

# Creating constraints file
close [ open /home/liv/fpga/csi2/example/csi2_example.srcs/constrs_1/new/csi2_example.xdc w ]

# Adding this file to project
close [ open /home/liv/fpga/csi2/example/csi2_example.srcs/constrs_1/new/csi2_example.xdc w ]

# Setting this file as target constraint
set_property target_constrs_file /home/liv/fpga/csi2/example/csi2_example.srcs/constrs_1/new/csi2_example.xdc [current_fileset -constrset]

# Saving previous constraints to file
save_constraints -force

# Timing constraints
create_clock -period 2.976 -name dphy_clk -waveform {0.000 1.488} [get_ports dphy_clk_p_i_0]

set_false_path -from [get_clocks [list                              \
  [get_clocks -of_objects                                           \
  [get_pins design_1_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]]] -to \
  [get_clocks design_1_i/clk_wiz_0/inst/clk_in1]

set_false_path -from [get_clocks [list                              \
  [get_clocks -of_objects                                           \
  [get_pins design_1_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]]] -to \
  [get_clocks design_1_i/clk_wiz_0/inst/clk_in1] 

set_false_path -from [get_clocks clk_fpga_0] -to [get_clocks [list                 \
  [get_clocks -of_objects                                                          \
  [get_pins design_1_i/csi2_2_lane_rx_0/inst/csi2_rx/phy/clk_phy/clk_divider/O]]]]

set_false_path -from [get_clocks [list                                                 \
  [get_clocks -of_objects                                                              \
  [get_pins design_1_i/csi2_2_lane_rx_0/inst/csi2_rx/phy/clk_phy/clk_divider/O]]]] -to \
  [get_clocks clk_fpga_0]                                                              

set_false_path -from [get_clocks [list                                             \
  [get_clocks -of_objects                                                          \
  [get_pins design_1_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]]] -to                \
  [get_clocks [list                                                                \
  [get_clocks -of_objects                                                          \
  [get_pins design_1_i/csi2_2_lane_rx_0/inst/csi2_rx/phy/clk_phy/clk_divider/O]]]] 

set_false_path -from [get_clocks [list                                                 \
  [get_clocks -of_objects                                                              \
  [get_pins design_1_i/csi2_2_lane_rx_0/inst/csi2_rx/phy/clk_phy/clk_divider/O]]]] -to \
  [get_clocks [list                                                                    \
  [get_clocks -of_objects [get_pins design_1_i/clk_wiz_0/inst/mmcm_adv_inst/CLKOUT0]]]]

save_constraints -force

# Run Synthesis
launch_runs synth_1 -jobs 8
wait_on_run synth_1

# Run Implementation
launch_runs impl_1
wait_on_run impl_1 

# Generate bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1

# Export Hardware
file mkdir ./csi2_example.sdk
file copy -force ./csi2_example.runs/impl_1/design_1_wrapper.sysdef ./csi2_example.sdk/design_1_wrapper.hdf
