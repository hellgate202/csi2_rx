onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_pkt_handler/DUT/clk_i
add wave -noupdate /tb_pkt_handler/DUT/rst_i
add wave -noupdate /tb_pkt_handler/DUT/valid_i
add wave -noupdate /tb_pkt_handler/DUT/data_i
add wave -noupdate /tb_pkt_handler/DUT/error_i
add wave -noupdate /tb_pkt_handler/DUT/error_corrected_i
add wave -noupdate /tb_pkt_handler/DUT/short_pkt_o
add wave -noupdate /tb_pkt_handler/DUT/long_pkt_o
add wave -noupdate /tb_pkt_handler/DUT/virtual_channel_o
add wave -noupdate /tb_pkt_handler/DUT/data_type_o
add wave -noupdate -radix hexadecimal /tb_pkt_handler/DUT/payload_data_o
add wave -noupdate /tb_pkt_handler/DUT/valid_o
add wave -noupdate /tb_pkt_handler/DUT/pkt_done_o
add wave -noupdate /tb_pkt_handler/DUT/crc_check_o
add wave -noupdate /tb_pkt_handler/DUT/valid_d1
add wave -noupdate /tb_pkt_handler/DUT/header_valid
add wave -noupdate /tb_pkt_handler/DUT/pkt_running
add wave -noupdate -radix unsigned /tb_pkt_handler/DUT/byte_cnt
add wave -noupdate -radix unsigned /tb_pkt_handler/DUT/byte_amount
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15000 ps} 0}
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
WaveRestoreZoom {0 ps} {351750 ps}
