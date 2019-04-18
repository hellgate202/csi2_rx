module dphy_hs_clk_rx 
(
  input  dphy_clk_p_i,
  input  dphy_clk_n_i,
  output bit_clk_o,
  output bit_clk_inv_o,
  output byte_clk_o
);

logic bit_clk;

// Transform differential clock to bit clk
IBUFDS #(
  .DIFF_TERM    ( 0            ),
  .IBUF_LOW_PWR ( 0            ),
  .IOSTANDARD   ( "DEFAULT"    )
) clk_diff_input (
  .O            ( bit_clk      ),
  .I            ( dphy_clk_p_i ),
  .IB           ( dphy_clk_n_i )
);

// Allows us to use bit clk as logic clk
BUFIO clk_buf (
  .O ( bit_clk_o ),
  .I ( bit_clk   )
);

// Bit clk is DDR clk, so we divide it by 4 to get
// byte clk
BUFR #(
  .BUFR_DIVIDE ( "4"        ),
  .SIM_DEVICE  ( "7SERIES"  )
) clk_divider (
  .O           ( byte_clk_o ),
  .CE          ( 1'b1       ),
  .CLR         ( 1'b0       ),
  .I           ( bit_clk    )
);

assign bit_clk_inv_o = !bit_clk_o;

endmodule
