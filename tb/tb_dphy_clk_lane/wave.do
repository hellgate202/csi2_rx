onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_dphy_clk_lane/DUT/dphy_clk_p_i
add wave -noupdate /tb_dphy_clk_lane/DUT/dphy_clk_n_i
add wave -noupdate /tb_dphy_clk_lane/DUT/rst_i
add wave -noupdate /tb_dphy_clk_lane/DUT/bit_clk_o
add wave -noupdate /tb_dphy_clk_lane/DUT/bit_clk_inv_o
add wave -noupdate /tb_dphy_clk_lane/DUT/byte_clk_o
add wave -noupdate /tb_dphy_clk_lane/DUT/bit_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3976168790 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 272
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {41889750 ps}
