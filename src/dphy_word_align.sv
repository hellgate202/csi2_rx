module dphy_word_align #(
  parameter DATA_LANES = 4
)(
  input                              byte_clk_i,
  input                              rst_i,
  input                              enable_i,
  input                              pkt_done_i,
  input                              wait_for_sync_i,
  input        [DATA_LANES-1:0][7:0] byte_data_i,
  input        [DATA_LANES-1:0]      valid_i,
  output logic                       pkt_done_o,
  output logic [DATA_LANES-1:0][7:0] word_o,
  output logic                       valid_o
);

logic [DATA_LANES-1:0][7:0] word_d1;
logic [DATA_LANES-1:0][7:0] word_d2;
logic [DATA_LANES-1:0][7:0] word_d3;
logic [DATA_LANES-1:0]      valid_d1;
logic [DATA_LANES-1:0]      valid_d2;
logic [DATA_LANES-1:0]      valid_d3;
logic [DATA_LANES-1:0][1:0] sel_delay;
logic                       one_lane_sync;
logic                       all_lanes_valid;
logic                       invalid_start;

assign all_lanes_valid = &valid_d1;
assign invalid_start   = one_lane_sync && ~all_lanes_valid;
assign pkt_done_o      = pkt_done_i || invalid_start;

always_ff @( posedge byte_clk_i )
  if( rst_i )
    begin
      word_d1  <= '0;
      word_d2  <= '0;
      word_d3  <= '0;
      valid_d1 <= '0;
      valid_d2 <= '0;
      valid_d3 <= '0;
    end
  else
    if( enable_i )
      begin
        word_d1  <= byte_data_i;
        word_d2  <= word_d1;
        word_d3  <= word_d2;
        valid_d1 <= valid_i;
        valid_d2 <= valid_d1;
        valid_d3 <= valid_d2;
      end

always_ff @( posedge byte_clk_i )
  if( rst_i )
    valid_o <= 1'b0;
  else
    if( all_lanes_valid && ~valid_o && wait_for_sync_i )
      valid_o <= 1'b1;
    else
      if( pkt_done_i )
        valid_o <= 1'b0;

always_comb
  begin
    one_lane_sync = 1'b0;
    for( int i = 0; i < DATA_LANES; i++ )
      if( valid_d1[i] && valid_d2[i] && valid_d3[i] )
        one_lane_sync = 1'b1;
  end
        
always_ff @( posedge byte_clk_i )
  if( rst_i )
    sel_delay <= '0;
  else
    if( all_lanes_valid && ~valid_o && wait_for_sync_i )
      for( int i = 0; i < DATA_LANES; i++ )
        if( valid_d3[i] )
          sel_delay[i] = 2'd2;
        else
          if( valid_d2[i] )
            sel_delay[i] = 2'd1;
          else
            sel_delay[i] = 2'd0;

always_ff @( posedge byte_clk_i )
  if( rst_i )
    word_o <= '0;
  else
    for( int i = 0; i < DATA_LANES; i++ )
      if( sel_delay[i] == 2'd2 )
        word_o[i] <= word_d3[i];
      else
        if( sel_delay[i] == 2'd1 )
          word_o[i] <= word_d2[i];
        else
          word_o[i] <= word_d1[i];

endmodule
