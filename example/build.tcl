# Project creation
create_project csi2_example . -part xc7z020clg400-1
# Creating new block design
create_bd_design "design_1"
# Adding ZYNQ-7000 Processing System
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
# Congiguring PS
source ./zynq_config.tcl
