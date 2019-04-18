vlib work
vlog -sv -f files
vopt +acc tb_csi2 -L unisim -o tb_csi2_opt
vsim tb_csi2_opt
do wave.do
run -all
