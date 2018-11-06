module csi2_top #(
  parameter     DATA_LANES = 4,
  parameter int DELAY [4]  = '{0,0,0,0}
)(
  input                   dphy_clk_p_i,
  input                   dphy_clk_n_i,
  input  [DATA_LANES-1:0] dphy_data_p_i,
  input  [DATA_LANES-1:0] dphy_data_n_i,
  input                   ref_clk_i,
  input                   rst_i,
  input                   enable_i,
  // WIP: signals for debug
  output                  short_pkt_valid_o,
  output [1:0]            short_pkt_v_channel_o,
  output [5:0]            short_pkt_data_type_o,
  output [15:0]           short_pkt_data_field_o,

  output                  long_pkt_header_valid_o,
  output [1:0]            long_pkt_v_channel_o,
  output [5:0]            long_pkt_data_type_o,
  output [15:0]           long_pkt_word_cnt_o,
 
  output [31:0]           long_pkt_payload_o,
  output                  long_pkt_payload_valid_o,
  output [3:0]            long_pkt_payload_be_o,
  output                  long_pkt_eop_o,

  output                  crc_passed_o,
  output                  crc_failed_o
);

// Interconnect
logic        int_clk;
logic        int_rst;
logic        pkt_done;
logic [31:0] phy_data;
logic        phy_data_valid;
logic        header_error;
logic        header_error_corrected;
logic [31:0] corrected_phy_data;
logic        corrected_phy_data_valid;

dphy_slave #(
  .DATA_LANES    ( DATA_LANES     ),
  .DELAY         ( DELAY          )
) phy (
  .dphy_clk_p_i  ( dphy_clk_p_i   ),
  .dphy_clk_n_i  ( dphy_clk_n_i   ),
  .dphy_data_p_i ( dphy_data_p_i  ),
  .dphy_data_n_i ( dphy_data_n_i  ),
  .ref_clk_i     ( ref_clk_i      ),
  .rst_i         ( rst_i          ),
  .enable_i      ( enable_i       ),
  .pkt_done_i    ( pkt_done       ),
  .rst_o         ( int_rst        ),
  .data_o        ( phy_data       ),
  .clk_o         ( int_clk        ),
  .valid_o       ( phy_data_valid )
);

csi2_hamming_dec #(
  .LUT_REG_OUTPUT    ( 0                        )
) header_corrector (
  .clk_i             ( int_clk                  ),
  .rst_i             ( int_rst                  ),
  .valid_i           ( phy_data_valid           ),
  .data_i            ( phy_data                 ),
  .pkt_done_i        ( pkt_done                 ),
  .error_o           ( header_error             ),
  .error_corrected_o ( header_error_corrected   ),
  .data_o            ( corrected_phy_data       ),
  .valid_o           ( corrected_phy_data_valid )
);

csi2_pkt_handler pkt_handler
(
  .clk_i                    ( int_clk                  ),
  .rst_i                    ( int_rst                  ),
  .valid_i                  ( corrected_phy_data_valid ),
  .data_i                   ( corrected_phy_data       ),
  .error_i                  ( header_error             ),
  .error_corrected_i        ( header_error_corrected   ),
  .short_pkt_valid_o        ( short_pkt_valid_o        ),
  .short_pkt_v_channel_o    ( short_pkt_v_channel_o    ),
  .short_pkt_data_type_o    ( short_pkt_data_type_o    ),
  .short_pkt_data_field_o   ( short_pkt_data_field_o   ),
  .long_pkt_header_valid_o  ( long_pkt_header_valid_o  ),
  .long_pkt_v_channel_o     ( long_pkt_v_channel_o     ),
  .long_pkt_data_type_o     ( long_pkt_data_type_o     ),
  .long_pkt_word_cnt_o      ( long_pkt_word_cnt_o      ),
  .long_pkt_payload_o       ( long_pkt_payload_o       ),
  .long_pkt_payload_valid_o ( long_pkt_payload_valid_o ),
  .long_pkt_payload_be_o    ( long_pkt_payload_be_o    ),
  .long_pkt_eop_o           ( long_pkt_eop_o           ),
  .pkt_done_o               ( pkt_done                 )
);

csi2_crc_calc crc_calc
(
  .clk_i                    ( int_clk                  ),
  .rst_i                    ( int_rst                  ),
  .long_pkt_payload_i       ( long_pkt_payload_o       ),
  .long_pkt_payload_valid_i ( long_pkt_payload_valid_o ),
  .long_pkt_payload_be_i    ( long_pkt_payload_be_o    ),
  .long_pkt_eop_i           ( long_pkt_eop_o           ),
  .crc_passed_o             ( crc_passed_o             ),
  .crc_failed_o             ( crc_failed_o             )
);

endmodule
