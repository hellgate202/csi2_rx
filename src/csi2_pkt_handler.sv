module csi2_pkt_handler
(
  input               clk_i,
  input               rst_i,
  input               valid_i,
  input        [31:0] data_i,
  input               error_i,
  input               error_corrected_i,
  output logic        short_pkt_o,
  output logic        long_pkt_o,
  output logic [1:0]  virtual_channel_o,
  output logic [5:0]  data_type_o,
  output logic [31:0] payload_data_o,
  output logic        valid_o,
  output logic        pkt_done_o,
  output logic        crc_check_o
);

logic        valid_d1;
logic        header_valid;
logic        pkt_running;
logic [15:0] byte_cnt;
logic [15:0] byte_amount;

// Valid positive edge detection
always_ff @( posedge clk_i )
  if( rst_i )
    valid_d1 <= 1'b0;
  else
    valid_d1 <= valid_i;

assign header_valid = ( ( valid_i && ~valid_d1 ) && 
                        ( ~error_i || ( error_i && error_corrected_i ) ) &&
                        ~pkt_running );

// Latching header info
always_ff @( posedge clk_i )
  if( rst_i )
    begin
      byte_amount       <= '0;
      data_type_o       <= '0;
      virtual_channel_o <= '0;
    end
  else
    if( header_valid )
      begin
        byte_amount       <= data_i[23:8];
        data_type_o       <= data_i[29:24];
        virtual_channel_o <= data_i[31:30];
      end

always_ff @( posedge clk_i )
  if( rst_i )
    pkt_running <= 1'b0;
  else
    if( header_valid )
      pkt_running <= 1'b1;
    else
      if( pkt_done_o )
        pkt_running <= 1'b0;

// Payload bytes counting
always_ff @( posedge clk_i )
  if( rst_i )
    byte_cnt <= '0;
  else
    if( pkt_done_o )
      byte_cnt <= '0;
    else
      if( valid_o )
        byte_cnt <= byte_cnt + 16'd4;

assign pkt_done_o = ( ( byte_cnt + 16'd4 ) >= byte_amount ) && valid_i && pkt_running;

assign valid_o = pkt_running && valid_i;
assign payload_data_o = data_i;

endmodule
