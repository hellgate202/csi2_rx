module clk_detect #(
  parameter int REF_TICKS_TO_ABSENCE  = 10,
  parameter int OBS_TICKS_TO_PRESENCE = 3
)(
  input  ref_clk_i,
  input  obs_clk_i,
  input  srst_i,
  output clk_present_o
);

localparam int ABSENCE_CNT_W  = $clog2( REF_TICKS_TO_ABSENCE );
localparam int PRESENCE_CNT_W = $clog2( OBS_TICKS_TO_PRESENCE );

(* mark_debug = "true" *)logic                          toggle_bit = 1'b0;
(* mark_debug = "true" *)logic                          toggle_bit_s1;
(* mark_debug = "true" *)logic                          toggle_bit_s2;
(* mark_debug = "true" *)logic                          toggle_bit_s3;
(* mark_debug = "true" *)logic [ABSENCE_CNT_W - 1 : 0]  clk_absence_cnt;
(* mark_debug = "true" *)logic [PRESENCE_CNT_W - 1 : 0] clk_presence_cnt;
(* mark_debug = "true" *)logic                          clk_absent;
(* mark_debug = "true" *)logic                          clk_edge;

always_ff @( posedge obs_clk_i )
  toggle_bit <= !toggle_bit;

always_ff @( posedge ref_clk_i )
  begin
    toggle_bit_s1 <= toggle_bit;
    toggle_bit_s2 <= toggle_bit_s1;
    toggle_bit_s3 <= toggle_bit_s2;
  end

assign clk_edge = toggle_bit_s2 ^ toggle_bit_s3;

always_ff @( posedge ref_clk_i )
  if( srst_i )
    clk_absence_cnt <= '0;
  else
    if( clk_edge )
      clk_absence_cnt <= '0;
    else
      if( clk_absence_cnt < REF_TICKS_TO_ABSENCE )
        clk_absence_cnt <= clk_absence_cnt + 1'b1;

assign clk_absent = clk_absence_cnt == REF_TICKS_TO_ABSENCE;

always_ff @( posedge ref_clk_i )
  if( srst_i )
    clk_presence_cnt <= '0;
  else
    if( clk_absent )
      clk_presence_cnt <= '0;
    else
      if( clk_presence_cnt < OBS_TICKS_TO_PRESENCE && clk_edge )
        clk_presence_cnt <= clk_presence_cnt + 1'b1;

assign clk_present_o = clk_presence_cnt == OBS_TICKS_TO_PRESENCE;

endmodule
