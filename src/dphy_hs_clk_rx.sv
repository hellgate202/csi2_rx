module dphy_hs_clk_rx 
(
  input  dphy_clk_p_i,
  input  dphy_clk_n_i,
  output bit_clk_o,
  output bit_clk_inv_o,
  output byte_clk_o
);

logic bit_clk;

IBUFDS #(
  .DIFF_TERM    ( "FALSE"      ),
  .IBUF_LOW_PWR ( 0            ),
  .IOSTANDARD   ( "DEFAULT"    )
) clk_diff_input (
  .O            ( bit_clk      ),
  .I            ( dphy_clk_p_i ),
  .IB           ( dphy_clk_n_i )
);

BUFIO clk_buf (
  .O ( bit_clk_o ),
  .I ( bit_clk   )
);

BUFR #(
  .BUFR_DIVIDE ( "4"        ),
  .SIM_DEVICE  ( "7SERIES"  )
) clk_divider (
  .O           ( byte_clk_o ),
  .CE          ( 1'b1       ),
  .CLR         ( 1'b0       ),
  .I           ( bit_clk    )
);

assign bit_clk_inv_o = ~bit_clk_o;

endmodule
