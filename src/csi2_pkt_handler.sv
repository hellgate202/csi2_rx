import csi2_data_types_pkg::*;

module csi2_pkt_handler
(
  input                 clk_i,
  input                 srst_i,
  axi4_stream_if.slave  pkt_i,
  output logic          frame_start_o,
  output logic          frame_end_o,
  axi4_stream_if.master pkt_o
);

assign pkt_i.tready = pkt_o.tready;

enum logic [1 : 0] { IDLE_S,
                     RUN_S,
                     IGNORE_CRC_S } state, next_state;

logic [15 : 0] byte_cnt, byte_cnt_comb;
logic [15 : 0] pkt_size;

always_ff @( posedge clk_i )
  if( srst_i )
    state <= IDLE_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      IDLE_S:
        begin
          if( pkt_i.tvalid && pkt_i.tready &&
              pkt_i.tdata[5 : 0] > 6'hf )
            next_state = RUN_S;
        end
      RUN_S:
        begin
          if( pkt_i.tready &&
              byte_cnt >= pkt_size )
            if( pkt_size[1 : 0] == 2'd0 || pkt_size[1 : 0] == 2'd3 )
              next_state = IGNORE_CRC_S;
            else
              next_state = IDLE_S;
        end
      IGNORE_CRC_S:
        begin
          if( pkt_i.tready )
            next_state = IDLE_S;
        end
    endcase
  end

always_ff @( posedge clk_i )
  if( srst_i )
    pkt_size <= '0;
  else
    if( state == IDLE_S && pkt_i.tvalid && pkt_i.tready &&
        pkt_i.tdata[5 : 0] > 6'hf )
      pkt_size <= pkt_i.tdata[23 : 8];

always_ff @( posedge clk_i )
  if ( srst_i )
    byte_cnt <= '0;
  else
    byte_cnt <= byte_cnt_comb;

always_comb
  begin
    byte_cnt_comb = byte_cnt;
    if( state == RUN_S )
      begin
        if( pkt_i.tvalid && pkt_i.tready )
          for( int i = 0; i < 4; i ++ )
            if( pkt_i.tstrb[i] )
              byte_cnt_comb = byte_cnt_comb + 1'b1;
      end
    else
      byte_cnt_comb = '0;
  end

always_ff @( posedge clk_i )
  if( srst_i )
    frame_start_o <= '0;
  else
    if( pkt_i.tvalid && pkt_i.tready )
      if( pkt_i.tdata[5 : 0] == FRAME_START && state == IDLE_S )
        frame_start_o <= 1'b1;
      else
        frame_start_o <= 1'b0;

always_ff @( posedge clk_i )
  if( srst_i )
    frame_end_o <= '0;
  else
    if( pkt_i.tvalid && pkt_i.tready  )
      if( pkt_i.tdata[5 : 0] == FRAME_END && state == IDLE_S )
        frame_end_o <= 1'b1;
      else
        frame_end_o <= 1'b0;

always_ff @( posedge clk_i )
  if( srst_i )
    pkt_o.tdata <= '0;
  else
    if( pkt_i.tvalid && pkt_i.tready )
      pkt_o.tdata <= pkt_i.tdata;

always_ff @( posedge clk_i )
  if( srst_i )
    pkt_o.tvalid <= '0;
  else
    if( state == RUN_S && pkt_i.tvalid && 
        pkt_i.tready && byte_cnt < pkt_size )
      pkt_o.tvalid <= 1'b1;
    else
      if( pkt_i.tready )
        pkt_o.tvalid <= 1'b0;

always_ff @( posedge clk_i )
  if( srst_i )
    begin
      pkt_o.tstrb <= '0;
      pkt_o.tlast <= '0;
    end
  else
    if( state == RUN_S && byte_cnt_comb >= pkt_size &&
        byte_cnt < pkt_size )
      begin
        if( pkt_size[1 : 0] )
          for( int i = 0; i < 4; i++ )
            if( i < pkt_size[1 : 0] )
              pkt_o.tstrb[i] <= 1'b1;
            else
              pkt_o.tstrb[i] <= 1'b0;
        pkt_o.tlast <= 1'b1;
      end
    else
      if( pkt_i.tready )
        begin
          pkt_o.tstrb <= '1;
          pkt_o.tlast <= 1'b0;
        end

assign pkt_o.tkeep = pkt_o.tstrb;
assign pkt_o.tid   = '0;
assign pkt_o.tdest = '0;
assign pkt_o.tuser = '0;

endmodule
