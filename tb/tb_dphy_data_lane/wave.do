onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider DUT
add wave -noupdate /tb_dphy_data_lane/DUT/bit_clk_i
add wave -noupdate /tb_dphy_data_lane/DUT/bit_clk_inv_i
add wave -noupdate /tb_dphy_data_lane/DUT/byte_clk_i
add wave -noupdate /tb_dphy_data_lane/DUT/enable_i
add wave -noupdate /tb_dphy_data_lane/DUT/rst_i
add wave -noupdate /tb_dphy_data_lane/DUT/dphy_data_p_i
add wave -noupdate /tb_dphy_data_lane/DUT/dphy_data_n_i
add wave -noupdate -radix hexadecimal /tb_dphy_data_lane/DUT/byte_data_o
add wave -noupdate /tb_dphy_data_lane/DUT/rst_d1
add wave -noupdate /tb_dphy_data_lane/DUT/rst_d2
add wave -noupdate /tb_dphy_data_lane/DUT/serial_data
add wave -noupdate /tb_dphy_data_lane/DUT/serial_data_d
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {62657 ps} 0}
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
WaveRestoreZoom {0 ps} {554512 ps}
