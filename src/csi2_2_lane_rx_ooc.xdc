# From DPHY clock to system clock (pixel clock)
# To CSR statistics from DPHY
set_false_path -from [get_pins csi2_rx/header_corrector/error_corrected_o_reg/C] -to [get_pins csi2_stat_acc/corr_header_err_d1_reg/D]
set_false_path -from [get_pins csi2_rx/header_corrector/error_o_reg/C] -to [get_pins csi2_stat_acc/header_err_d1_reg/D]
set_false_path -from [get_pins csi2_rx/crc_calc/crc_failed_o_reg/C] -to [get_pins csi2_stat_acc/crc_err_d1_reg/D]
# CDC in DCFIFO
set_false_path -from [get_pins csi2_rx/dphy_int_cdc/wr_ptr_gray_wr_clk_reg[*]/C] -to [get_pins csi2_rx/dphy_int_cdc/wr_ptr_gray_rd_clk_reg[*]/D]
# CDC in frequency measurer
set_false_path -from [get_pins csi2_stat_acc/dphy_byte_clk_meas/meas_cnt_gray_reg[*]/C] -to [get_pins csi2_stat_acc/dphy_byte_clk_meas/meas_cnt_gray_ref_clk_reg[*]/D]

# From DPHY clock to reference clock
# DPHY clock detector
set_false_path -from [get_pins csi2_rx/phy/clk_detect/toggle_bit_reg/C] -to [get_pins csi2_rx/phy/clk_detect/toggle_bit_s1_reg/D]

# From system clock to DPHY clock
# DPHY enablement from CSR
set_false_path -from [get_pins csi2_csr/cr_reg[1][0]/C] -to [get_pins csi2_rx/axi4_conv/enable_d1_reg/D]
# CDC in DCFIFO
set_false_path -from [get_pins csi2_rx/dphy_int_cdc/rd_ptr_gray_rd_clk_reg[*]/C] -to [get_pins csi2_rx/dphy_int_cdc/rd_ptr_gray_wr_clk_reg[*]/D]
# 1 second strobe running at system clock to FPS measurer
set_false_path -from [get_pins csi2_stat_acc/dphy_byte_clk_meas/sec_stb_cdc/stb_i_lock_reg/C] -to [get_pins csi2_stat_acc/dphy_byte_clk_meas/sec_stb_cdc/stb_sync_reg[0]/D]

# From reference clock to DPHY clock
# After LP transition detection to flag that HS data is valid
set_false_path -from [get_pins csi2_rx/phy/byte_align[*].settle_ignore/hs_data_valid_o_reg/C] -to [get_pins csi2_rx/phy/hs_data_valid_d1_reg[*]/D]

# Reset CDC
set_false_path -from [get_pins csi2_stat_acc/dphy_byte_clk_meas/sec_stb_cdc/stb_sync_reg[0]/C] -to [get_pins csi2_stat_acc/dphy_byte_clk_meas/sec_stb_cdc/stb_deasset/rst_d_reg[*]/PRE]
set_false_path -from [get_pins csi2_rx/phy/clk_detect/clk_presence_cnt_reg[*]/C] -to [get_pins csi2_rx/phy/clk_loss_rst_d1_reg/PRE]
set_false_path -from [get_pins csi2_rx/phy/clk_detect/clk_presence_cnt_reg[*]/C] -to [get_pins csi2_rx/phy/clk_loss_rst_d2_reg/PRE]

# DCFIFO reset synchronization
set_false_path -to [get_pins csi2_rx/dphy_int_cdc/rst_wr_clk_d1_reg/PRE]
set_false_path -to [get_pins csi2_rx/dphy_int_cdc/rst_wr_clk_d2_reg/PRE]
set_false_path -to [get_pins csi2_rx/dphy_int_cdc/rst_rd_clk_d1_reg/PRE]
set_false_path -to [get_pins csi2_rx/dphy_int_cdc/rst_rd_clk_d2_reg/PRE]

# Frequency measure reset synchronization
set_false_path -to [get_pins {csi2_stat_acc/dphy_byte_clk_meas/meas_rst_sync/rst_d_reg[*]/PRE}]

# ASYNC_REG property to synchronizers
set_property ASYNC_REG true [get_cells {csi2_rx/phy/hs_data_valid_d1_reg[*]}]
set_property ASYNC_REG true [get_cells {csi2_rx/phy/hs_data_valid_d2_reg[*]}]
set_property ASYNC_REG true [get_cells csi2_rx/phy/clk_loss_rst_d1_reg]
set_property ASYNC_REG true [get_cells csi2_rx/phy/clk_loss_rst_d2_reg]
set_property ASYNC_REG true [get_cells {csi2_rx/dphy_int_cdc/wr_ptr_gray_rd_clk_reg[*]}]
set_property ASYNC_REG true [get_cells {csi2_rx/dphy_int_cdc/wr_ptr_gray_rd_clk_mtstb_reg[*]}]
set_property ASYNC_REG true [get_cells {csi2_rx/dphy_int_cdc/rd_ptr_gray_wr_clk_reg[*]}]
set_property ASYNC_REG true [get_cells {csi2_rx/dphy_int_cdc/rd_ptr_gray_wr_clk_mtstb_reg[*]}]
set_property ASYNC_REG true [get_cells csi2_rx/dphy_int_cdc/rst_wr_clk_d1_reg]
set_property ASYNC_REG true [get_cells csi2_rx/dphy_int_cdc/rst_wr_clk_d2_reg]
set_property ASYNC_REG true [get_cells csi2_rx/dphy_int_cdc/rst_rd_clk_d1_reg]
set_property ASYNC_REG true [get_cells csi2_rx/dphy_int_cdc/rst_rd_clk_d2_reg]
set_property ASYNC_REG true [get_cells csi2_rx/axi4_conv/enable_d1_reg]
set_property ASYNC_REG true [get_cells csi2_rx/axi4_conv/enable_d2_reg]
set_property ASYNC_REG true [get_cells csi2_rx/phy/clk_detect/toggle_bit_s1_reg]
set_property ASYNC_REG true [get_cells csi2_rx/phy/clk_detect/toggle_bit_s2_reg]
set_property ASYNC_REG true [get_cells csi2_rx/phy/clk_detect/toggle_bit_s3_reg]
set_property ASYNC_REG true [get_cells csi2_stat_acc/crc_err_d1_reg]
set_property ASYNC_REG true [get_cells csi2_stat_acc/crc_err_d2_reg]
set_property ASYNC_REG true [get_cells csi2_stat_acc/corr_header_err_d1_reg]
set_property ASYNC_REG true [get_cells csi2_stat_acc/corr_header_err_d2_reg]
set_property ASYNC_REG true [get_cells csi2_stat_acc/header_err_d1_reg]
set_property ASYNC_REG true [get_cells csi2_stat_acc/header_err_d2_reg]
set_property ASYNC_REG true [get_cells {sccb_master/i2c_master_phy/mstb_scl_reg[*]}]
set_property ASYNC_REG true [get_cells {sccb_master/i2c_master_phy/mstb_sda_reg[*]}]
