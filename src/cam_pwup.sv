module cam_pwup #(
  parameter int CLK_FREQ = 74_250_000
)(
  input  clk_i,
  input  srst_i,
  output cam_pwup_o
);

localparam int CLK_T          = 64'd1_000_000_000_000 / CLK_FREQ;
localparam int TICKS_IN_PULSE = 64'd100_000_000_000 / CLK_T;
localparam int CNT_WIDTH      = $clog2( TICKS_IN_PULSE );

logic [CNT_WIDTH - 1 : 0] cnt;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    cnt <= '0;
  else
    if( cnt < TICKS_IN_PULSE )
      cnt <= cnt + 1'b1;

assign cam_pwup_o = cnt == TICKS_IN_PULSE;

endmodule
