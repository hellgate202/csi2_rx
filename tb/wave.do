onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider PHY
add wave -noupdate /tb_csi2/DUT/phy/dphy_clk_p_i
add wave -noupdate /tb_csi2/DUT/phy/dphy_clk_n_i
add wave -noupdate /tb_csi2/DUT/phy/dphy_data_p_i
add wave -noupdate /tb_csi2/DUT/phy/dphy_data_n_i
add wave -noupdate /tb_csi2/DUT/phy/ref_clk_i
add wave -noupdate /tb_csi2/DUT/phy/rst_i
add wave -noupdate /tb_csi2/DUT/phy/enable_i
add wave -noupdate /tb_csi2/DUT/phy/phy_rst_i
add wave -noupdate /tb_csi2/DUT/phy/rx_clk_present_o
add wave -noupdate /tb_csi2/DUT/phy/data_o
add wave -noupdate /tb_csi2/DUT/phy/clk_o
add wave -noupdate /tb_csi2/DUT/phy/valid_o
add wave -noupdate /tb_csi2/DUT/phy/bit_clk
add wave -noupdate /tb_csi2/DUT/phy/bit_clk_inv
add wave -noupdate /tb_csi2/DUT/phy/byte_clk
add wave -noupdate /tb_csi2/DUT/phy/rx_clk_present
add wave -noupdate /tb_csi2/DUT/phy/byte_data
add wave -noupdate /tb_csi2/DUT/phy/aligned_byte_data
add wave -noupdate /tb_csi2/DUT/phy/aligned_byte_valid
add wave -noupdate /tb_csi2/DUT/phy/reset_align
add wave -noupdate /tb_csi2/DUT/phy/word_data
add wave -noupdate /tb_csi2/DUT/phy/word_valid
add wave -noupdate -divider HEADER_CORRECTOR
add wave -noupdate /tb_csi2/DUT/header_corrector/clk_i
add wave -noupdate /tb_csi2/DUT/header_corrector/rst_i
add wave -noupdate /tb_csi2/DUT/header_corrector/valid_i
add wave -noupdate /tb_csi2/DUT/header_corrector/data_i
add wave -noupdate /tb_csi2/DUT/header_corrector/pkt_done_i
add wave -noupdate /tb_csi2/DUT/header_corrector/error_o
add wave -noupdate /tb_csi2/DUT/header_corrector/error_corrected_o
add wave -noupdate /tb_csi2/DUT/header_corrector/data_o
add wave -noupdate /tb_csi2/DUT/header_corrector/valid_o
add wave -noupdate /tb_csi2/DUT/header_corrector/generated_parity
add wave -noupdate /tb_csi2/DUT/header_corrector/syndrome
add wave -noupdate /tb_csi2/DUT/header_corrector/err_bit_pos
add wave -noupdate /tb_csi2/DUT/header_corrector/data_d
add wave -noupdate /tb_csi2/DUT/header_corrector/valid_d
add wave -noupdate /tb_csi2/DUT/header_corrector/header_valid
add wave -noupdate /tb_csi2/DUT/header_corrector/header_passed
add wave -noupdate /tb_csi2/DUT/header_corrector/error_detected
add wave -noupdate -divider AXI4_CONV
add wave -noupdate /tb_csi2/DUT/axi4_conv/clk_i
add wave -noupdate /tb_csi2/DUT/axi4_conv/rst_i
add wave -noupdate /tb_csi2/DUT/axi4_conv/data_i
add wave -noupdate /tb_csi2/DUT/axi4_conv/valid_i
add wave -noupdate /tb_csi2/DUT/axi4_conv/error_i
add wave -noupdate /tb_csi2/DUT/axi4_conv/phy_rst_o
add wave -noupdate /tb_csi2/DUT/axi4_conv/valid_d1
add wave -noupdate /tb_csi2/DUT/axi4_conv/pkt_running
add wave -noupdate /tb_csi2/DUT/axi4_conv/last_word
add wave -noupdate /tb_csi2/DUT/axi4_conv/header_valid
add wave -noupdate /tb_csi2/DUT/axi4_conv/short_pkt
add wave -noupdate /tb_csi2/DUT/axi4_conv/long_pkt
add wave -noupdate /tb_csi2/DUT/axi4_conv/byte_cnt
add wave -noupdate /tb_csi2/DUT/axi4_conv/byte_cnt_comb
add wave -noupdate -divider CSI2_PKT_IF
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/aclk
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/aresetn
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tvalid
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tready
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tdata
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tstrb
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tkeep
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tlast
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tid
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tdest
add wave -noupdate /tb_csi2/DUT/csi2_pkt_if/tuser
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {446956 ps} 0}
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
WaveRestoreZoom {0 ps} {5977125 ps}
