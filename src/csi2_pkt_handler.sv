import csi2_data_types_pkg::*;

module csi2_pkt_handler
(
  input                 clk_i,
  input                 rst_i,
  input                 sop_i,
  axi4_stream_if.slave  pkt_i,
  axi4_stream_if.master pkt_o
);

assign pkt_i.tready = pkt_o.tready;

enum logic [1 : 0] { IDLE_S,
                     RUN_S,
                     IGNORE_CRC_S } state, next_state;

logic [15 : 0] byte_cnt, byte_cnt_comb;
logic [15 : 0] pkt_size;

logic [31 : 0] pkt_i_tdata  = pkt_i.tdata;
logic          pkt_i_tvalid = pkt_i.tvalid;
logic [3 : 0]  pkt_i_tstrb  = pkt_i.tstrb;
logic          pkt_i_tready = pkt_i.tready;
logic          pkt_i_tlast  = pkt_i.tlast;
logic [31 : 0] pkt_o_tdata  = pkt_o.tdata;
logic          pkt_o_tvalid = pkt_o.tvalid;
logic          pkt_o_tready = pkt_o.tready;
logic          pkt_o_tlast  = pkt_o.tlast;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    state <= IDLE_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      // First word is always a header
      IDLE_S:
        begin
          if( pkt_i.tvalid && pkt_i.tready && sop_i &&
              pkt_i.tdata[5 : 0] == RAW_10 )
            next_state = RUN_S;
        end
      RUN_S:
        begin
          if( pkt_i.tready &&
              byte_cnt_comb >= pkt_size )
            // If last word has only crc bytes - we ignore it
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

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_size <= '0;
  else
    if( state == IDLE_S && pkt_i.tvalid && pkt_i.tready &&
        pkt_i.tdata[5 : 0] == RAW_10 && sop_i )
      pkt_size <= pkt_i.tdata[23 : 8];

always_ff @( posedge clk_i, posedge rst_i )
  if ( rst_i )
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

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_o.tdata <= '0;
  else
    if( pkt_i.tvalid && pkt_i.tready )
      pkt_o.tdata <= pkt_i.tdata;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_o.tvalid <= '0;
  else
    if( state == RUN_S && pkt_i.tvalid && 
        pkt_i.tready && byte_cnt < pkt_size )
      pkt_o.tvalid <= 1'b1;
    else
      if( pkt_i.tready )
        pkt_o.tvalid <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_o.tlast <= '0;
  else
    if( state == RUN_S && byte_cnt_comb >= pkt_size &&
        byte_cnt < pkt_size )
      pkt_o.tlast <= 1'b1;
    else
      if( pkt_i.tready )
        pkt_o.tlast <= 1'b0;

endmodule
