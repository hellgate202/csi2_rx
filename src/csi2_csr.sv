/*
  Module provides accsess to control and status register
  of CSI2 IP-cores via AXI4-Lite interface
  Status registers consists of statisticss gathered by
  csi2_stat_acc module. Control registers allows to:
  clear statistics;
  dphy enable;
  SCCB slave address;
  data delay value passed to IDELAYE2;
  data delay value actualization
*/

// Package with register names
import csi2_csr_pkg::*;

module csi2_csr#(
  parameter int DATA_WIDTH = 32,
  parameter int ADDR_WIDTH = 8
)(
  input              clk_i,
  input              rst_i,
  axi4_lite_if.slave csr_if,
  output             clear_stat_o,
  output             phy_en_o,
  output [6 : 0]     sccb_slave_addr_o,
  output [4 : 0]     lane_0_delay_o,
  output [4 : 0]     lane_1_delay_o,
  output             delay_act_o,
  input  [31 : 0]    header_err_cnt_i,
  input  [31 : 0]    corr_header_err_cnt_i,
  input  [31 : 0]    crc_err_cnt_i,
  input  [31 : 0]    max_ln_per_frame_i,
  input  [31 : 0]    min_ln_per_frame_i,
  input  [31 : 0]    max_px_per_ln_i,
  input  [31 : 0]    min_px_per_ln_i,
  input  [31 : 0]    dphy_byte_freq_i,
  input  [31 : 0]    fps_i,
  output             cam_rst_stb_o
);

assign csr_if.awready = 1'b1;
assign csr_if.wready  = 1'b1;
assign csr_if.bresp   = 2'b00;
assign csr_if.arready = 1'b1;
assign csr_if.rresp   = 2'b00;

// We don't have response delay so we always provide
// write response and read data next clock cycle
// after request
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      csr_if.rvalid <= 1'b0;
      csr_if.bvalid <= 1'b0;
    end
  else
    begin
      csr_if.rvalid <= csr_if.arvalid;
      csr_if.bvalid <= ( csr_if.wvalid && csr_if.awvalid );
    end

localparam int DATA_WIDTH_B   = DATA_WIDTH / 8;
// How many bits in byte address occupied by one word
localparam int ADDR_WORD_BITS = $clog2( DATA_WIDTH_B );

// Control registers
logic [TOTAL_CR_CNT - 1 : 0][DATA_WIDTH - 1 : 0] cr;
// Status registers
logic [TOTAL_SR_CNT - 1 : 0][DATA_WIDTH - 1 : 0] sr;

// Delays to provide one clock cycle strobes
// from control registers
logic clear_stat_d1;
logic delay_act_d1;
logic cam_rst_stb_d1;

// We can write only to control registers
// We assume that awvalid and wvalid will be asserted
// at the same clock cycle
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    cr <= '0;
  else
    if( csr_if.awvalid && csr_if.wvalid )
      for( int i = 0; i < TOTAL_CR_CNT; i++ )
        if( ( csr_if.awaddr >> ADDR_WORD_BITS ) == i )
          for( int j = 0; j < DATA_WIDTH_B; j++ )
            if( csr_if.wstrb[j] )
              cr[i][j * 8 + 7 -: 8] <= csr_if.wdata[j * 8 + 7 -: 8];

// Read logic
// We need to find out are we reading from control or status registers
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    csr_if.rdata <= '0;
  else
    if( csr_if.arvalid )
      if( ( csr_if.araddr >> ADDR_WORD_BITS ) < TOTAL_CR_CNT )
        csr_if.rdata <= cr[csr_if.araddr >> ADDR_WORD_BITS];
      else
        if( ( csr_if.araddr >> ADDR_WORD_BITS ) < TOTAL_REGS_CNT )
          csr_if.rdata <= sr[( csr_if.araddr >> ADDR_WORD_BITS ) - TOTAL_CR_CNT];
        else
          csr_if.rdata <= '0;

assign sr[HEADER_ERR_CNT_SR - TOTAL_CR_CNT]      = header_err_cnt_i;
assign sr[CORR_HEADER_ERR_CNT_SR - TOTAL_CR_CNT] = corr_header_err_cnt_i;
assign sr[CRC_ERR_CNT_SR - TOTAL_CR_CNT]         = crc_err_cnt_i;
assign sr[MAX_LN_PER_FRAME_SR - TOTAL_CR_CNT]    = max_ln_per_frame_i;
assign sr[MIN_LN_PER_FRAME_SR - TOTAL_CR_CNT]    = min_ln_per_frame_i;
assign sr[MAX_PX_PER_LN_SR - TOTAL_CR_CNT]       = max_px_per_ln_i;
assign sr[MIN_PX_PER_LN_SR - TOTAL_CR_CNT]       = min_px_per_ln_i;
assign sr[DPHY_BYTE_CLK_SR - TOTAL_CR_CNT]       = dphy_byte_freq_i;
assign sr[FPS_SR - TOTAL_CR_CNT]                 = fps_i;

// Delays for strobe generation
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      clear_stat_d1  <= '0;
      delay_act_d1   <= '0;
      cam_rst_stb_d1 <= '0;
    end
  else
    begin
      clear_stat_d1  <= cr[CLEAR_STAT_CR][0];
      delay_act_d1   <= cr[DELAY_ACT_CR][0];
      cam_rst_stb_d1 <= cr[CAM_RST_STB_CR][0];
    end

assign clear_stat_o      = cr[CLEAR_STAT_CR][0] && !clear_stat_d1;
assign phy_en_o          = cr[PHY_ENABLE_CR][0];
assign sccb_slave_addr_o = cr[SCCB_SLAVE_ADDR_CR][6 : 0];
assign lane_0_delay_o    = cr[LANE_0_DELAY_CR][4 : 0];
assign lane_1_delay_o    = cr[LANE_1_DELAY_CR][4 : 0];
assign delay_act_o       = cr[DELAY_ACT_CR][0] && !delay_act_d1;
assign cam_rst_stb_o     = cr[CAM_RST_STB_CR][0] && !cam_rst_stb_d1;

endmodule
