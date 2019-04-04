module csi2_rx #(
  parameter int DATA_LANES = 2,
  parameter int DELAY [4]  = '{ 0, 0, 0, 0 }
)(
  input                       dphy_clk_p_i,
  input                       dphy_clk_n_i,
  input  [DATA_LANES - 1 : 0] dphy_data_p_i,
  input  [DATA_LANES - 1 : 0] dphy_data_n_i,
  input                       ref_clk_i,
  input                       px_clk_i,
  input                       rst_i,
  input                       enable_i,
  axi4_stream_if.master       video_o
);

typedef struct packed {
  bit [31 : 0] tdata;
  bit [3 : 0]  tstrb;
  bit          tlast;
} axi4_word_t;

logic          rx_clk;
logic          rx_rst;
logic          clk_loss_rst_d1;
logic          clk_loss_srst;
logic          rx_clk_present;
logic          phy_rst;
logic [31 : 0] phy_data;
logic          phy_data_valid;
logic          header_error;
logic          header_error_corrected;
logic [31 : 0] corrected_phy_data;
logic          corrected_phy_data_valid;
logic          rx_px_cdc_empty;
logic          frame_start_pkt;
logic          frame_end_pkt;
logic          rst_ref_clk_d1;
logic          ref_srst;
logic          rst_rx_clk_d1;
logic          rst_px_clk_d1;
logic          px_srst;

always_ff @( posedge ref_clk_i )
  begin
    rst_ref_clk_d1 <= rst_i;
    ref_srst       <= rst_ref_clk_d1;
  end

always_ff @( posedge px_clk_i )
  begin
    rst_px_clk_d1 <= rst_i;
    px_srst       <= rst_px_clk_d1;
  end

always_ff @( posedge rx_clk )
  begin
    clk_loss_rst_d1 <= rx_rst;
    clk_loss_srst   <= clk_loss_rst_d1;
  end

axi4_word_t    pkt_word_rx_clk;
axi4_word_t    pkt_word_px_clk;

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
  .srst_i           ( ref_srst       ),
  .enable_i         ( enable_i       ),
  .phy_rst_i        ( phy_rst        ),
  .rx_clk_present_o ( rx_clk_present ),
  .data_o           ( phy_data       ),
  .clk_o            ( rx_clk         ),
  .valid_o          ( phy_data_valid )
);

csi2_hamming_dec header_corrector (
  .clk_i             ( rx_clk                   ),
  .srst_i            ( clk_loss_srst            ),
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
  .srst_i    ( clk_loss_srst            ),
  .data_i    ( corrected_phy_data       ),
  .valid_i   ( corrected_phy_data_valid ),
  .error_i   ( pkt_error                ),
  .phy_rst_o ( phy_rst                  ),
  .pkt_o     ( csi2_pkt_rx_clk_if       )
);

axi4_stream_if #(
  .DATA_WIDTH ( 32       )
) csi2_pkt_px_clk_if (
  .aclk       ( px_clk_i ),
  .aresetn    ( !rst_i   )
);

dc_fifo #(
  .DATA_WIDTH      ( 37                        ),
  .WORDS_AMOUNT    ( 256                       )
) dphy_int_cdc (
  .wr_clk_i        ( rx_clk                    ),
  .wr_data_i       ( pkt_word_rx_clk           ),
  .wr_i            ( csi2_pkt_rx_clk_if.tvalid ),
  .wr_used_words_o (                           ),
  .wr_full_o       (                           ),
  .wr_empty_o      (                           ),
  .rd_clk_i        ( px_clk_i                  ),
  .rd_data_o       ( pkt_word_px_clk           ),
  .rd_i            ( csi2_pkt_px_clk_if.tready ),
  .rd_used_words_o (                           ),
  .rd_full_o       (                           ),
  .rd_empty_o      ( rx_px_cdc_empty           ),
  .rst_i           ( rst_i                     )
);

assign csi2_pkt_px_clk_if.tdata  = pkt_word_px_clk.tdata;
assign csi2_pkt_px_clk_if.tstrb  = pkt_word_px_clk.tstrb;
assign csi2_pkt_px_clk_if.tkeep  = pkt_word_px_clk.tstrb;
assign csi2_pkt_px_clk_if.tlast  = pkt_word_px_clk.tlast;
assign csi2_pkt_px_clk_if.tvalid = !rx_px_cdc_empty;
assign csi2_pkt_px_clk_if.tdest  = '0;
assign csi2_pkt_px_clk_if.tid    = '0;
assign csi2_pkt_px_clk_if.tuser  = '0;

axi4_stream_if #(
  .DATA_WIDTH ( 32       )
) payload_if (
  .aclk       ( px_clk_i ),
  .aresetn    ( !rst_i   )
);

csi2_pkt_handler payload_extractor
(
  .clk_i         ( px_clk_i           ),
  .srst_i        ( px_srst            ),
  .pkt_i         ( csi2_pkt_px_clk_if ),
  .frame_start_o ( frame_start_pkt    ),
  .frame_end_o   (                    ),
  .pkt_o         ( payload_if         )
);

axi4_stream_if #(
  .DATA_WIDTH ( 40       )
) payload_40b_if (
  .aclk       ( px_clk_i ),
  .aresetn    ( !rst_i   )
);

csi2_raw10_32b_40b_gbx gbx
(
  .clk_i  ( px_clk_i       ),
  .srst_i ( px_srst        ),
  .pkt_i  ( payload_if     ),
  .pkt_o  ( payload_40b_if )
);

csi2_px_serializer px_ser
(
  .clk_i         ( px_clk_i        ),
  .srst_i        ( px_srst         ),
  .frame_start_i ( frame_start_pkt ),
  .pkt_i         ( payload_40b_if  ),
  .pkt_o         ( video_o         )
);

endmodule
