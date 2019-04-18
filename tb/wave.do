onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_data_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_used_words_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_full_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_empty_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_clk_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_data_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_used_words_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_full_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_empty_o
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rst_i
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_req
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_used_words
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_full
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_empty
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_wr_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_gray_wr_clk_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_gray_wr_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_gray_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_gray_rd_clk_mtstb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_rd_clk_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_ptr_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/wr_addr
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_req
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_used_words
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_full
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_empty
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_gray_rd_clk_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_gray_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_gray_wr_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_gray_wr_clk_mtstb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_wr_clk_comb
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_ptr_wr_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_addr
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rd_en
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/data_in_mem
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/data_at_output
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rst_rd_clk_d1
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rst_rd_clk_d2
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rst_rd_clk
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rst_wr_clk_d1
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rst_wr_clk_d2
add wave -noupdate -radix hexadecimal /tb_csi2/dut/dphy_int_cdc/rst_wr_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {82435 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 437
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
WaveRestoreZoom {0 ps} {139445289 ps}
