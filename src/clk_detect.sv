/*
  Module to detect input clock
  It assert clk_present_o signal when observed
  clk is running for some time
*/

module clk_detect #(
  parameter int REF_TICKS_TO_ABSENCE  = 10,
  parameter int OBS_TICKS_TO_PRESENCE = 3
)(
  // 200 MHz reference clk
  input  ref_clk_i,
  // Observed clk
  input  obs_clk_i,
  input  rst_i,
  output clk_present_o
);

localparam int ABSENCE_CNT_W  = $clog2( REF_TICKS_TO_ABSENCE );
localparam int PRESENCE_CNT_W = $clog2( OBS_TICKS_TO_PRESENCE );

logic                          toggle_bit = 1'b0;
logic                          toggle_bit_s1;
logic                          toggle_bit_s2;
logic                          toggle_bit_s3;
logic [ABSENCE_CNT_W - 1 : 0]  clk_absence_cnt;
logic [PRESENCE_CNT_W - 1 : 0] clk_presence_cnt;
logic                          clk_absent;
logic                          clk_edge;

// Bit that toggles on observed clk
always_ff @( posedge obs_clk_i )
  toggle_bit <= !toggle_bit;

// Metastability protection
always_ff @( posedge ref_clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        toggle_bit_s1 <= '0;
        toggle_bit_s2 <= '0;
        toggle_bit_s3 <= '0;
      end
    else
      begin
        toggle_bit_s1 <= toggle_bit;
        toggle_bit_s2 <= toggle_bit_s1;
        toggle_bit_s3 <= toggle_bit_s2;
      end
  end

// Edge that indicate observed clock running
assign clk_edge = toggle_bit_s2 ^ toggle_bit_s3;

// If toggle_bit doesn't change its value for some time
// we decide that clock is absent
always_ff @( posedge ref_clk_i, posedge rst_i )
  if( rst_i )
    clk_absence_cnt <= '0;
  else
    if( clk_edge )
      clk_absence_cnt <= '0;
    else
      if( clk_absence_cnt < REF_TICKS_TO_ABSENCE )
        clk_absence_cnt <= clk_absence_cnt + 1'b1;

assign clk_absent = clk_absence_cnt == REF_TICKS_TO_ABSENCE;

// If toggle_bit change its value several times
// then clock is running
always_ff @( posedge ref_clk_i, posedge rst_i )
  if( rst_i )
    clk_presence_cnt <= '0;
  else
    if( clk_absent )
      clk_presence_cnt <= '0;
    else
      if( clk_presence_cnt < OBS_TICKS_TO_PRESENCE && clk_edge )
        clk_presence_cnt <= clk_presence_cnt + 1'b1;

assign clk_present_o = clk_presence_cnt == OBS_TICKS_TO_PRESENCE;

endmodule
