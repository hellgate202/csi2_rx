vlib work
set proj_dir [pwd]/../../
set vivado_sim_lib $::env(QSYS_ROOTDIR)/../../../modelsim_ase/xilinx/
set inc_dir "$proj_dir/src/ $proj_dir/tb/"
set dirs "$proj_dir/src/ $proj_dir/tb/tb_dphy_clk_detect $vivado_sim_lib"   
set files "$proj_dir/tb/tb_dphy_clk_detect/files" 

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
      set file_path_num [exec echo $file_path | wc -l]
      set file_dir [string trimright $file_path $file]
      
      #File found or not?
      if { [llength $file_path] > 0 } {

      #There is only one file name?
        if { $file_path_num == "1" } {
            if [regexp {.vhdl?} $file] {
              #puts "vcom -work work $file_path"
              vcom -work work $file_path
            } else {
              #puts "vlog -sv -work work +incdir+$file_dir $file_path"
              vlog -sv -incr -work work +incdir+$file_dir $file_path
            }
        } else {
          echo ########################################################
          echo !!!! Error: files with the same names !!!!
          echo file_path="$file_path"
          echo file_dir="$file_dir"
          echo file_path_num="$file_path_num"
          echo ########################################################
          quit
        }
      }
    }
  }
}

vsim -novopt tb_dphy_clk_detect
do wave.do

run -all
