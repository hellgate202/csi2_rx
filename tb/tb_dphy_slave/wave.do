onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider DUT
add wave -noupdate /tb_dphy_slave/DUT/dphy_clk_p_i
add wave -noupdate /tb_dphy_slave/DUT/dphy_clk_n_i
add wave -noupdate /tb_dphy_slave/DUT/dphy_data_p_i
add wave -noupdate /tb_dphy_slave/DUT/dphy_data_n_i
add wave -noupdate /tb_dphy_slave/DUT/ref_clk_i
add wave -noupdate /tb_dphy_slave/DUT/rst_i
add wave -noupdate /tb_dphy_slave/DUT/enable_i
add wave -noupdate /tb_dphy_slave/DUT/wait_for_sync_i
add wave -noupdate /tb_dphy_slave/DUT/pkt_done_i
add wave -noupdate /tb_dphy_slave/DUT/rst_o
add wave -noupdate -radix hexadecimal /tb_dphy_slave/DUT/data_o
add wave -noupdate /tb_dphy_slave/DUT/clk_o
add wave -noupdate /tb_dphy_slave/DUT/valid_o
add wave -noupdate /tb_dphy_slave/DUT/bit_clk
add wave -noupdate /tb_dphy_slave/DUT/bit_clk_inv
add wave -noupdate /tb_dphy_slave/DUT/byte_clk
add wave -noupdate /tb_dphy_slave/DUT/byte_data
add wave -noupdate /tb_dphy_slave/DUT/aligned_byte_data
add wave -noupdate /tb_dphy_slave/DUT/reset_aligner
add wave -noupdate /tb_dphy_slave/DUT/byte_valid
add wave -noupdate -divider CLK_PHY
add wave -noupdate /tb_dphy_slave/DUT/clk_phy/dphy_clk_p_i
add wave -noupdate /tb_dphy_slave/DUT/clk_phy/dphy_clk_n_i
add wave -noupdate /tb_dphy_slave/DUT/clk_phy/rst_i
add wave -noupdate /tb_dphy_slave/DUT/clk_phy/bit_clk_o
add wave -noupdate /tb_dphy_slave/DUT/clk_phy/bit_clk_inv_o
add wave -noupdate /tb_dphy_slave/DUT/clk_phy/byte_clk_o
add wave -noupdate /tb_dphy_slave/DUT/clk_phy/bit_clk
add wave -noupdate -divider CLK_DETECT
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/ref_clk_i
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/byte_clk_i
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/enable_i
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/rst_i
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/rst_o
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/toggle_byte
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/toggle_byte_s1
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/toggle_byte_s2
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/toggle_byte_s3
add wave -noupdate -radix unsigned /tb_dphy_slave/DUT/clk_detect/clk_absence_cnt
add wave -noupdate -radix unsigned /tb_dphy_slave/DUT/clk_detect/clk_presence_cnt
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/clk_absent
add wave -noupdate /tb_dphy_slave/DUT/clk_detect/clk_edge
add wave -noupdate -divider DATA_PHY_0
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/bit_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/bit_clk_inv_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/ref_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/byte_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/enable_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/rst_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/dphy_data_p_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/dphy_data_n_i}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/byte_data_o}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/rst_d1}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/rst_d2}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/serial_data}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[0]/data_phy/serial_data_d}
add wave -noupdate -divider BYTE_ALIGN_0
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/rst_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/enable_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/unaligned_byte_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/valid_o}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/aligned_byte_o}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/unaligned_byte_d1}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/unaligned_byte_d2}
add wave -noupdate -radix unsigned {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/sync_offset}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/align_shift}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[0]/byte_aligner/found_sync}
add wave -noupdate -divider DATA_PHY_1
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/bit_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/bit_clk_inv_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/ref_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/byte_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/enable_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/rst_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/dphy_data_p_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/dphy_data_n_i}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/byte_data_o}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/rst_d1}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/rst_d2}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/serial_data}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[1]/data_phy/serial_data_d}
add wave -noupdate -divider BYTE_ALIGN_1
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/rst_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/enable_i}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/unaligned_byte_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/valid_o}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/aligned_byte_o}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/unaligned_byte_d1}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/unaligned_byte_d2}
add wave -noupdate -radix unsigned {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/sync_offset}
add wave -noupdate -radix unsigned {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/align_shift}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[1]/byte_aligner/found_sync}
add wave -noupdate -divider DATA_LANE_2
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/bit_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/bit_clk_inv_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/ref_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/byte_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/enable_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/rst_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/dphy_data_p_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/dphy_data_n_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/byte_data_o}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/rst_d1}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/rst_d2}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/serial_data}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[2]/data_phy/serial_data_d}
add wave -noupdate -divider BYTE_ALIGN_2
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/rst_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/enable_i}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/unaligned_byte_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/valid_o}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/aligned_byte_o}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/unaligned_byte_d1}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/unaligned_byte_d2}
add wave -noupdate -radix unsigned {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/sync_offset}
add wave -noupdate -radix unsigned {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/align_shift}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[2]/byte_aligner/found_sync}
add wave -noupdate -divider DATA_LANE_3
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/bit_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/bit_clk_inv_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/ref_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/byte_clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/enable_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/rst_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/dphy_data_p_i}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/dphy_data_n_i}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/byte_data_o}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/rst_d1}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/rst_d2}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/serial_data}
add wave -noupdate {/tb_dphy_slave/DUT/data_lane/genblk1[3]/data_phy/serial_data_d}
add wave -noupdate -divider BYTE_ALIGN_3
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/clk_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/rst_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/enable_i}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/unaligned_byte_i}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/valid_o}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/aligned_byte_o}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/unaligned_byte_d1}
add wave -noupdate -radix hexadecimal {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/unaligned_byte_d2}
add wave -noupdate -radix unsigned {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/sync_offset}
add wave -noupdate -radix unsigned {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/align_shift}
add wave -noupdate {/tb_dphy_slave/DUT/byte_align/genblk1[3]/byte_aligner/found_sync}
add wave -noupdate -divider WORD_ALIGN
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/byte_clk_i
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/rst_i
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/enable_i
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/pkt_done_i
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/wait_for_sync_i
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/byte_data_i
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/valid_i
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/word_o
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/valid_o
add wave -noupdate -radix hexadecimal /tb_dphy_slave/DUT/word_aligner/word_d1
add wave -noupdate -radix hexadecimal /tb_dphy_slave/DUT/word_aligner/word_d2
add wave -noupdate -radix hexadecimal /tb_dphy_slave/DUT/word_aligner/word_d3
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/valid_d1
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/valid_d2
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/valid_d3
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/sel_delay
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/one_lane_sync
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/all_lanes_valid
add wave -noupdate /tb_dphy_slave/DUT/word_aligner/invalid_start
add wave -noupdate -divider CLASS
add wave -noupdate /tb_dphy_slave/sender_if/hs_clk_p
add wave -noupdate /tb_dphy_slave/sender_if/hs_clk_n
add wave -noupdate /tb_dphy_slave/sender_if/hs_data_p
add wave -noupdate /tb_dphy_slave/sender_if/hs_data_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {423200 ps} 0}
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
WaveRestoreZoom {400837 ps} {501638 ps}
