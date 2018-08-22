module dphy_clk_detect
(
  input        ref_clk_i,
  input        byte_clk_i,
  input        enable_i,
  input        rst_i,
  output logic rst_o
);

logic [3:0] clk_presence_cnt;
logic [7:0] clk_absent_cnt;
logic       byte_clk_d1;
logic       byte_clk_d2;
logic       clk_absent;


always_ff @( posedge byte_clk_i, posedge rst_i )
  if( rst_i )
    clk_presence_cnt <= '0;
  else
    if( clk_absent )
      clk_presence_cnt <= '0;
    else
      if( enable_i && clk_presence_cnt < 4'd3 )
        clk_presence_cnt <= clk_presence_cnt + 1'b1;

always_ff @( posedge ref_clk_i )
  begin
    byte_clk_d1 <= byte_clk_i;
    byte_clk_d2 <= byte_clk_d1;
  end

always_ff @( posedge ref_clk_i )
  if( byte_clk_d1 != byte_clk_d2 )
    clk_absent_cnt <= '0;
  else
    if( clk_absent_cnt < 8'd250 )
      clk_absent_cnt <= clk_absent_cnt + 1'b1;

assign clk_absent = ( clk_absent_cnt >= 8'd200 );
assign rst_o      = ( clk_presence_cnt < 4'd2 );

endmodule
