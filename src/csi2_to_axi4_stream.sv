module csi2_to_axi4_stream
(
  input                 clk_i,
  input                 srst_i,
  input                 enable_i,
  input [31 : 0]        data_i,
  input                 valid_i,
  input                 error_i,
  output                phy_rst_o,
  axi4_stream_if.master pkt_o
);

logic          valid_d1;
logic          pkt_running;
logic          last_word;
logic          header_valid;
logic          short_pkt;
logic          long_pkt;
logic [15 : 0] byte_cnt, byte_cnt_comb;
logic          disable_flag;

assign header_valid = valid_i && !valid_d1 && !error_i && 
                      !pkt_running;
assign long_pkt     = header_valid && data_i[5 : 0] >= 6'h10;
assign short_pkt    = header_valid && data_i[5 : 0] <  6'h10;
assign last_word    = pkt_running && byte_cnt_comb == '0;
assign phy_rst_o    = short_pkt || last_word || error_i || disable_flag;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    disable_flag <= 1'b0;
  else
    if( ( !pkt_running && !header_valid || last_word ) && !enable_i )
      disable_flag <= 1'b1;
    else
      if( enable_i )
        disable_flag <= 1'b0;

always_ff @( posedge clk_i )
  if( srst_i )
    valid_d1 <= '0;
  else
    valid_d1 <= valid_i;

always_ff @( posedge clk_i )
  if( srst_i )
    pkt_running <= '0;
  else
    if( long_pkt )
      pkt_running <= 1'b1;
    else
      if( phy_rst_o )
        pkt_running <= 1'b0;

always_ff @( posedge clk_i )
  if( srst_i )
    byte_cnt <= '0;
  else
    byte_cnt <= byte_cnt_comb;

always_comb
  begin
    byte_cnt_comb = byte_cnt;
    if( long_pkt )
      byte_cnt_comb = data_i[23 : 8] + 2'd2;
    else
      if( valid_i )
        if( byte_cnt < 16'd4 )
          byte_cnt_comb = '0;
        else
          byte_cnt_comb = byte_cnt - 3'd4;
  end

always_ff @( posedge clk_i )
  if( srst_i )
    begin
      pkt_o.tvalid <= '0;
      pkt_o.tdata  <= '0;
    end
  else
    if( header_valid || pkt_running && valid_i )
      begin
        pkt_o.tvalid <= 1'b1;
        pkt_o.tdata  <= data_i;
      end
    else
      begin
        pkt_o.tvalid <= 1'b0;
        pkt_o.tdata  <= '0;
      end

always_ff @( posedge clk_i )
  if( srst_i )
    pkt_o.tstrb <= '0;
  else
    if( last_word )
      for( int i = 0; i < 4; i++ )
        if( i < byte_cnt )
          pkt_o.tstrb[i] <= 1'b1;
        else
          pkt_o.tstrb[i] <= 1'b0;
    else
      pkt_o.tstrb <= '1;

always_ff @( posedge clk_i )
  if( srst_i )
    pkt_o.tlast <= '0;
  else
    if( short_pkt || last_word )
      pkt_o.tlast <= 1'b1;
    else
      pkt_o.tlast <= 1'b0;

endmodule
