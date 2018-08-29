onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_hamming/DUT/clk_i
add wave -noupdate /tb_hamming/DUT/rst_i
add wave -noupdate /tb_hamming/DUT/valid_i
add wave -noupdate /tb_hamming/DUT/valid_d
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/data_i
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/data_d
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/data_o
add wave -noupdate /tb_hamming/DUT/valid_o
add wave -noupdate /tb_hamming/DUT/pkt_done_i
add wave -noupdate -radix unsigned /tb_hamming/DUT/err_bit_pos
add wave -noupdate /tb_hamming/DUT/error_o
add wave -noupdate /tb_hamming/DUT/error_corrected_o
add wave -noupdate /tb_hamming/DUT/generated_parity
add wave -noupdate /tb_hamming/DUT/syndrome
add wave -noupdate /tb_hamming/DUT/header_passed
add wave -noupdate /tb_hamming/DUT/header_valid
add wave -noupdate /tb_hamming/DUT/error_detected
add wave -noupdate -divider MEMORY
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/wr_clk_i
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/wr_addr_i
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/wr_data_i
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/wr_i
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/rd_clk_i
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/rd_addr_i
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/rd_data_o
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/rd_i
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/rd_data
add wave -noupdate -radix hexadecimal /tb_hamming/DUT/err_bit_pos_lut/rd_data_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24871 fs} 0}
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
WaveRestoreZoom {0 fs} {78212 fs}
