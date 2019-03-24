module csi2_rx #(
  parameter int DATA_LANES = 4,
  parameter int DELAY [4]  = '{ 0, 0, 0, 0 }
)(
  input                       dphy_clk_p_i,
  input                       dphy_clk_n_i,
  input  [DATA_LANES - 1 : 0] dphy_data_p_i,
  input  [DATA_LANES - 1 : 0] dphy_data_n_i,
  input                       ref_clk_i,
  input                       rst_i,
  input                       enable_i,
  // WIP: signals for debug
  output [31 : 0]             csi2_pkt_if_tdata,
  output                      csi2_pkt_if_tvalid,
  output [3 : 0]              csi2_pkt_if_tstrb
);

logic          int_clk;
logic          int_rst;
logic          rx_clk_present;
logic          phy_rst;
logic [31 : 0] phy_data;
logic          phy_data_valid;
logic          header_error;
logic          header_error_corrected;
logic [31 : 0] corrected_phy_data;
logic          corrected_phy_data_valid;
logic          csi2_pkt_valid;

assign int_rst   = !rx_clk_present;
assign pkt_error = header_error && !header_error_corrected;

axi4_stream_if #(
  .DATA_WIDTH ( 32       )
) csi2_pkt_if (
  .aclk       ( int_clk  ),
  .aresetn    ( !int_rst )
);

assign csi2_pkt_if_tdata  = csi2_pkt_if.tdata;
assign csi2_pkt_if_tvalid = csi2_pkt_if.tvalid;
assign csi2_pkt_if_tstrb  = csi2_pkt_if.tstrb;

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
  .clk_o            ( int_clk        ),
  .valid_o          ( phy_data_valid )
);

csi2_hamming_dec header_corrector (
  .clk_i             ( int_clk                  ),
  .rst_i             ( int_rst                  ),
  .valid_i           ( phy_data_valid           ),
  .data_i            ( phy_data                 ),
  .pkt_done_i        ( phy_rst                  ),
  .error_o           ( header_error             ),
  .error_corrected_o ( header_error_corrected   ),
  .data_o            ( corrected_phy_data       ),
  .valid_o           ( corrected_phy_data_valid )
);

csi2_to_axi4_stream axi4_conv (
  .clk_i     ( int_clk                  ),
  .rst_i     ( int_rst                  ),
  .data_i    ( corrected_phy_data       ),
  .valid_i   ( corrected_phy_data_valid ),
  .error_i   ( pkt_error                ),
  .phy_rst_o ( phy_rst                  ),
  .pkt_o     ( csi2_pkt_if              )
);

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
