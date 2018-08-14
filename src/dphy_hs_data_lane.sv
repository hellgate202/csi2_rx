module dphy_hs_data_lane #(
  parameter DELAY = 0
)(
  input        bit_clk_i,
  input        bit_clk_inv_i,
  input        byte_clk_i,
  input        enable_i,
  input        rst_i,
  input        dphy_hs_p_i,
  input        dphy_hs_n_i,
  output logic byte_data_o
);

  logic rst_d1;
  logic rst_d2;

always_ff @( posedge byte_clk_i )
  begin
    rst_d1 <= rst_i;
    rst_d2 <= rst_d1;
  end
  
IBUFDS #(
  .DIFF_TERM    ( 1           ),
  .IBUF_LOW_PWR ( 0           ),
  .IOSTANDARD   ( "DEFAULT"   )
) data_buf (
  .O            ( serial_data ),
  .I            ( dphy_hs_p_i ),
  .IB           ( dphy_hs_n_i )
);

IDELAYE2 #(
  .IDELAY_TYPE          ( "FIXED"       ),
  .DELAY_SRC            ( "IDATAIN"     ),
  .IDELAY_VALUE         ( DELAY         ),
  .HIGH_PERFOMANCE_MODE ( 1             ),
  .SIGNAL_PATTERN       ( "DATA"        ),
  .REFCLK_FREQUENCY     ( 200           ),
  .CINVCTRL_SEL         ( 0             ),
  .PIPE_SEL             ( 0             )
) input_delay (
  .DATAOUT              ( serial_data_d ),
  .DATAIN               ( '0            ),
  .C                    ( byte_clk      ),
  .CE                   ( 1'b0          ),
  .INC                  ( 1'b0          ),
  .IDATAIN              ( serial_data   ),
  .CNTVALUEIN           ( '0            ),
  .CNTVALUEOUT          (               ),
  .CINVCTRL             ( 1'b0          ),
  .LD                   ( 1'b0          ),
  .LDPIPEEN             ( 1'b0          ),
  .REGRST               ( 1'b0          )
);

endmodule
