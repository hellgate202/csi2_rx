module csi2_px_serializer
(
  input                 clk_i, 
  input                 rst_i,
  input                 frame_start_i,
  axi4_stream_if.slave  pkt_i,
  axi4_stream_if.master pkt_o
);

logic          start_flag;
logic          last_word;
logic [39 : 0] tdata_d1;

always_ff @( posedge clk_i, posedge rst_i  )
  if( rst_i )
    start_flag <= 1'b0;
  else
    if( frame_start_i )
      start_flag <= 1'b1;
    else
      if( pkt_o.tvalid && pkt_o.tready )
        start_flag <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    tdata_d1 <= '0;
  else
    if( pkt_i.tvalid && pkt_i.tready )
      tdata_d1 <= pkt_i.tdata;

enum logic [1 : 0] { PX_0_S,
                     PX_1_S,
                     PX_2_S,
                     PX_3_S } state, next_state;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    state <= PX_0_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      PX_0_S:
        begin
          if( pkt_i.tvalid && pkt_o.tready )
            next_state = PX_1_S;
        end
      PX_1_S:
        begin
          if( pkt_o.tready )
            next_state = PX_2_S;
        end
      PX_2_S:
        begin
          if( pkt_o.tready )
            next_state = PX_3_S;
        end
      PX_3_S:
        begin
          if( pkt_o.tready )
            next_state = PX_0_S;
        end
    endcase
  end

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    last_word <= '0;
  else
    if( state == PX_0_S && pkt_i.tlast && pkt_i.tvalid &&
        pkt_i.tready )
      last_word <= 1'b1;
    else
      if( state == PX_3_S )
        last_word <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_o.tdata <= '0;
  else
    case( state )
    PX_0_S:
      begin
        if( pkt_i.tvalid && pkt_o.tready )
          pkt_o.tdata <= { 6'd0, pkt_i.tdata[7 : 0], pkt_i.tdata[33 : 32] };
      end
    PX_1_S:
      begin
        if( pkt_o.tready )
          pkt_o.tdata <= { 6'd0, tdata_d1[15 : 8], tdata_d1[35 : 34] };
      end
    PX_2_S:
      begin
        if( pkt_o.tready )
          pkt_o.tdata <= { 6'd0, tdata_d1[23 : 16], tdata_d1[37 : 36] };
      end
    PX_3_S:
      begin
        if( pkt_o.tready )
          pkt_o.tdata <= { 6'd0, tdata_d1[31 : 24], tdata_d1[39 : 38] };
      end
    endcase

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_o.tvalid <= '0;
  else
    if( state == PX_0_S )
      if( pkt_i.tvalid && pkt_o.tready )
        pkt_o.tvalid <= 1'b1;
      else
        if( pkt_o.tready )
          pkt_o.tvalid <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_o.tlast <= '0;
  else
    if( state == PX_3_S && last_word )
      pkt_o.tlast <= 1'b1;
    else
      if( pkt_o.tready )
        pkt_o.tlast <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_o.tuser <= 1'b0;
  else
    if( state == PX_0_S && pkt_i.tvalid && start_flag )
      pkt_o.tuser <= 1'b1;
    else
      if( pkt_o.tready )
        pkt_o.tuser <= 1'b0;

assign pkt_i.tready = ( state == PX_0_S ) ? 1'b1 : 1'b0;

assign pkt_o.tkeep = 2'b11;
assign pkt_o.tstrb = 2'b11;

endmodule
