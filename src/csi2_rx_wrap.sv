module csi2_rx_wrap
(
  input           dphy_clk_p_i,
  input           dphy_clk_n_i,
  input  [1 : 0]  dphy_data_p_i,
  input  [1 : 0]  dphy_data_n_i,
  input           ref_clk_i,
  input           px_clk_i,
  input           rst_i,

  input           video_tready_i,
  output [15 : 0] video_tdata_o,
  output          video_tvalid_o,
  output [1 : 0]  video_tstrb_o,
  output [1 : 0]  video_tkeep_o,
  output          video_tuser_o,
  output          video_tid_o,
  output          video_tdest_o,
  output          video_tlast_o
);

axi4_stream_if #(
  .DATA_WIDTH ( 16       ),
  .ID_WIDTH   ( 1        ),
  .DEST_WIDTH ( 1        )
) video (
  .aclk       ( px_clk_i ),
  .aresetn    ( !rst_i   )
);

assign video.tready   = video_tready_i;
assign video_tdata_o  = video.tdata;
assign video_tvalid_o = video.tvalid;
assign video_tstrb_o  = video.tstrb;
assign video_tkeep_o  = video.tkeep;
assign video_tuser_o  = video.tuser;
assign video_tid_o    = video.tid;
assign video_tdest_o  = video.tuser;
assign video_tlast_o  = video.tlast;

csi2_rx #(
  .DATA_LANES    ( 2             )
) csi2_rx (
  .dphy_clk_p_i  ( dphy_clk_p_i  ),
  .dphy_clk_n_i  ( dphy_clk_n_i  ),
  .dphy_data_p_i ( dphy_data_p_i ),
  .dphy_data_n_i ( dphy_data_n_i ),
  .ref_clk_i     ( ref_clk_i     ),
  .px_clk_i      ( px_clk_i      ),
  .rst_i         ( rst_i         ),
  .enable_i      ( 1'b1          ),
  .video_o       ( video         )
);

endmodule
