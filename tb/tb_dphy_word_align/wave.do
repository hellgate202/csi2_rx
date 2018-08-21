onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider DUT
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/byte_clk_i
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/rst_i
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/enable_i
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/pkt_done_i
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/wait_for_sync_i
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/byte_data_i
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/valid_i
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/pkt_done_o
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/word_o
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/valid_o
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/word_d1
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/word_d2
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/word_d3
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/valid_d1
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/valid_d2
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/valid_d3
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/sel_delay
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/one_lane_sync
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/all_lanes_valid
add wave -noupdate -radix hexadecimal /tb_dphy_word_align/DUT/invalid_start
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28530 fs} 0}
quietly wave cursor active 1
configure wave -namecolwidth 360
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
WaveRestoreZoom {0 fs} {99750 fs}
