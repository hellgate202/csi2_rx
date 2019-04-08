module csi2_rx_wrap
(
  input           dphy_clk_p_i,
  input           dphy_clk_n_i,
  (* mark_debug = "true" *)input           dphy_lp_clk_p_i,
  (* mark_debug = "true" *)input           dpht_lp_clk_n_i,
  input  [1 : 0]  dphy_data_p_i,
  (* mark_debug = "true" *)input  [1 : 0]  dphy_lp_data_p_i,
  input  [1 : 0]  dphy_data_n_i,
  (* mark_debug = "true" *)input  [1 : 0]  dpht_lp_data_n_i,
  input           ref_clk_i,
  input           px_clk_i,
  input           ref_srst_i,
  input           px_srst_i,
  input  [1 : 0]  btn_i,

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
  .DATA_WIDTH ( 16         ),
  .ID_WIDTH   ( 1          ),
  .DEST_WIDTH ( 1          )
) video (
  .aclk       ( px_clk_i   ),
  .aresetn    ( !px_srst_i )
);

logic [1 : 0] btn_i_d1;
logic [1 : 0] btn_i_d2;
logic [1 : 0] btn_i_d3;
logic [1 : 0] inc_delay;

generate
  for( genvar g = 0; g < 2; g++ )
    begin : btn_edge
      always_ff @( posedge ref_clk_i, posedge ref_srst_i )
        if( ref_srst_i )
          begin
            btn_i_d1[g] <= '0;
            btn_i_d2[g] <= '0;
            btn_i_d3[g] <= '0;
          end
        else
          begin
            btn_i_d1[g] <= btn_i[g];
            btn_i_d2[g] <= btn_i_d1[g];
            btn_i_d3[g] <= btn_i_d2[g];
          end
        assign inc_delay[g] = !btn_i_d3[g] && btn_i_d2[g];
    end
endgenerate

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
  .inc_delay_i   ( inc_delay     ),
  .ref_clk_i     ( ref_clk_i     ),
  .px_clk_i      ( px_clk_i      ),
  .ref_srst_i    ( ref_srst_i    ),
  .px_srst_i     ( px_srst_i     ),
  .enable_i      ( 1'b1          ),
  .video_o       ( video         )
);

endmodule
