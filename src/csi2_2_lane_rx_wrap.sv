module csi2_2_lane_rx_wrap 
(
  input           ref_clk_i,
  input           px_clk_i,
  input           ref_srst_i,
  input           px_srst_i,

  input           dphy_clk_p_i,
  input           dphy_clk_n_i,
  input           dphy_lp_clk_p_i,
  input           dphy_lp_clk_n_i,
  input  [1 : 0]  dphy_data_p_i,
  input  [1 : 0]  dphy_lp_data_p_i,
  input  [1 : 0]  dphy_data_n_i,
  input  [1 : 0]  dphy_lp_data_n_i,

  input           sccb_ctrl_awvalid_i,
  output          sccb_ctrl_awready_o,
  input  [15 : 0] sccb_ctrl_awaddr_i,
  input           sccb_ctrl_wvalid_i,
  output          sccb_ctrl_wready_o,
  input  [31 : 0] sccb_ctrl_wdata_i,
  input           sccb_ctrl_wstrb_i,
  output          sccb_ctrl_bvalid_o,
  input           sccb_ctrl_bready_i,
  output [1 : 0]  sccb_ctrl_bresp_o,
  input           sccb_ctrl_arvalid_i,
  output          sccb_ctrl_arready_o,
  input  [15 : 0] sccb_ctrl_araddr_i,
  output          sccb_ctrl_rvalid_o,
  input           sccb_ctrl_rready_i,
  output [31 : 0] sccb_ctrl_rdata_o,
  output [1 : 0]  sccb_ctrl_rresp_o,

  input           csi2_csr_awvalid_i,
  output          csi2_csr_awready_o,
  input  [7 : 0]  csi2_csr_awaddr_i,
  input           csi2_csr_wvalid_i,
  output          csi2_csr_wready_o,
  input  [31 : 0] csi2_csr_wdata_i,
  input  [3 : 0]  csi2_csr_wstrb_i,
  output          csi2_csr_bvalid_o,
  input           csi2_csr_bready_i,
  output [1 : 0]  csi2_csr_bresp_o,
  input           csi2_csr_arvalid_i,
  output          csi2_csr_arready_o,
  input  [7 : 0]  csi2_csr_araddr_i,
  output          csi2_csr_rvalid_o,
  input           csi2_csr_rready_i,
  output [31 : 0] csi2_csr_rdata_o,
  output [1 : 0]  csi2_csr_rresp_o,

  input           video_tready_i,
  output [15 : 0] video_tdata_o,
  output          video_tvalid_o,
  output          video_tuser_o,
  output          video_tlast_o,

  inout           sccb_sda_io,
  inout           sccb_scl_io,
  output          cam_pwup_o
);

logic                sccb_sda_i;
logic                sccb_sda_o;
logic                sccb_sda_oe;
logic                sccb_scl_i;
logic                sccb_scl_o;
logic                sccb_scl_oe;

logic                header_err;
logic                corr_header_err;
logic                crc_err;
logic                clear_stat;
logic                phy_en;
logic                delay_act;
logic [4 : 0]        lane_0_delay;
logic [4 : 0]        lane_1_delay;
logic [1 : 0][4 : 0] lane_delay;
logic [31 : 0]       header_err_cnt;
logic [31 : 0]       corr_header_err_cnt;
logic [31 : 0]       crc_err_cnt;
logic [31 : 0]       max_ln_per_frame;
logic [31 : 0]       min_ln_per_frame;
logic [31 : 0]       max_px_per_ln;
logic [31 : 0]       min_px_per_ln;
logic [6 : 0]        sccb_slave_addr;

assign lane_delay[0] = lane_0_delay;
assign lane_delay[1] = lane_1_delay;

assign sccb_sda_i = sccb_sda_io;
assign sccb_sda_o = sccb_sda_oe ? sccb_sda_o : 1'bz;
assign sccb_scl_i = sccb_scl_io;
assign sccb_scl_o = sccb_scl_oe ? sccb_scl_o : 1'bz;

axi4_stream_if #(
  .DATA_WIDTH ( 16         ),
  .ID_WIDTH   ( 1          ),
  .DEST_WIDTH ( 1          )
) video (
  .aclk       ( px_clk_i   ),
  .aresetn    ( !px_srst_i )
);

assign video.tready   = video_tready_i;
assign video_tdata_o  = video.tdata;
assign video_tvalid_o = video.tvalid;
assign video_tuser_o  = video.tuser;
assign video_tlast_o  = video.tlast;

axi4_lite_if #(
  .ADDR_WIDTH ( 16         ),
  .DATA_WIDTH ( 32         )
) sccb_ctrl_if (
  .aclk       ( px_clk_i   ),
  .aresetn    ( !px_srst_i )
);

assign sccb_ctrl_if.awvalid = sccb_ctrl_awvalid_i;
assign sccb_ctrl_awready_o  = sccb_ctrl_if.awready;
assign sccb_ctrl_if.awaddr  = sccb_ctrl_awaddr_i;
assign sccb_ctrl_if.wvalid  = sccb_ctrl_wvalid_i;
assign sccb_ctrl_wready_o   = sccb_ctrl_if.wready;
assign sccb_ctrl_if.wdata   = sccb_ctrl_wdata_i;
assign sccb_ctrl_if.wstrb   = sccb_ctrl_wstrb_i;
assign sccb_ctrl_bvalid_o   = sccb_ctrl_if.bvalid;
assign sccb_ctrl_if.bready  = sccb_ctrl_bready_i;
assign sccb_ctrl_bresp_o    = sccb_ctrl_if.bresp;
assign sccb_ctrl_if.arvalid = sccb_ctrl_arvalid_i;
assign sccb_ctrl_arready_o  = sccb_ctrl_if.arready;
assign sccb_ctrl_if.araddr  = sccb_ctrl_araddr_i;
assign sccb_ctrl_rvalid_o   = sccb_ctrl_if.rvalid;
assign sccb_ctrl_if.rready  = sccb_ctrl_rready_i;
assign sccb_ctrl_rdata_o    = sccb_ctrl_if.rdata;
assign sccb_ctrl_rresp_o    = sccb_ctrl_if.rresp;

axi4_lite_if #(
  .ADDR_WIDTH ( 8          ),
  .DATA_WIDTH ( 32         )
) csi2_csr_if (
  .aclk       ( px_clk_i   ),
  .aresetn    ( !px_srst_i )
);

assign csi2_csr_if.awvalid = csi2_csr_awvalid_i;
assign csi2_csr_awready_o  = csi2_csr_if.awready;
assign csi2_csr_if.awaddr  = csi2_csr_awaddr_i;
assign csi2_csr_if.wvalid  = csi2_csr_wvalid_i;
assign csi2_csr_wready_o   = csi2_csr_if.wready;
assign csi2_csr_if.wdata   = csi2_csr_wdata_i;
assign csi2_csr_if.wstrb   = csi2_csr_wstrb_i;
assign csi2_csr_bvalid_o   = csi2_csr_if.bvalid;
assign csi2_csr_if.bready  = csi2_csr_bready_i;
assign csi2_csr_bresp_o    = csi2_csr_if.bresp;
assign csi2_csr_if.arvalid = csi2_csr_arvalid_i;
assign csi2_csr_arready_o  = csi2_csr_if.arready;
assign csi2_csr_if.araddr  = csi2_csr_araddr_i;
assign csi2_csr_rvalid_o   = csi2_csr_if.rvalid;
assign csi2_csr_if.rready  = csi2_csr_rready_i;
assign csi2_csr_rdata_o    = csi2_csr_if.rdata;
assign csi2_csr_rresp_o    = csi2_csr_if.rresp;

csi2_rx #(
  .DATA_LANES        ( 2                )
) csi2_rx (
  .dphy_clk_p_i      ( dphy_clk_p_i     ),
  .dphy_clk_n_i      ( dphy_clk_n_i     ),
  .dphy_data_p_i     ( dphy_data_p_i    ),
  .dphy_data_n_i     ( dphy_data_n_i    ),
  .lp_data_p_i       ( dphy_lp_data_p_i ),
  .lp_data_n_i       ( dphy_lp_data_n_i ),
  .ref_clk_i         ( ref_clk_i        ),
  .px_clk_i          ( px_clk_i         ),
  .ref_srst_i        ( ref_srst_i       ),
  .px_srst_i         ( px_srst_i        ),
  .enable_i          ( phy_en           ),
  .delay_act_i       ( delay_act        ),
  .lane_delay_i      ( lane_delay       ),
  .header_err_o      ( header_err       ),
  .corr_header_err_o ( corr_header_err  ),
  .crc_error_o       ( crc_err          ),
  .video_o           ( video            )
);

csi2_stat_acc csi2_stat_acc 
(
  .clk_i                 ( px_clk_i            ),
  .srst_i                ( px_srst_i           ),
  .clear_stat_i          ( clear_stat          ),
  .video_i               ( video               ),
  .header_err_i          ( header_err          ),
  .corr_header_err_i     ( corr_header_err     ),
  .crc_err_i             ( crc_err             ),
  .header_err_cnt_o      ( header_err_cnt      ),
  .corr_header_err_cnt_o ( corr_header_err_cnt ),
  .crc_err_cnt_o         ( crc_err_cnt         ),
  .max_ln_per_frame_o    ( max_ln_per_frame    ),
  .min_ln_per_frame_o    ( min_ln_per_frame    ),
  .max_px_per_ln_o       ( max_px_per_ln       ),
  .min_px_per_ln_o       ( min_px_per_ln       )
);

csi2_csr csi2_csr
(
  .clk_i                 ( px_clk_i            ),
  .px_srst_i             ( px_srst_i           ),
  .csr_if                ( csi2_csr_if         ),
  .clear_stat_o          ( clear_statt         ),
  .phy_en_o              ( phy_en              ),
  .sccb_slave_addr_o     ( sccb_slave_addr     ),
  .header_err_cnt_i      ( header_err_cnt      ),
  .corr_header_err_cnt_i ( corr_header_err_cnt ),
  .crc_err_cnt_i         ( crc_err_cnt         ),
  .max_ln_per_frame_i    ( max_ln_per_frame    ),
  .min_ln_per_frame_i    ( min_ln_per_frame    ),
  .max_px_per_ln_i       ( max_px_per_ln       ),
  .min_px_per_ln_i       ( min_px_per_ln       )
);

sccb_master sccb_master (
  .clk_i        ( px_clk_i        ),
  .srst_i       ( px_srst_i       ),
  .ctrl_if      ( sccb_ctrl_if    ),
  .slave_addr_i ( sccb_slave_addr ),
  .sda_i        ( sccb_sda_i      ),
  .sda_o        ( sccb_sda_o      ),
  .sda_oe       ( sccb_sda_oe     ),
  .scl_i        ( sccb_scl_i      ),
  .scl_o        ( sccb_scl_o      ),
  .scl_oe       ( sccb_scl_oe     )
);

cam_pwup cam_pwup (
  .clk_i      ( px_clk_i   ),
  .srst_i     ( px_srst_i  ),
  .cam_pwup_o ( cam_pwup_o )
);

endmodule
