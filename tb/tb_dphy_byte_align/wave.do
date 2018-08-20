onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {data phy}
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/bit_clk_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/bit_clk_inv_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/byte_clk_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/enable_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/rst_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/dphy_data_p_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/dphy_data_n_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/byte_data_o
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/rst_d1
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/rst_d2
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/serial_data
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/data_phy/serial_data_d
add wave -noupdate -divider DUT
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/clk_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/rst_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/enable_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/unaligned_byte_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/wait_for_sync_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/packet_done_i
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/valid_o
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/aligned_byte_o
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/unaligned_byte_d1
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/unaligned_byte_d2
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/sync_offset
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/align_shift
add wave -noupdate -radix hexadecimal /tb_dphy_byte_align/DUT/found_sync
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {99652 ps} 0}
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
WaveRestoreZoom {0 ps} {2713594 ps}
