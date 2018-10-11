module csi2_pkt_handler
(
  input               clk_i,
  input               rst_i,
  input               valid_i,
  input        [31:0] data_i,
  input               error_i,
  input               error_corrected_i,

  output logic        short_pkt_valid_o,
  output logic [1:0]  short_pkt_v_channel_o,
  output logic [5:0]  short_pkt_data_type_o,
  output logic [15:0] short_pkt_data_field_o,

  output logic        long_pkt_header_valid_o,
  output logic [1:0]  long_pkt_v_channel_o,
  output logic [5:0]  long_pkt_data_type_o,
  output logic [15:0] long_pkt_word_cnt_o,

  output logic [31:0] long_pkt_payload_o,
  output logic        long_pkt_payload_valid_o,
  output logic [3:0]  long_pkt_payload_be_o,
  // End of packet signal for upper protocol
  output logic        long_pkt_eop_o,
  // Reset DPHY logic and prepare to new packet
  output logic        pkt_done_o
);

logic        valid_d1;
logic        header_valid;
logic        pkt_running;
logic [15:0] byte_cnt;
logic        long_pkt;
logic        short_pkt;
logic        last_word;
logic [3:0]  be_on_last_word;
logic        last_valid;

// Because of that there could be less than 4 data lanes
// valid_i signal won't always be continious. We need to detect
// header, only on first positive edge.

// Valid positive edge detection
always_ff @( posedge clk_i )
  if( rst_i )
    begin
      valid_d1   <= 1'b0;
      last_valid <= 1'b0;
    end
  else
    begin
      valid_d1   <= valid_i;
      last_valid <= pkt_done_o;
    end

// When we detect header the packet starts.
// It ends when we recieve declared amount of words.
always_ff @( posedge clk_i )
  if( rst_i )
    pkt_running <= 1'b0;
  else
    if( header_valid )
      pkt_running <= 1'b1;
    else
      if( pkt_done_o )
        pkt_running <= 1'b0;

assign header_valid = ( ( valid_i && ~valid_d1 ) && // First positive edge of valid signal
                        ( ~error_i || ( error_i && error_corrected_i ) ) && // If header is correct
                        ~pkt_running ); // If we didnt capture any headers before

assign long_pkt     = ( header_valid && data_i[5:0] > 6'hf );
assign short_pkt    = ( header_valid && data_i[5:0] < 6'h10 );

// Headers parsing
always_ff @( posedge clk_i )
  if( rst_i )
    begin
      short_pkt_valid_o      <= 1'b0;
      short_pkt_v_channel_o  <= 2'd0;
      short_pkt_data_type_o  <= 6'd0;
      short_pkt_data_field_o <= 16'd0;
    end
  else
    if( short_pkt )
      begin
        short_pkt_valid_o      <= 1'b1;
        short_pkt_v_channel_o  <= data_i[7:6];
        short_pkt_data_type_o  <= data_i[5:0];
        short_pkt_data_field_o <= data_i[23:8];
      end
    else
      begin
        short_pkt_valid_o      <= 1'b0;
        short_pkt_v_channel_o  <= 2'd0;
        short_pkt_data_type_o  <= 6'd0;
        short_pkt_data_field_o <= 16'd0;
      end

always_ff @( posedge clk_i )
  if( rst_i )
    begin
      long_pkt_header_valid_o <= 1'b0;
      long_pkt_v_channel_o    <= 2'd0;
      long_pkt_data_type_o    <= 6'd0;
      long_pkt_word_cnt_o     <= 16'd0;
    end
  else
    if( long_pkt )
      begin
        long_pkt_header_valid_o  <= 1'b1;
        long_pkt_v_channel_o     <= data_i[7:6];
        long_pkt_data_type_o     <= data_i[5:0];
        long_pkt_word_cnt_o      <= data_i[23:8];
      end
    else
      if( last_valid )
        begin
          long_pkt_header_valid_o <= 1'b0;
          long_pkt_v_channel_o    <= 2'd0;
          long_pkt_data_type_o    <= 6'd0;
          long_pkt_word_cnt_o     <= 16'd0;
        end

// Long packet payload
always_ff @( posedge clk_i )
  if( rst_i )
    begin
      long_pkt_payload_o       <= 32'd0;
      long_pkt_payload_valid_o <= 1'b0;
      long_pkt_payload_be_o    <= 4'd0;
    end
  else
    begin
      long_pkt_payload_o       <= data_i;
      long_pkt_payload_valid_o <= valid_i && pkt_running;
      if( pkt_done_o && |be_on_last_word )
        long_pkt_payload_be_o <= be_on_last_word;
      else
        long_pkt_payload_be_o <= 4'b1111;
    end

// We always count by 4 bytes regardless of size of packet
always_ff @( posedge clk_i )
  if( rst_i )
    byte_cnt <= 16'd0;
  else
    if( pkt_done_o )
      byte_cnt <= 16'd0;
    else
      if( valid_i && pkt_running )
        byte_cnt <= byte_cnt + 16'd4;
      

assign last_word  = ( byte_cnt + 16'd4 ) >= long_pkt_word_cnt_o;
assign pkt_done_o = last_word && pkt_running && valid_i;

always_comb
  for( bit [2:0] i = 3'd0; i <= 3'd3; i++ )
    be_on_last_word[i] = long_pkt_word_cnt_o[1:0] > i;

always_ff @( posedge clk_i )
  if( rst_i )
    long_pkt_eop_o <= 1'b0;
  else
    long_pkt_eop_o <= pkt_done_o;

endmodule
