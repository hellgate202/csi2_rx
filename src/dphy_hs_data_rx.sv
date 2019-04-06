module dphy_hs_data_rx #(
  parameter int DELAY = 0
)(
  input          bit_clk_i,
  input          bit_clk_inv_i,
  input          ref_clk_i,
  input          byte_clk_i,
  input          enable_i,
  input          srst_i,
  input          serdes_rst_i,
  input          dphy_data_p_i,
  input          dphy_data_n_i,
  output [7 : 0] byte_data_o
);

  logic rst_d1;
  logic rst_d2;

always_ff @( posedge byte_clk_i )
  begin
    rst_d1 <= serdes_rst_i;
    rst_d2 <= rst_d1;
  end

IBUFDS #(
  .DIFF_TERM    ( 1             ),
  .IBUF_LOW_PWR ( 0             ),
  .IOSTANDARD   ( "DEFAULT"     )
) data_buf (
  .O            ( serial_data   ),
  .I            ( dphy_data_p_i ),
  .IB           ( dphy_data_n_i )
);

IDELAYE2 #(
  .IDELAY_TYPE           ( "FIXED"       ),
  .DELAY_SRC             ( "IDATAIN"     ),
  .IDELAY_VALUE          ( DELAY         ),
  .HIGH_PERFORMANCE_MODE ( "TRUE"        ),
  .SIGNAL_PATTERN        ( "DATA"        ),
  .REFCLK_FREQUENCY      ( 200           ),
  .CINVCTRL_SEL          ( "FALSE"       ),
  .PIPE_SEL              ( "FALSE"       )
) input_delay (
  .DATAOUT               ( serial_data_d ),
  .DATAIN                ( 1'b0          ),
  .C                     ( byte_clk_i    ),
  .CE                    ( 1'b0          ),
  .INC                   ( 1'b0          ),
  .IDATAIN               ( serial_data   ),
  .CNTVALUEIN            ( 5'd0          ),
  .CNTVALUEOUT           (               ),
  .CINVCTRL              ( 1'b0          ),
  .LD                    ( 1'b0          ),
  .LDPIPEEN              ( 1'b0          ),
  .REGRST                ( 1'b0          )
);

IDELAYCTRL delay_ctrl
(
  .RDY    (           ),
  .REFCLK ( ref_clk_i ),
  .RST    ( srst_i    )
);

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
  .CE1               ( enable_i       ),
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
  .RST               ( rst_d2         ),
  .SHIFTIN1          ( 1'b0           ),
  .SHIFTIN2          ( 1'b0           )
);

endmodule
