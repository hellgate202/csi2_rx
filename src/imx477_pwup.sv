import imx477_init_pkg::*;
import imx477_1080p30_pkg::*;

module imx477_pwup #(
  parameter int CLK_FREQ = 74_250_000
)(
  input               clk_i,
  input               rst_i,
  input               cam_rst_stb_i,
  output              cam_pwup_o,
  output              init_done_o,
  axi4_lite_if.master sccb_pwup,
  axi4_lite_if.master csr_pwup
);

localparam int CLK_T          = 64'd1_000_000_000_000 / CLK_FREQ;
localparam int TICKS_IN_100MS = 64'd100_000_000_000 / CLK_T;
localparam int TICKS_IN_150MS = 64'd150_000_000_000 / CLK_T;
localparam int PWUP_CNT_WIDTH = $clog2( TICKS_IN_150MS );
localparam int INIT_CNT_WIDTH = $clog2( TOTAL_INIT_OPS );
localparam int MODE_CNT_WIDTH = $clog2( TOTAL_MODE_OPS );
localparam int TICKS_IN_10MS  = 64'd10_000_000_000 / CLK_T;
localparam int WAIT_CNT_WIDTH = $clog2( TICKS_IN_10MS );

logic [PWUP_CNT_WIDTH - 1 : 0] pwup_cnt;
logic [WAIT_CNT_WIDTH - 1 : 0] wait_cnt;
logic [INIT_CNT_WIDTH - 1 : 0] init_cmd_num;
logic [MODE_CNT_WIDTH - 1 : 0] mode_cmd_num;
logic [7 : 0]                  sccb_wr_data;
logic [15 : 0]                 sccb_addr;
logic                          sccb_wr_stb;
logic                          sccb_done;
logic [23 : 0]                 init_cmd;
logic [23 : 0]                 mode_cmd;
logic [31 : 0]                 csr_wr_data;
logic [7 : 0]                  csr_addr;
logic                          csr_wr_stb;
logic                          csr_done;

logic [23 : 0] init_rom [TOTAL_INIT_OPS - 1 : 0];

initial
  for( int i = 0; i < TOTAL_INIT_OPS; i++ )
    init_rom[i] = INIT_ROM[i];

assign init_cmd = init_rom[init_cmd_num];

logic [23 : 0] mode_rom [TOTAL_MODE_OPS - 1 : 0];

initial
  for( int i = 0; i < TOTAL_MODE_OPS; i++ )
    mode_rom[i] = MODE_ROM[i];

assign mode_cmd = mode_rom[mode_cmd_num];

enum logic [4 : 0] { CAM_RST_S,
                     SET_SLAVE_ADDR_S,
                     SYS_INPUT_CLK_S,
                     SOFT_RST_S,
                     WAIT_10MS_S,
                     CFG_INIT_S,
                     SET_MODE_S,
                     RUN_DPHY_S,
                     RUN_S           } state, next_state;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    state <= CAM_RST_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      CAM_RST_S:
        begin
          if( pwup_cnt == PWUP_CNT_WIDTH'( TICKS_IN_150MS ) )
            next_state = SET_SLAVE_ADDR_S;
        end
      SET_SLAVE_ADDR_S:
        begin
          if( csr_done )
            next_state = WAIT_10MS_S;
        end
        /*
      SYS_INPUT_CLK_S:
        begin
          if( sccb_done )
            next_state = SOFT_RST_S;
        end
      SOFT_RST_S:
        begin
          if( sccb_done )
            next_state = WAIT_10MS_S;
        end
        */
      WAIT_10MS_S:
        begin
          if( wait_cnt == TICKS_IN_10MS )
            next_state = CFG_INIT_S;
        end
      CFG_INIT_S:
        begin
          if( init_cmd_num == ( TOTAL_INIT_OPS - 1 ) && sccb_done )
            next_state = SET_MODE_S;
        end
      SET_MODE_S:
        begin
          if( mode_cmd_num == ( TOTAL_MODE_OPS - 1 ) && sccb_done )
            next_state = RUN_DPHY_S;
        end
      RUN_DPHY_S:
        begin
          if( csr_done )
            next_state = RUN_S;
        end
      RUN_S:
        begin
          if( cam_rst_stb_i )
            next_state = CAM_RST_S;
        end
    endcase
  end

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pwup_cnt <= '0;
  else
    if( state == RUN_S && cam_rst_stb_i )
      pwup_cnt <= '0;
    else
      if( pwup_cnt < TICKS_IN_150MS )
        pwup_cnt <= pwup_cnt + 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    wait_cnt <= '0;
  else
    if( state == RUN_S && cam_rst_stb_i )
      wait_cnt <= '0;
    else
      if( wait_cnt < TICKS_IN_10MS && state == WAIT_10MS_S )
        wait_cnt <= wait_cnt + 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    init_cmd_num <= '0;
  else
    if( state == RUN_S && cam_rst_stb_i )
      init_cmd_num <= '0;
    else
      if( state == CFG_INIT_S && sccb_done )
        init_cmd_num <= init_cmd_num + 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    mode_cmd_num <= '0;
  else
    if( state == RUN_S && cam_rst_stb_i )
      mode_cmd_num <= '0;
    else
      if( state == SET_MODE_S && sccb_done )
        mode_cmd_num <= mode_cmd_num + 1'b1;

always_comb
  case( state )
    SYS_INPUT_CLK_S:
      begin
        sccb_addr    = 16'h3103;
        sccb_wr_data = 8'h11;
      end
    SOFT_RST_S:
      begin
        sccb_addr    = 16'h3008;
        sccb_wr_data = 8'h82;
      end
    CFG_INIT_S:
      begin
        sccb_addr    = init_cmd[23 : 8];
        sccb_wr_data = init_cmd[7 : 0];
      end
    SET_MODE_S:
      begin
        sccb_addr    = mode_cmd[23 : 8];
        sccb_wr_data = mode_cmd[7 : 0];
      end
    default:
      begin
        sccb_addr    = 16'd0;
        sccb_wr_data = 8'd0;
      end
  endcase

assign sccb_wr_stb = state == SYS_INPUT_CLK_S || state == SOFT_RST_S || 
                     state == CFG_INIT_S || state == SET_MODE_S;

always_comb
  case( state )
    SET_SLAVE_ADDR_S:
      begin
        csr_addr    = 8'h8;
        csr_wr_data = 32'h1a;
      end
    RUN_DPHY_S:
      begin
        csr_addr    = 8'h4;
        csr_wr_data = 32'h1;
      end
    default:
      begin
        csr_addr    = 16'd0;
        csr_wr_data = 8'd0;
      end
  endcase

assign csr_wr_stb = state == SET_SLAVE_ADDR_S || state == RUN_DPHY_S; 

axi4_lite_adapter #(
  .DATA_WIDTH  ( 8            ),
  .ADDR_WIDTH  ( 16           )
) sccb_driver (
  .clk_i       ( clk_i        ),
  .rst_i       ( rst_i        ),
  .wr_data_i   ( sccb_wr_data ),
  .addr_i      ( sccb_addr    ),
  .wr_stb_i    ( sccb_wr_stb  ),
  .rd_stb_i    (              ),
  .rd_data_o   (              ),
  .ready_o     (              ),
  .done_stb_o  ( sccb_done    ),
  .axi4_lite_o ( sccb_pwup    )
);

axi4_lite_adapter #(
  .DATA_WIDTH  ( 32          ),
  .ADDR_WIDTH  ( 8           )
) csr_driver (
  .clk_i       ( clk_i       ),
  .rst_i       ( rst_i       ),
  .wr_data_i   ( csr_wr_data ),
  .addr_i      ( csr_addr    ),
  .wr_stb_i    ( csr_wr_stb  ),
  .rd_stb_i    (             ),
  .rd_data_o   (             ),
  .ready_o     (             ),
  .done_stb_o  ( csr_done    ),
  .axi4_lite_o ( csr_pwup    )
);

assign init_done_o = state == RUN_S;
assign cam_pwup_o  = pwup_cnt >= PWUP_CNT_WIDTH'( TICKS_IN_100MS );

endmodule
