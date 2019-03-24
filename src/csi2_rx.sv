module csi2_rx #(
  parameter int DATA_LANES = 4,
  parameter int DELAY [4]  = '{ 0, 0, 0, 0 }
)(
  input                       dphy_clk_p_i,
  input                       dphy_clk_n_i,
  input  [DATA_LANES - 1 : 0] dphy_data_p_i,
  input  [DATA_LANES - 1 : 0] dphy_data_n_i,
  input                       ref_clk_i,
  input                       word_clk_i,
  input                       rst_i,
  input                       enable_i
);

typedef struct packed {
  bit [31 : 0] tdata;
  bit [3 : 0]  tstrb;
  bit          tlast;
} axi4_word_t;

logic          rx_clk;
logic          rx_rst;
logic          rx_clk_present;
logic          phy_rst;
logic [31 : 0] phy_data;
logic          phy_data_valid;
logic          header_error;
logic          header_error_corrected;
logic [31 : 0] corrected_phy_data;
logic          corrected_phy_data_valid;
logic          dphy_int_cdc_empty;

axi4_word_t    pkt_word_rx_clk;
axi4_word_t    pkt_word_word_clk;

assign rx_rst    = !rx_clk_present;
assign pkt_error = header_error && !header_error_corrected;

dphy_slave #(
  .DATA_LANES       ( DATA_LANES     ),
  .DELAY            ( DELAY          )
) phy (
  .dphy_clk_p_i     ( dphy_clk_p_i   ),
  .dphy_clk_n_i     ( dphy_clk_n_i   ),
  .dphy_data_p_i    ( dphy_data_p_i  ),
  .dphy_data_n_i    ( dphy_data_n_i  ),
  .ref_clk_i        ( ref_clk_i      ),
  .rst_i            ( rst_i          ),
  .enable_i         ( enable_i       ),
  .phy_rst_i        ( phy_rst        ),
  .rx_clk_present_o ( rx_clk_present ),
  .data_o           ( phy_data       ),
  .clk_o            ( rx_clk         ),
  .valid_o          ( phy_data_valid )
);

csi2_hamming_dec header_corrector (
  .clk_i             ( rx_clk                   ),
  .rst_i             ( rx_rst                   ),
  .valid_i           ( phy_data_valid           ),
  .data_i            ( phy_data                 ),
  .pkt_done_i        ( phy_rst                  ),
  .error_o           ( header_error             ),
  .error_corrected_o ( header_error_corrected   ),
  .data_o            ( corrected_phy_data       ),
  .valid_o           ( corrected_phy_data_valid )
);

axi4_stream_if #(
  .DATA_WIDTH ( 32     )
) csi2_pkt_rx_clk_if (
  .aclk       ( rx_clk ),
  .aresetn    ( !rst_i )
);

assign csi2_pkt_rx_clk_if.tready = 1'b1;
assign pkt_word_rx_clk.tdata     = csi2_pkt_rx_clk_if.tdata;
assign pkt_word_rx_clk.tstrb     = csi2_pkt_rx_clk_if.tstrb;
assign pkt_word_rx_clk.tlast     = csi2_pkt_rx_clk_if.tlast;

csi2_to_axi4_stream axi4_conv (
  .clk_i     ( rx_clk                   ),
  .rst_i     ( rx_rst                   ),
  .data_i    ( corrected_phy_data       ),
  .valid_i   ( corrected_phy_data_valid ),
  .error_i   ( pkt_error                ),
  .phy_rst_o ( phy_rst                  ),
  .pkt_o     ( csi2_pkt_rx_clk_if       )
);

axi4_stream_if #(
  .DATA_WIDTH ( 32         )
) csi2_pkt_word_clk_if (
  .aclk       ( word_clk_i ),
  .aresetn    ( !rst_i     )
);

dc_fifo #(
  .DATA_WIDTH      ( 37                          ),
  .WORDS_AMOUNT    ( 256                         )
) dphy_int_cdc (
  .wr_clk_i        ( rx_clk                      ),
  .wr_data_i       ( pkt_word_rx_clk             ),
  .wr_i            ( csi2_pkt_rx_clk_if.tvalid   ),
  .wr_used_words_o (                             ),
  .wr_full_o       (                             ),
  .wr_empty_o      (                             ),
  .rd_clk_i        ( word_clk_i                  ),
  .rd_data_o       ( pkt_word_word_clk           ),
  .rd_i            ( csi2_pkt_word_clk_if.tready ),
  .rd_used_words_o (                             ),
  .rd_full_o       (                             ),
  .rd_empty_o      ( dphy_int_cdc_empty          ),
  .rst_i           ( rst_i                       )
);

assign csi2_pkt_word_clk_if.tready = 1'b1;
assign csi2_pkt_word_clk_if.tdata  = pkt_word_word_clk.tdata;
assign csi2_pkt_word_clk_if.tstrb  = pkt_word_word_clk.tstrb;
assign csi2_pkt_word_clk_if.tkeep  = pkt_word_word_clk.tstrb;
assign csi2_pkt_word_clk_if.tlast  = pkt_word_word_clk.tlast;
assign csi2_pkt_word_clk_if.tvalid = !dphy_int_cdc_empty;
assign csi2_pkt_word_clk_if.tdest  = '0;
assign csi2_pkt_word_clk_if.tid    = '0;
assign csi2_pkt_word_clk_if.tuser  = '0;

/*csi2_crc_calc crc_calc
(
  .clk_i                    ( int_clk                  ),
  .rst_i                    ( int_rst                  ),
  .long_pkt_payload_i       ( long_pkt_payload_o       ),
  .long_pkt_payload_valid_i ( long_pkt_payload_valid_o ),
  .long_pkt_payload_be_i    ( long_pkt_payload_be_o    ),
  .long_pkt_eop_i           ( long_pkt_eop_o           ),
  .crc_passed_o             ( crc_passed_o             ),
  .crc_failed_o             ( crc_failed_o             )
);*/

endmodule
