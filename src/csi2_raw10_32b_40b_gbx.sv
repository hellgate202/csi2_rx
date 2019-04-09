module csi2_raw10_32b_40b_gbx
(
  input                 clk_i,
  input                 srst_i,
  axi4_stream_if.slave  pkt_i,
  axi4_stream_if.master pkt_o
);

(* mark_debug = "true" *) logic [31 : 0] tdata_d1;
(* mark_debug = "true" *) logic [3 : 0]  tstrb_d1;

assign pkt_i.tready = pkt_o.tready;

(* mark_debug = "true" *) enum logic [2 : 0] { FIRST_WORD_S,
                     SECOND_WORD_S,
                     THIRD_WORD_S,
                     FOURTH_WORD_S,
                     FITH_WORD_S } state, next_state;

always_ff @( posedge clk_i )
  if( srst_i )
    state <= FIRST_WORD_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      FIRST_WORD_S:
        begin
          if( pkt_i.tvalid && pkt_i.tready )
            next_state = SECOND_WORD_S;
        end
      SECOND_WORD_S:
        begin
          if( pkt_i.tvalid && pkt_i.tready )
            if( pkt_i.tlast )
              next_state = FIRST_WORD_S;
            else
              next_state = THIRD_WORD_S;
        end
      THIRD_WORD_S:
        begin
          if( pkt_i.tvalid && pkt_i.tready )
            if( pkt_i.tlast )
              next_state = FIRST_WORD_S;
            else
              next_state = FOURTH_WORD_S;
        end
      FOURTH_WORD_S:
        begin
          if( pkt_i.tvalid && pkt_i.tready )
            if( pkt_i.tlast )
              next_state = FIRST_WORD_S;
            else
              next_state = FITH_WORD_S;
        end
      FITH_WORD_S:
        begin
          if( pkt_i.tvalid && pkt_i.tready )
            next_state = FIRST_WORD_S;
        end
    endcase
  end

always_ff @( posedge clk_i )
  if( srst_i )
    begin
      tdata_d1  <= '0;
      tstrb_d1  <= '0;
    end
  else
    if( pkt_i.tready && pkt_i.tvalid )
      begin
        tdata_d1  <= pkt_i.tdata;
        tstrb_d1  <= pkt_i.tstrb;
      end
    
always_ff @( posedge clk_i )
  if ( srst_i )
    pkt_o.tdata <= '0;
  else
    if( pkt_i.tvalid && pkt_i.tready )
      case( state )
        FIRST_WORD_S:
          begin
            pkt_o.tdata[7 : 0]   <= pkt_i.tdata[7 : 0];
            pkt_o.tdata[15 : 8]  <= pkt_i.tdata[15 : 8];
            pkt_o.tdata[23 : 16] <= pkt_i.tdata[23 : 16];
            pkt_o.tdata[31 : 24] <= pkt_i.tdata[31 : 24];
          end
        SECOND_WORD_S:
          begin
            pkt_o.tdata[39 : 32] <= pkt_i.tdata[7 : 0];
          end
        THIRD_WORD_S:
          begin
            pkt_o.tdata[7 : 0]   <= tdata_d1[15 : 8];
            pkt_o.tdata[15 : 8]  <= tdata_d1[23 : 16];
            pkt_o.tdata[23 : 16] <= tdata_d1[31 : 24];
            pkt_o.tdata[31 : 24] <= pkt_i.tdata[7 : 0];
            pkt_o.tdata[39 : 32] <= pkt_i.tdata[15 : 8];
          end
        FOURTH_WORD_S:
          begin
            pkt_o.tdata[7 : 0]   <= tdata_d1[23 : 16];
            pkt_o.tdata[15 : 8]  <= tdata_d1[31 : 24];
            pkt_o.tdata[23 : 16] <= pkt_i.tdata[7 : 0];
            pkt_o.tdata[31 : 24] <= pkt_i.tdata[15 : 8];
            pkt_o.tdata[39 : 32] <= pkt_i.tdata[23 : 16];
          end
        FITH_WORD_S:
          begin
            pkt_o.tdata[7 : 0]   <= tdata_d1[31 : 24];
            pkt_o.tdata[15 : 8]  <= pkt_i.tdata[7 : 0];
            pkt_o.tdata[23 : 16] <= pkt_i.tdata[15 : 8];
            pkt_o.tdata[31 : 24] <= pkt_i.tdata[23 : 16];
            pkt_o.tdata[39 : 32] <= pkt_i.tdata[31 : 24];
          end
      endcase

always_ff @( posedge clk_i )
  if( srst_i )
    pkt_o.tvalid <= 1'b0;
  else
    if( state != FIRST_WORD_S && pkt_i.tvalid && pkt_i.tready )
      pkt_o.tvalid <= 1'b1;
    else
      if( pkt_o.tready )
        pkt_o.tvalid <= 1'b0;

always_ff @( posedge clk_i )
  if( srst_i )
    pkt_o.tlast <= 1'b0;
  else
    if( pkt_i.tvalid && pkt_i.tready )
      pkt_o.tlast <= pkt_i.tlast;

assign pkt_o.tstrb = '1;
assign pkt_o.tkeep = pkt_o.tstrb;
assign pkt_o.tid   = '0;
assign pkt_o.tuser = '0;
assign pkt_o.tdest = '0;

(* mark_debug = "true" *) logic [31 : 0] pkt_o_tdata;
(* mark_debug = "true" *) logic          pkt_o_tvalid;
(* mark_debug = "true" *) logic          pkt_o_tlast;

assign pkt_o_tdata  = pkt_o.tdata;
assign pkt_o_tvalid = pkt_o.tvalid;
assign pkt_o_tlast  = pkt_o.tlast;

endmodule
