vlib work
set proj_dir [pwd]/../../
set vivado_sim_lib $::env(QSYS_ROOTDIR)/../../../modelsim_ase/xilinx/
set inc_dir "$proj_dir/src/ $proj_dir/tb/ $proj_dir/ip/"
set dirs "$proj_dir/src/ $proj_dir/tb/tb_pkt_handler/ $vivado_sim_lib"   
set files "$proj_dir/tb/tb_pkt_handler/files" 

vmap work $vivado_sim_lib/unisims_ver
vmap work $vivado_sim_lib/unisim

foreach j $inc_dir {
  if { [catch { exec grep -x +incdir+$j vlog.opt } ] } {
    exec echo +incdir+$j >> vlog.opt
  }
}

foreach files $files {
  set FILE_LIST "[exec grep -v // $files]"
  foreach file $FILE_LIST {
    foreach path $dirs {
      set file_path     [exec find $path -name $file]
      set file_dir [string trimright $file_path $file]
      
      if { [llength $file_path] > 0 } {
        if [regexp {.vhdl?} $file] {
          vcom -work work $file_path
        } else {
          vlog -sv -incr -work work +incdir+$file_dir $file_path
        }
      }
    }
  }
}

vsim -novopt tb_pkt_handler
do wave.do

run -all
