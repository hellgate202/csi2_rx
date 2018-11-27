proc compile_src {} {
  vlib work
  vlog -sv -incr -f files 
}

proc run_sim {} {
  vsim -novopt -L unisim tb_csi2
}

proc draw_waveforms {} {
  if { [file exists "wave.do"] } {
    do wave.do
  }
}

compile_src
run_sim
draw_waveforms
run -all
