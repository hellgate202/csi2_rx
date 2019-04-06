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
# set_property ip_repo_paths [list \
#   ../]                           \
# [current_project]
# update_ip_catalog -rebuild -scan_changes 
# report_ip_status -name ip_status

# Add Clock Wizard to create 74.25 MHz pixel clock
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property -dict [list                       \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {74.25}    \
  CONFIG.USE_LOCKED                 {false}    \
  CONFIG.USE_RESET                  {false}    \
  CONFIG.CLKIN1_JITTER_PS           {50.0}     \
  CONFIG.MMCM_DIVCLK_DIVIDE         {8}        \
  CONFIG.MMCM_CLKFBOUT_MULT_F       {37.125}   \
  CONFIG.MMCM_CLKIN1_PERIOD         {5.000}    \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F      {12.500}   \
  CONFIG.CLKOUT1_JITTER             {242.214}  \
  CONFIG.CLKOUT1_PHASE_ERROR        {245.344}] \
[get_bd_cells clk_wiz_0]

# Connect MMCM and PS
# connect_bd_net [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins processing_system7_0/FCLK_CLK0]
