proc count_hex_sym {hex} {
  set x 0
  if {$hex > 0} {
    for {set x 0} {$hex > 0} {incr x} {
      set hex [expr {$hex / 16}]
    }
  }
  return $x
}

proc rd { addr } { 
  create_hw_axi_txn read_txn -force [get_hw_axis hw_axi_1] -type READ -address $addr -len 1
  run_hw_axi [get_hw_axi_txns read_txn]
  return [get_property DATA [get_hw_axi_txns read_txn]]
}
proc wr { addr data } { run_hw_axi [create_hw_axi_txn write_txn -force [get_hw_axis hw_axi_1] -type WRITE -address $addr -len 1 -data $data] }

proc rd_sccb_reg { addr } {
  set axi_addr [format %x 0x3c]
  set axi_addr 00$axi_addr
  set sccb_addr [format %x $addr]
  set axi_addr 0x$axi_addr$sccb_addr
  set rd_data [rd $axi_addr]
  return $rd_data
}

proc wr_sccb_reg { addr data } {
  set axi_addr [format %x 0x3c]
  set axi_addr 00$axi_addr
  set sccb_addr [format %x $addr]
  set axi_addr 0x$axi_addr$sccb_addr
  set axi_data [format %x $data]
  set nums [count_hex_sym $data]
  if { $nums == 2 } {
    set axi_data 0x000000$axi_data
  } else {
    set axi_data 0x0000000$axi_data
  }
  wr $axi_addr $axi_data
}

proc init {} {
  set sensor_id_reg_0 0x[rd_sccb_reg 0x300a]
  set sensor_id_reg_1 0x[rd_sccb_reg 0x300b]
  if { [format %x $sensor_id_reg_0] != [format %x 0x00000056] ||
       [format %x $sensor_id_reg_1] != [format %x 0x00000040] } { 
    puts "Sensor ID missmatches"
    return 
  } else {
    puts "Sensor ID matches"
  }
  wr_sccb_reg 0x3103 0x11
  wr_sccb_reg 0x3008 0x82
  after 10
  wr_sccb_reg 0x3008 0x42
}

proc sensor_settings {} {
  wr_sccb_reg 0x3103 0x03
  wr_sccb_reg 0x3035 0x21
  wr_sccb_reg 0x3036 0x69
  wr_sccb_reg 0x3037 0x05
  wr_sccb_reg 0x303d 0x10
  wr_sccb_reg 0x303b 0x19
  wr_sccb_reg 0x300e 0x45
  wr_sccb_reg 0x4800 0x14
  wr_sccb_reg 0x302e 0x08
  wr_sccb_reg 0x3108 0x11
  wr_sccb_reg 0x3034 0x1a
  wr_sccb_reg 0x3800 0x01
  wr_sccb_reg 0x3801 0x50
  wr_sccb_reg 0x3802 0x01
  wr_sccb_reg 0x3803 0xaa
  wr_sccb_reg 0x3804 0x08
  wr_sccb_reg 0x3805 0xef
  wr_sccb_reg 0x3806 0x05
  wr_sccb_reg 0x3807 0xf9
  wr_sccb_reg 0x3810 0x00
  wr_sccb_reg 0x3811 0x10
  wr_sccb_reg 0x3812 0x00
  wr_sccb_reg 0x3813 0x0c
  wr_sccb_reg 0x3808 0x07
  wr_sccb_reg 0x3809 0x80
  wr_sccb_reg 0x380a 0x04
  wr_sccb_reg 0x380b 0x38
  wr_sccb_reg 0x380c 0x09
  wr_sccb_reg 0x380d 0xc4
  wr_sccb_reg 0x380e 0x04
  wr_sccb_reg 0x380f 0x60
  wr_sccb_reg 0x3814 0x11
  wr_sccb_reg 0x3815 0x11
  wr_sccb_reg 0x3821 0x00
  wr_sccb_reg 0x4837 0x18
  wr_sccb_reg 0x3618 0x00
  wr_sccb_reg 0x3612 0x59
  wr_sccb_reg 0x3708 0x64
  wr_sccb_reg 0x3709 0x52
  wr_sccb_reg 0x370c 0x03
  wr_sccb_reg 0x4300 0x00
  wr_sccb_reg 0x501f 0x03
  wr_sccb_reg 0x3008 0x02
}
