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
WaveRestoreZoom {0 ps} {691959217 ps}
