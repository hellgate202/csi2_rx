module dphy_settle_ignore #(
  parameter int T_SETTLE = 300_000,
  parameter int T_CLK    = 5_000
)(
  input  clk_i,
  input  srst_i,
  input  lp_data_p_i,
  input  lp_data_n_i,
  output hs_data_valid_o
);

localparam int IGNORE_TICKS = T_SETTLE / T_CLK;
localparam int CNT_WIDTH    = $clog2( IGNORE_TICKS );

logic [CNT_WIDTH - 1 : 0] ignore_cnt;

enum logic [2 : 0] { IDLE_S,
                     LP_11_S,
                     LP_01_S,
                     LP_00_S,
                     HS_S } state, next_state;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    state <= IDLE_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      IDLE_S:
        begin
          if( lp_data_p_i && lp_data_n_i )
            next_state = LP_11_S;
        end
      LP_11_S:
        begin
          if( !lp_data_p_i && lp_data_n_i )
            next_state = LP_01_S;
        end
      LP_01_S:
        begin
          if( !lp_data_p_i && !lp_data_n_i )
            next_state = LP_00_S;
        end
      LP_00_S:
        begin
          if( ignore_cnt == IGNORE_TICKS )
            next_state = HS_S;
        end
      HS_S:
        begin
          if( lp_data_p_i && lp_data_n_i )
            next_state = LP_11_S;
        end
    endcase
  end

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    ignore_cnt <= '0;
  else
    if( state == LP_00_S )
      ignore_cnt <= ignore_cnt + 1'b1;
    else
      ignore_cnt <= '0;

assign hs_data_valid_o = state == HS_S;

endmodule
