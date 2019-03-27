onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider PHY
add wave -noupdate /tb_csi2/dut/phy/dphy_clk_p_i
add wave -noupdate /tb_csi2/dut/phy/dphy_clk_n_i
add wave -noupdate /tb_csi2/dut/phy/dphy_data_p_i
add wave -noupdate /tb_csi2/dut/phy/dphy_data_n_i
add wave -noupdate /tb_csi2/dut/phy/ref_clk_i
add wave -noupdate /tb_csi2/dut/phy/rst_i
add wave -noupdate /tb_csi2/dut/phy/enable_i
add wave -noupdate /tb_csi2/dut/phy/phy_rst_i
add wave -noupdate /tb_csi2/dut/phy/rx_clk_present_o
add wave -noupdate /tb_csi2/dut/phy/data_o
add wave -noupdate /tb_csi2/dut/phy/clk_o
add wave -noupdate /tb_csi2/dut/phy/valid_o
add wave -noupdate /tb_csi2/dut/phy/bit_clk
add wave -noupdate /tb_csi2/dut/phy/bit_clk_inv
add wave -noupdate /tb_csi2/dut/phy/byte_clk
add wave -noupdate /tb_csi2/dut/phy/rx_clk_present
add wave -noupdate /tb_csi2/dut/phy/byte_data
add wave -noupdate /tb_csi2/dut/phy/aligned_byte_data
add wave -noupdate /tb_csi2/dut/phy/aligned_byte_valid
add wave -noupdate /tb_csi2/dut/phy/reset_align
add wave -noupdate /tb_csi2/dut/phy/word_data
add wave -noupdate /tb_csi2/dut/phy/word_valid
add wave -noupdate -divider HEADER_CORRECTOR
add wave -noupdate /tb_csi2/dut/header_corrector/clk_i
add wave -noupdate /tb_csi2/dut/header_corrector/rst_i
add wave -noupdate /tb_csi2/dut/header_corrector/valid_i
add wave -noupdate /tb_csi2/dut/header_corrector/data_i
add wave -noupdate /tb_csi2/dut/header_corrector/pkt_done_i
add wave -noupdate /tb_csi2/dut/header_corrector/error_o
add wave -noupdate /tb_csi2/dut/header_corrector/error_corrected_o
add wave -noupdate /tb_csi2/dut/header_corrector/data_o
add wave -noupdate /tb_csi2/dut/header_corrector/valid_o
add wave -noupdate /tb_csi2/dut/header_corrector/generated_parity
add wave -noupdate /tb_csi2/dut/header_corrector/syndrome
add wave -noupdate /tb_csi2/dut/header_corrector/err_bit_pos
add wave -noupdate /tb_csi2/dut/header_corrector/data_d
add wave -noupdate /tb_csi2/dut/header_corrector/valid_d
add wave -noupdate /tb_csi2/dut/header_corrector/header_valid
add wave -noupdate /tb_csi2/dut/header_corrector/header_passed
add wave -noupdate /tb_csi2/dut/header_corrector/error_detected
add wave -noupdate -divider AXI4_CONV
add wave -noupdate /tb_csi2/dut/axi4_conv/clk_i
add wave -noupdate /tb_csi2/dut/axi4_conv/rst_i
add wave -noupdate /tb_csi2/dut/axi4_conv/data_i
add wave -noupdate /tb_csi2/dut/axi4_conv/valid_i
add wave -noupdate /tb_csi2/dut/axi4_conv/error_i
add wave -noupdate /tb_csi2/dut/axi4_conv/phy_rst_o
add wave -noupdate /tb_csi2/dut/axi4_conv/valid_d1
add wave -noupdate /tb_csi2/dut/axi4_conv/pkt_running
add wave -noupdate /tb_csi2/dut/axi4_conv/last_word
add wave -noupdate /tb_csi2/dut/axi4_conv/header_valid
add wave -noupdate /tb_csi2/dut/axi4_conv/short_pkt
add wave -noupdate /tb_csi2/dut/axi4_conv/long_pkt
add wave -noupdate /tb_csi2/dut/axi4_conv/byte_cnt
add wave -noupdate /tb_csi2/dut/axi4_conv/byte_cnt_comb
add wave -noupdate -divider CSI2_PKT_PX_CLK_IF
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/aclk
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/aresetn
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tvalid
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tready
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tdata
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tstrb
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tkeep
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tlast
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tid
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tdest
add wave -noupdate /tb_csi2/dut/csi2_pkt_px_clk_if/tuser
add wave -noupdate -divider PKT_HANDLER
add wave -noupdate /tb_csi2/dut/payload_extractor/clk_i
add wave -noupdate /tb_csi2/dut/payload_extractor/rst_i
add wave -noupdate /tb_csi2/dut/payload_extractor/frame_start_o
add wave -noupdate /tb_csi2/dut/payload_extractor/frame_end_o
add wave -noupdate /tb_csi2/dut/payload_extractor/state
add wave -noupdate /tb_csi2/dut/payload_extractor/next_state
add wave -noupdate /tb_csi2/dut/payload_extractor/byte_cnt
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_size
add wave -noupdate -divider PAYLOAD_IF
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/aclk
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/aresetn
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/tvalid
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/tready
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_extractor/pkt_o/tdata
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/tstrb
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/tkeep
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/tlast
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/tid
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/tdest
add wave -noupdate /tb_csi2/dut/payload_extractor/pkt_o/tuser
add wave -noupdate -divider GBX
add wave -noupdate /tb_csi2/dut/gbx/clk_i
add wave -noupdate /tb_csi2/dut/gbx/rst_i
add wave -noupdate /tb_csi2/dut/gbx/tdata_d1
add wave -noupdate /tb_csi2/dut/gbx/tstrb_d1
add wave -noupdate /tb_csi2/dut/gbx/state
add wave -noupdate /tb_csi2/dut/gbx/next_state
add wave -noupdate -divider PAYLOAD_40B_IF
add wave -noupdate /tb_csi2/dut/payload_40b_if/aclk
add wave -noupdate /tb_csi2/dut/payload_40b_if/aresetn
add wave -noupdate /tb_csi2/dut/payload_40b_if/tvalid
add wave -noupdate /tb_csi2/dut/payload_40b_if/tready
add wave -noupdate -radix hexadecimal /tb_csi2/dut/payload_40b_if/tdata
add wave -noupdate /tb_csi2/dut/payload_40b_if/tstrb
add wave -noupdate /tb_csi2/dut/payload_40b_if/tkeep
add wave -noupdate /tb_csi2/dut/payload_40b_if/tlast
add wave -noupdate /tb_csi2/dut/payload_40b_if/tid
add wave -noupdate /tb_csi2/dut/payload_40b_if/tdest
add wave -noupdate /tb_csi2/dut/payload_40b_if/tuser
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6188204 ps} 0}
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
WaveRestoreZoom {6246397 ps} {6602318 ps}
