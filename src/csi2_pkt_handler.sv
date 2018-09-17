module csi2_pkt_handler
(
  input               clk_i,
  input               rst_i,
  input               valid_i,
  input        [31:0] data_i,
  input               error_i,
  input               error_corrected_i,
  output logic        short_pkt_o,
  output logic        long_pkt_o,
  output logic [15:0] data_type_o,
  output logic [31:0] payload_data_o,
  output logic        valid_o,
  output logic        wait_for_sync_o,
  output logic        pkt_done_o,
  output logic        crc_check_o
);

endmodule
