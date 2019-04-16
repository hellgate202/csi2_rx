module csi2_crc_calc
(
  input                 clk_i,
  input                 rst_i,
  axi4_stream_if.slave  csi2_pkt_i,
  output logic          crc_passed_o,
  output logic          crc_failed_o
);

localparam int CSI2_CRC_POLY = 16'h1021;

logic [15 : 0] main_crc;
logic [15 : 0] crc_8bit;
logic [15 : 0] crc_8bit_prev;
logic [15 : 0] crc_16bit;
logic [15 : 0] crc_16bit_prev;
logic [15 : 0] crc_24bit;
logic [15 : 0] crc_24bit_prev;
logic          payload_in_progress;
logic          long_pkt_payload_valid;
logic [31 : 0] long_pkt_payload;
logic          long_pkt_eop;
logic          long_pkt_eop_d1;
logic          crc_passed;
logic          crc_failed;

assign long_pkt_payload       = csi2_pkt_i.tdata;
assign long_pkt_payload_valid = csi2_pkt_i.tvalid && payload_in_progress;
assign long_pkt_eop           = csi2_pkt_i.tlast && payload_in_progress;

logic [31 : 0] tdata;
logic [3 : 0]  tstrb;
logic          tvalid;
logic          tlast;

assign tdata  = csi2_pkt_i.tdata;
assign tstrb  = csi2_pkt_i.tstrb;
assign tvalid = csi2_pkt_i.tvalid;
assign tlast  = csi2_pkt_i.tlast;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    payload_in_progress <= '0;
  else
    if( !payload_in_progress && csi2_pkt_i.tvalid &&
        csi2_pkt_i.tdata[7 : 0] > 8'hf )
      payload_in_progress <= 1'b1;
    else
      if( payload_in_progress && csi2_pkt_i.tvalid &&
          csi2_pkt_i.tlast )
        payload_in_progress <= 1'b0;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    long_pkt_eop_d1 <= 1'b0;
  else
    long_pkt_eop_d1 <= long_pkt_eop;

crc_calc #(
  .POLY         ( CSI2_CRC_POLY          ),
  .CRC_SIZE     ( 16                     ),
  .DATA_WIDTH   ( 32                     ),
  .INIT         ( 16'hffff               ),
  .REF_IN       ( 1                      ),
  .REF_OUT      ( 1                      ),
  .XOR_OUT      ( 16'h0                  )
) main_calc (
  .clk_i        ( clk_i                  ),
  .rst_i        ( rst_i                  ),
  .soft_reset_i ( long_pkt_eop_d1        ),
  .valid_i      ( long_pkt_payload_valid ),
  .data_i       ( long_pkt_payload       ),
  .crc_o        ( main_crc               )
);

always_comb
  begin
    crc_8bit      = main_crc;
    crc_8bit_prev = main_crc;
    for( int i = 0; i < 8; i++ )
      begin
        crc_8bit[15] = crc_8bit_prev[0] ^ long_pkt_payload[i];
        for( int j = 1; j < 16; j++ )
          if( CSI2_CRC_POLY[j] )
            crc_8bit[15 - j] = crc_8bit_prev[16 - j] ^ crc_8bit_prev[0] ^ 
                               long_pkt_payload[i];
          else
            crc_8bit[15 - j] = crc_8bit_prev[16 - j];
        crc_8bit_prev = crc_8bit;
      end
  end

always_comb
  begin
    crc_16bit      = main_crc;
    crc_16bit_prev = main_crc;
    for( int i = 0; i < 16; i++ )
      begin
        crc_16bit[15] = crc_16bit_prev[0] ^ long_pkt_payload[i];
        for( int j = 1; j < 16; j++ )
          if( CSI2_CRC_POLY[j] )
            crc_16bit[15 - j] = crc_16bit_prev[16 - j] ^ crc_16bit_prev[0] ^ 
                                long_pkt_payload[i];
          else
            crc_16bit[15 - j] = crc_16bit_prev[16 - j];
        crc_16bit_prev = crc_16bit;
      end
  end

always_comb
  begin
    crc_24bit      = main_crc;
    crc_24bit_prev = main_crc;
    for( int i = 0; i < 24; i++ )
      begin
        crc_24bit[15] = crc_24bit_prev[0] ^ long_pkt_payload[i];
        for( int j = 1; j < 16; j++ )
          if( CSI2_CRC_POLY[j] )
            crc_24bit[15 - j] = crc_24bit_prev[16 - j] ^ crc_24bit_prev[0] ^ 
                               long_pkt_payload[i];
          else
            crc_24bit[15 - j] = crc_24bit_prev[16 - j];
        crc_24bit_prev = crc_24bit;
      end
  end

assign crc_passed = ( long_pkt_eop &&
                      ( ( csi2_pkt_i.tstrb == 4'b0001 && crc_8bit  == '0 ) ||
                        ( csi2_pkt_i.tstrb == 4'b0011 && crc_16bit == '0 ) ||
                        ( csi2_pkt_i.tstrb == 4'b0111 && crc_24bit == '0 ) ||
                        ( csi2_pkt_i.tstrb == 4'b1111 && main_crc  == '0 ) ) );

assign crc_failed = ( long_pkt_eop &&
                      ( ( csi2_pkt_i.tstrb == 4'b0001 && crc_8bit  != '0 ) ||
                        ( csi2_pkt_i.tstrb == 4'b0011 && crc_16bit != '0 ) ||
                        ( csi2_pkt_i.tstrb == 4'b0111 && crc_24bit != '0 ) ||
                        ( csi2_pkt_i.tstrb == 4'b1111 && main_crc  != '0 ) ) );


always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      crc_passed_o <= '0;
      crc_failed_o <= '0;
    end
  else
    begin
      crc_passed_o <= crc_passed;
      crc_failed_o <= crc_failed;
    end


endmodule
