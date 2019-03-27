onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider PHY
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/dphy_clk_p_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/dphy_clk_n_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/dphy_data_p_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/dphy_data_n_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/ref_clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/enable_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/phy_rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/rx_clk_present_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/data_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/clk_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/valid_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/bit_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/bit_clk_inv
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/byte_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/rx_clk_present
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/byte_data
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/aligned_byte_data
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/aligned_byte_valid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/reset_align
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/word_data
add wave -noupdate -radix hexadecimal /tb_csi2/dut/phy/word_valid
add wave -noupdate -divider HEADER_CORRECTOR
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/valid_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/data_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/pkt_done_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/error_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/error_corrected_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/data_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/valid_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/generated_parity
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/syndrome
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/err_bit_pos
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/data_d
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/valid_d
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/header_valid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/header_passed
add wave -noupdate -radix hexadecimal /tb_csi2/dut/header_corrector/error_detected
add wave -noupdate -divider AXI4_CONV
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/data_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/valid_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/error_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/phy_rst_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/valid_d1
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/pkt_running
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/last_word
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/header_valid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/short_pkt
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/long_pkt
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/byte_cnt
add wave -noupdate -divider CSI2_PKT_IF_RX_CLK
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/aclk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/aresetn
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tvalid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tready
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tdata
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tstrb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tkeep
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tlast
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tdest
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_rx_clk_if/tuser
add wave -noupdate -divider DC_FIFO
add wave -noupdate -radix hexadecimal /tb_csi2/dut/axi4_conv/byte_cnt_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_data_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_used_words_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_full_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_empty_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_data_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_used_words_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_full_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_empty_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_req
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_used_words
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_full
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_empty
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_wr_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_gray_wr_clk_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_gray_wr_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_gray_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_gray_rd_clk_mtstb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_rd_clk_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_addr
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_req
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_used_words
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_full
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_empty
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_gray_rd_clk_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_gray_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_gray_wr_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_gray_wr_clk_mtstb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_wr_clk_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_wr_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_addr
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_en
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/data_in_mem
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/data_at_output
add wave -noupdate -divider CSI2_PKT_PX_CLK_IF
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/aclk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/aresetn
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tvalid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tready
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tdata
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tstrb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tkeep
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tlast
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tdest
add wave -noupdate -radix hexadecimal /tb_csi2/dut/csi2_pkt_px_clk_if/tuser
add wave -noupdate -divider PKT_HANDLER
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/frame_start_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/frame_end_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/state
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/next_state
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/byte_cnt
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_size
add wave -noupdate -divider PAYLOAD_IF
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/aclk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/aresetn
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tvalid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tready
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tdata
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tstrb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tkeep
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tlast
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tdest
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tuser
add wave -noupdate -divider GBX
add wave -noupdate -radix hexadecimal /tb_csi2/dut/gbx/clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/gbx/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/gbx/tdata_d1
add wave -noupdate -radix hexadecimal /tb_csi2/dut/gbx/tstrb_d1
add wave -noupdate -radix hexadecimal /tb_csi2/dut/gbx/state
add wave -noupdate -radix hexadecimal /tb_csi2/dut/gbx/next_state
add wave -noupdate -divider PAYLOAD_40B_IF
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/aclk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/aresetn
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tvalid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tready
add wave -noupdate -radix hexadecimal -childformat {{{/tb_csi2/dut/payload_40b_if/tdata[39]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[38]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[37]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[36]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[35]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[34]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[33]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[32]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[31]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[30]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[29]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[28]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[27]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[26]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[25]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[24]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[23]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[22]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[21]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[20]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[19]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[18]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[17]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[16]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[15]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[14]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[13]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[12]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[11]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[10]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[9]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[8]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[7]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[6]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[5]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[4]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[3]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[2]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[1]} -radix hexadecimal} {{/tb_csi2/dut/payload_40b_if/tdata[0]} -radix hexadecimal}} -subitemconfig {{/tb_csi2/dut/payload_40b_if/tdata[39]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[38]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[37]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[36]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[35]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[34]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[33]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[32]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[31]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[30]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[29]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[28]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[27]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[26]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[25]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[24]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[23]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[22]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[21]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[20]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[19]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[18]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[17]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[16]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[15]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[14]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[13]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[12]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[11]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[10]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[9]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[8]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[7]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[6]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[5]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[4]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[3]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[2]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[1]} {-height 16 -radix hexadecimal} {/tb_csi2/dut/payload_40b_if/tdata[0]} {-height 16 -radix hexadecimal}} /tb_csi2/dut/payload_40b_if/tdata
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tstrb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tkeep
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tlast
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tid
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tdest
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tuser
add wave -noupdate -divider PX_SER
add wave -noupdate -radix hexadecimal /tb_csi2/dut/px_ser/clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/px_ser/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/px_ser/frame_start_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/px_ser/state
add wave -noupdate -radix hexadecimal /tb_csi2/dut/px_ser/next_state
add wave -noupdate -divider VIDEO
add wave -noupdate -radix hexadecimal /tb_csi2/video/aclk
add wave -noupdate -radix hexadecimal /tb_csi2/video/aresetn
add wave -noupdate -radix hexadecimal /tb_csi2/video/tvalid
add wave -noupdate -radix hexadecimal /tb_csi2/video/tready
add wave -noupdate -radix hexadecimal /tb_csi2/video/tdata
add wave -noupdate -radix hexadecimal /tb_csi2/video/tstrb
add wave -noupdate -radix hexadecimal /tb_csi2/video/tkeep
add wave -noupdate -radix hexadecimal /tb_csi2/video/tlast
add wave -noupdate -radix hexadecimal /tb_csi2/video/tid
add wave -noupdate -radix hexadecimal /tb_csi2/video/tdest
add wave -noupdate -radix hexadecimal /tb_csi2/video/tuser
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6571481 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 559
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {616229944 ps}
