module dphy_settle_ignore #(
  parameter int T_SETTLE = 150_000,
  parameter int T_CLK    = 5_000
)(
  input        clk_i,
  input        rst_i,
  input        lp_data_p_i,
  input        lp_data_n_i,
  output logic hs_data_valid_o
);

localparam int IGNORE_TICKS = T_SETTLE / T_CLK;
localparam int CNT_WIDTH    = $clog2( IGNORE_TICKS );

logic [CNT_WIDTH - 1 : 0] ignore_cnt;
// Metastability protection
logic                     lp_data_p_d1;
logic                     lp_data_p_d2;
logic                     lp_data_n_d1;
logic                     lp_data_n_d2;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      lp_data_p_d1 <= '0;
      lp_data_p_d2 <= '0;
      lp_data_n_d1 <= '0;
      lp_data_n_d2 <= '0;
    end
  else
    begin
      lp_data_p_d1 <= lp_data_p_i;
      lp_data_p_d2 <= lp_data_p_d1;
      lp_data_n_d1 <= lp_data_n_i;
      lp_data_n_d2 <= lp_data_n_d1;
    end

//       ____
// LP_P      \___________________
//       _________
// LP_N           \______________
//                |       |
//                300 ns   hs_data_valid
//                ignore
// This refers to DPHY standard states
enum logic [1 : 0] { IDLE_S,
                     LP_11_S,
                     LP_00_S,
                     HS_S } state, next_state;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    state <= IDLE_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      IDLE_S:
        begin
          if( lp_data_p_d2 && lp_data_n_d2 )
            next_state = LP_11_S;
        end
      LP_11_S:
        begin
          if( !lp_data_p_d2 && !lp_data_n_d2 )
            next_state = LP_00_S;
        end
      LP_00_S:
        begin
          if( ignore_cnt == IGNORE_TICKS )
            next_state = HS_S;
        end
      HS_S:
        begin
          if( lp_data_p_d2 && lp_data_n_d2 )
            next_state = LP_11_S;
        end
    endcase
  end

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    ignore_cnt <= '0;
  else
    if( state == LP_00_S )
      ignore_cnt <= ignore_cnt + 1'b1;
    else
      ignore_cnt <= '0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    hs_data_valid_o <= 1'b0;
  else
    hs_data_valid_o <= state == HS_S;

endmodule
