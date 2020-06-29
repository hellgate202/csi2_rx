proc rd { addr } { 
  create_hw_axi_txn read_txn -force [get_hw_axis hw_axi_1] -type READ -address $addr -len 1
  run_hw_axi [get_hw_axi_txns read_txn]
  after 1
  return [get_property DATA [get_hw_axi_txns read_txn]]
}
proc wr { addr data } { 
  run_hw_axi [create_hw_axi_txn write_txn -force [get_hw_axis hw_axi_1] -type WRITE -address $addr -len 1 -data $data] 
  after 1
}

proc count_hex_sym {hex} {
  set x 0
  if {$hex > 0} {
    for {set x 0} {$hex > 0} {incr x} {
      set hex [expr {$hex / 16}]
    }
  }
  return $x
}

proc rd_sccb_reg { addr } {
  set sccb_addr [format %x $addr]
  set axi_addr 0x0000$sccb_addr
  set rd_data [rd $axi_addr]
  return $rd_data
}

proc wr_sccb_reg { addr data } {
  set sccb_addr [format %x $addr]
  set axi_addr 0x0000$sccb_addr
  set axi_data [format %x $data]
  set nums [count_hex_sym $data]
  if { $nums == 2 } {
    set axi_data 0x000000$axi_data
  } else {
    set axi_data 0x0000000$axi_data
  }
  wr $axi_addr $axi_data
}

proc rd_csr { addr } {
  set csr_addr [format %x $addr]
  set nums [count_hex_sym $addr]
  if { $nums == 4 } {
    set axi_addr 0x0001$csr_addr
  } elseif { $nums == 3 } {
    set axi_addr 0x00010$csr_addr
  } elseif { $nums == 2 } {
    set axi_addr 0x000100$csr_addr
  } else {
    set axi_addr 0x0001000$csr_addr
  }
  set rd_data [rd $axi_addr]
  return $rd_data
}

proc wr_csr { addr data } {
  set csr_addr [format %x $addr]
  set nums [count_hex_sym $addr]
  if { $nums == 4 } {
    set axi_addr 0x0001$csr_addr
  } elseif { $nums == 3 } {
    set axi_addr 0x00010$csr_addr
  } elseif { $nums == 2 } {
    set axi_addr 0x000100$csr_addr
  } else {
    set axi_addr 0x0001000$csr_addr
  }
  set axi_data [format %x $data]
  set nums [count_hex_sym $data]
  if { $nums == 4 } {
    set axi_data 0x0000$axi_data
  } elseif { $nums == 3 } {
    set axi_data 0x00000$axi_data
  } elseif { $nums == 2 } {
    set axi_data 0x000000$axi_data
  } else {
    set axi_data 0x0000000$axi_data
  }
  wr $axi_addr $axi_data
}

proc dphy_en {} {
  wr_csr 0x04 0x1
  puts "PHY has been enabled"
}

proc dphy_dis {} {
  wr_csr 0x04 0x0 
  puts "PHY has been disabled"
}

proc clear_stat {} {
  wr_csr 0x00 0x0
  wr_csr 0x00 0x1
  puts "Statistics cleared"
}

proc set_sccb_addr { sccb_addr } {
  wr_csr 0x08 $sccb_addr
  puts "SCCB device ID has been set to [format %x $sccb_addr]"
}

proc get_head_err {} {
  puts "There were [format %d 0x[rd_csr 0x18]] header errors"
}

proc get_corr_head_err {} {
  puts "There were [format %d 0x[rd_csr 0x1c]] corrected header errors "
}

proc get_crc_err {} {
  puts "There were [format %d 0x[rd_csr 0x20]] CRC errors"
}

proc get_max_ln {} {
  puts "Maximum frame size was [format %d 0x[rd_csr 0x28]] lines"
}

proc get_min_ln {} {
  puts "Minimum frame size was [format %d 0x[rd_csr 0x2c]] lines"
}

proc get_max_px {} {
  puts "Maximum line size was [format %d 0x[rd_csr 0x30]] pixels"
}

proc get_min_px {} {
  puts "Minimum line size was [format %d 0x[rd_csr 0x34]] pixels"
}

proc get_dphy_clk {} {
  set clk [format %d 0x[rd_csr 0x38]]
  puts "DPHY byte clk is [expr { $clk / 1e6 }] MHz"
  puts "Link speed is [expr { $clk * 8 * 2 / 1e6}] Mbit/s"
}

proc get_fps {} {
  puts "Stream speed is [format %d 0x[rd_csr 0x3c]] FPS"
}
