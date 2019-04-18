module dphy_hs_data_rx
(
  // Serial clk
  input          bit_clk_i,
  input          bit_clk_inv_i,
  input          dphy_data_p_i,
  input          dphy_data_n_i,
  // Parallel clk
  input          byte_clk_i,
  // Clock loss rst
  input          serdes_rst_i,
  // Delay load
  input          px_clk_i,
  input          delay_act_i,
  input  [4 : 0] lane_delay_i,
  // Parallel data
  output [7 : 0] byte_data_o
);

logic serial_data;
logic serial_data_d;

// Differential to single-ended data
// conversion
IBUFDS #(
  .DIFF_TERM    ( 0             ),
  .IBUF_LOW_PWR ( 0             ),
  .IOSTANDARD   ( "DEFAULT"     )
) data_buf (
  .O            ( serial_data   ),
  .I            ( dphy_data_p_i ),
  .IB           ( dphy_data_n_i )
);

// DPHY data can be ahead of DPHY clk,
// so we can delay it with this block
IDELAYE2 #(
  .IDELAY_TYPE           ( "VAR_LOAD"    ),
  .DELAY_SRC             ( "IDATAIN"     ),
  .IDELAY_VALUE          ( '0            ),
  .HIGH_PERFORMANCE_MODE ( "FALSE"       ),
  .SIGNAL_PATTERN        ( "DATA"        ),
  .REFCLK_FREQUENCY      ( 200           ),
  .CINVCTRL_SEL          ( "FALSE"       ),
  .PIPE_SEL              ( "FALSE"       )
) input_delay (
  .DATAOUT               ( serial_data_d ),
  .DATAIN                ( 1'b0          ),
  .C                     ( px_clk_i      ),
  .CE                    ( 1'b0          ),
  .INC                   ( 1'b0          ),
  .IDATAIN               ( serial_data   ),
  .CNTVALUEIN            ( lane_delay_i  ),
  .CNTVALUEOUT           (               ),
  .CINVCTRL              ( 1'b0          ),
  .LD                    ( delay_act_i   ),
  .LDPIPEEN              ( 1'b0          ),
  .REGRST                ( 1'b0          )
);

// Deserializer
ISERDESE2 #(
  .DATA_RATE         ( "DDR"          ),
  .DATA_WIDTH        ( 8              ),
  .DYN_CLKDIV_INV_EN ( "FALSE"        ),
  .DYN_CLK_INV_EN    ( "FALSE"        ),
  .INTERFACE_TYPE    ( "NETWORKING"   ),
  .INIT_Q1           ( 0              ),
  .INIT_Q2           ( 0              ),
  .INIT_Q3           ( 0              ),
  .INIT_Q4           ( 0              ),
  .IOBDELAY          ( "IFD"          ),
  .NUM_CE            ( 1              ),
  .OFB_USED          ( "FALSE"        ),
  .SERDES_MODE       ( "MASTER"       ),
  .SRVAL_Q1          ( 0              ),
  .SRVAL_Q2          ( 0              ),
  .SRVAL_Q3          ( 0              ),
  .SRVAL_Q4          ( 0              )
) input_serdes (
  .O                 (                ),
  .Q1                ( byte_data_o[7] ),
  .Q2                ( byte_data_o[6] ),
  .Q3                ( byte_data_o[5] ),
  .Q4                ( byte_data_o[4] ),
  .Q5                ( byte_data_o[3] ),
  .Q6                ( byte_data_o[2] ),
  .Q7                ( byte_data_o[1] ),
  .Q8                ( byte_data_o[0] ),
  .SHIFTOUT1         (                ),
  .SHIFTOUT2         (                ),
  .BITSLIP           ( 1'b0           ),
  .CE1               ( 1'b1           ),
  .CE2               ( 1'b1           ),
  .CLKDIVP           ( 1'b0           ),
  .CLK               ( bit_clk_i      ),
  .CLKB              ( bit_clk_inv_i  ),
  .CLKDIV            ( byte_clk_i     ),
  .OCLK              ( 1'b0           ),
  .DYNCLKDIVSEL      ( 1'b0           ),
  .DYNCLKSEL         ( 1'b0           ),
  .D                 ( 1'b0           ),
  .DDLY              ( serial_data_d  ),
  .OFB               ( 1'b0           ),
  .OCLKB             ( 1'b0           ),
  .RST               ( serdes_rst_i   ),
  .SHIFTIN1          ( 1'b0           ),
  .SHIFTIN2          ( 1'b0           )
);

endmodule
