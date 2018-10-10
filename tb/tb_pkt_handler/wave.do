onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_pkt_handler/DUT/clk_i
add wave -noupdate /tb_pkt_handler/DUT/rst_i
add wave -noupdate /tb_pkt_handler/DUT/valid_i
add wave -noupdate /tb_pkt_handler/DUT/data_i
add wave -noupdate /tb_pkt_handler/DUT/error_i
add wave -noupdate /tb_pkt_handler/DUT/error_corrected_i
add wave -noupdate /tb_pkt_handler/DUT/header_valid
add wave -noupdate /tb_pkt_handler/DUT/short_pkt
add wave -noupdate /tb_pkt_handler/DUT/long_pkt
add wave -noupdate /tb_pkt_handler/DUT/pkt_running
add wave -noupdate -radix unsigned /tb_pkt_handler/DUT/byte_cnt
add wave -noupdate /tb_pkt_handler/DUT/be_on_last_word
add wave -noupdate /tb_pkt_handler/DUT/last_word
add wave -noupdate /tb_pkt_handler/DUT/last_valid
add wave -noupdate /tb_pkt_handler/DUT/short_pkt_valid_o
add wave -noupdate -radix unsigned /tb_pkt_handler/DUT/short_pkt_v_channel_o
add wave -noupdate -radix hexadecimal /tb_pkt_handler/DUT/short_pkt_data_type_o
add wave -noupdate -radix hexadecimal /tb_pkt_handler/DUT/short_pkt_data_field_o
add wave -noupdate /tb_pkt_handler/DUT/long_pkt_header_valid_o
add wave -noupdate -radix unsigned /tb_pkt_handler/DUT/long_pkt_v_channel_o
add wave -noupdate -radix hexadecimal /tb_pkt_handler/DUT/long_pkt_data_type_o
add wave -noupdate -radix unsigned /tb_pkt_handler/DUT/long_pkt_word_cnt_o
add wave -noupdate -radix hexadecimal /tb_pkt_handler/DUT/long_pkt_payload_o
add wave -noupdate /tb_pkt_handler/DUT/long_pkt_payload_valid_o
add wave -noupdate /tb_pkt_handler/DUT/long_pkt_payload_be_o
add wave -noupdate /tb_pkt_handler/DUT/pkt_done_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {69281 ps} 0}
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
WaveRestoreZoom {0 ps} {383250 ps}
