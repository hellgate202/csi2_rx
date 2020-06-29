import csi2_data_types_pkg::*;

module csi2_to_axi4_stream #(
  parameter int FRAMES_TO_IGNORE = 20
)(
  input                 clk_i,
  input                 rst_i,
  // Core enable from CSR
  input                 enable_i,
  input [31 : 0]        data_i,
  input                 valid_i,
  // If there was uncorrectable header error
  input                 error_i,
  output                phy_rst_o,
  axi4_stream_if.master pkt_o,
  output                frame_start_o,
  output                frame_end_o,
  output                header_o
);

localparam int FRAME_CNT_WIDTH = $clog2( FRAMES_TO_IGNORE ) + 1;

logic                           valid_d1;
// Long packet payload
logic                           pkt_running;
logic                           last_word;
logic                           header_valid;
// One word packet
logic                           short_pkt;
logic                           long_pkt;
logic [15 : 0]                  byte_cnt, byte_cnt_comb;
// Synchronized deassertion of enable with end of long packet
logic                           disable_flag;
// Transfer from px_clk to rx_clk domain
logic                           enable_d1;
logic                           enable_d2;
logic                           frame_start;
logic                           frame_end;
logic                           stream_stable;
logic [FRAME_CNT_WIDTH - 1 : 0] ignore_cnt;
logic                           sop;

// First word of correct packet
assign header_valid  = valid_i && !valid_d1 && !error_i && 
                       !pkt_running;
assign long_pkt      = header_valid && data_i[5 : 0] >= 6'h10;
assign short_pkt     = header_valid && data_i[5 : 0] <  6'h10;
assign last_word     = pkt_running && byte_cnt_comb == '0;
assign phy_rst_o     = short_pkt || last_word || error_i || disable_flag;
assign frame_start   = header_valid && data_i[5 : 0] == FRAME_START;
assign frame_end     = header_valid && data_i[5 : 0] == FRAME_END;
assign frame_start_o = frame_start;
assign frame_end_o   = frame_end;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      enable_d1 <= '0;
      enable_d2 <= '0;
    end
  else
    begin
      enable_d1 <= enable_i;
      enable_d2 <= enable_d1;
    end

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    disable_flag <= 1'b0;
  else
    if( ( !pkt_running && !header_valid || last_word ) && !enable_d2 )
      disable_flag <= 1'b1;
    else
      if( enable_d2 )
        disable_flag <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    valid_d1 <= '0;
  else
    valid_d1 <= valid_i;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_running <= '0;
  else
    if( long_pkt )
      pkt_running <= 1'b1;
    else
      if( phy_rst_o )
        pkt_running <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
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

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    ignore_cnt <= '0;
  else
    if( disable_flag )
      ignore_cnt <= '0;
    else
      if( frame_start && ignore_cnt < FRAMES_TO_IGNORE )
        ignore_cnt <= ignore_cnt + 1'b1;

assign stream_stable = ignore_cnt == FRAMES_TO_IGNORE;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      pkt_o.tvalid <= '0;
      pkt_o.tdata  <= '0;
    end
  else
    if( header_valid || pkt_running && valid_i && stream_stable )
      begin
        pkt_o.tvalid <= 1'b1;
        pkt_o.tdata  <= data_i;
      end
    else
      begin
        pkt_o.tvalid <= 1'b0;
        pkt_o.tdata  <= '0;
      end

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
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

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    pkt_o.tlast <= '0;
  else
    if( short_pkt || last_word )
      pkt_o.tlast <= 1'b1;
    else
      pkt_o.tlast <= 1'b0;

assign pkt_o.tkeep = pkt_o.tstrb;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    sop <= 1'b0;
  else
    sop <= header_valid;

assign header_o = sop;

endmodule
