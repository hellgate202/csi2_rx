module dphy_clk_detect
(
  input        ref_clk_i,
  input        byte_clk_i,
  input        enable_i,
  input        rst_i,
  output logic rst_o
);

logic       toggle_byte;
logic       toggle_byte_s1;
logic       toggle_byte_s2;
logic       toggle_byte_s3;
logic [7:0] clk_absence_cnt;
logic [1:0] clk_presence_cnt;
logic       clk_absent;
logic       clk_edge;

assign clk_absent = ( clk_absence_cnt >= 8'd200 );
assign clk_edge   = ( toggle_byte_s2 ^ toggle_byte_s3 );

always_ff @( posedge byte_clk_i, posedge rst_i )
  if( rst_i )
    toggle_byte <= 1'b0;
  else
    toggle_byte <= ~toggle_byte;

always_ff @( posedge ref_clk_i )
  begin
    toggle_byte_s1 <= toggle_byte;
    toggle_byte_s2 <= toggle_byte_s1;
    toggle_byte_s3 <= toggle_byte_s2;
  end

always_ff @( posedge ref_clk_i )
  if( rst_i )
    clk_absence_cnt <= '0;
  else
    if( clk_edge )
      clk_absence_cnt <= '0;
    else
      if( clk_absence_cnt < 8'd250 )
        clk_absence_cnt <= clk_absence_cnt + 1'b1;

always_ff @( posedge ref_clk_i )
  if( rst_i )
    clk_presence_cnt <= '0;
  else
    if( clk_absent )
      clk_presence_cnt <= '0;
    else
      if( enable_i && clk_presence_cnt < 2'd3 && clk_edge )
        clk_presence_cnt <= clk_presence_cnt + 1'b1;

assign rst_o = ( clk_presence_cnt < 2'd2 );

endmodule
