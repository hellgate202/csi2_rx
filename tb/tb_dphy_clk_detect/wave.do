onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider DUT
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/ref_clk_i
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/byte_clk_i
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/enable_i
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/rst_i
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/rst_o
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/clk_presence_cnt
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/clk_absent_cnt
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/byte_clk_d1
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/byte_clk_d2
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT/clk_absent
add wave -noupdate -divider DUT_CDC
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/ref_clk_i
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/byte_clk_i
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/enable_i
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/rst_i
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/rst_o
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/toggle_byte
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/toggle_byte_s1
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/toggle_byte_s2
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/toggle_byte_s3
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/clk_absence_cnt
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/clk_presence_cnt
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/clk_absent
add wave -noupdate -radix hexadecimal /tb_dphy_clk_detect/DUT_cdc/clk_edge
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
WaveRestoreZoom {47419586 ps} {50133180 ps}
