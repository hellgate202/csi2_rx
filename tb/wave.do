onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_csi2/video/aclk
add wave -noupdate /tb_csi2/video/aresetn
add wave -noupdate /tb_csi2/video/tvalid
add wave -noupdate /tb_csi2/video/tready
add wave -noupdate /tb_csi2/video/tdata
add wave -noupdate /tb_csi2/video/tstrb
add wave -noupdate /tb_csi2/video/tkeep
add wave -noupdate /tb_csi2/video/tlast
add wave -noupdate /tb_csi2/video/tid
add wave -noupdate /tb_csi2/video/tdest
add wave -noupdate /tb_csi2/video/tuser
add wave -noupdate /tb_csi2/dut/axi4_conv/clk_i
add wave -noupdate /tb_csi2/dut/axi4_conv/rst_i
add wave -noupdate /tb_csi2/dut/axi4_conv/enable_i
add wave -noupdate /tb_csi2/dut/axi4_conv/data_i
add wave -noupdate /tb_csi2/dut/axi4_conv/valid_i
add wave -noupdate /tb_csi2/dut/axi4_conv/error_i
add wave -noupdate /tb_csi2/dut/axi4_conv/phy_rst_o
add wave -noupdate /tb_csi2/dut/axi4_conv/valid_d1
add wave -noupdate /tb_csi2/dut/axi4_conv/pkt_running
add wave -noupdate /tb_csi2/dut/axi4_conv/last_word
add wave -noupdate /tb_csi2/dut/axi4_conv/header_valid
add wave -noupdate /tb_csi2/dut/axi4_conv/short_pkt
add wave -noupdate /tb_csi2/dut/axi4_conv/long_pkt
add wave -noupdate /tb_csi2/dut/axi4_conv/byte_cnt
add wave -noupdate /tb_csi2/dut/axi4_conv/byte_cnt_comb
add wave -noupdate /tb_csi2/dut/axi4_conv/disable_flag
add wave -noupdate /tb_csi2/dut/axi4_conv/enable_d1
add wave -noupdate /tb_csi2/dut/axi4_conv/enable_d2
add wave -noupdate /tb_csi2/dut/axi4_conv/frame_start
add wave -noupdate /tb_csi2/dut/axi4_conv/stream_stable
add wave -noupdate /tb_csi2/dut/axi4_conv/ignore_cnt
add wave -noupdate /tb_csi2/dut/axi4_conv/data_dbg
add wave -noupdate /tb_csi2/dut/axi4_conv/valid_dbg
add wave -noupdate /tb_csi2/dut/axi4_conv/tdata_dbg
add wave -noupdate /tb_csi2/dut/axi4_conv/tvalid_dbg
add wave -noupdate /tb_csi2/dut/axi4_conv/tstrb_dbg
add wave -noupdate /tb_csi2/dut/axi4_conv/tlast_dbg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7189049 ps} 0}
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
WaveRestoreZoom {0 ps} {348409468 ps}
