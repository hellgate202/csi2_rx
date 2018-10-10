onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/dphy_clk_p_i
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/dphy_clk_n_i
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/dphy_data_p_i
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/dphy_data_n_i
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/ref_clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/enable_i
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/short_pkt_valid_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/short_pkt_v_channel_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/short_pkt_data_type_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/short_pkt_data_field_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/long_pkt_header_valid_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/long_pkt_v_channel_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/long_pkt_data_type_o
add wave -noupdate -radix unsigned /tb_csi2/DUT/long_pkt_word_cnt_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/long_pkt_payload_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/long_pkt_payload_valid_o
add wave -noupdate -radix binary /tb_csi2/DUT/long_pkt_payload_be_o
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/int_clk
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/int_rst
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/pkt_done
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/phy_data
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/phy_data_valid
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/header_error
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/header_error_corrected
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/corrected_phy_data
add wave -noupdate -radix hexadecimal /tb_csi2/DUT/corrected_phy_data_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {472550 ps} 0}
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
WaveRestoreZoom {368927 ps} {625246 ps}
