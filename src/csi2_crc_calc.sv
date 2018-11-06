module csi2_crc_calc
(
  input               clk_i,
  input               rst_i,
  input        [31:0] long_pkt_payload_i,
  input               long_pkt_payload_valid_i,
  input        [3:0]  long_pkt_payload_be_i,
  input               long_pkt_eop_i,
  output logic        crc_passed_o,
  output logic        crc_failed_o
);

localparam CSI2_CRC_POLY = 16'h1021;

// The idea is to calculate CRC on EOP with previous CRC value
// from main CRC calculator

logic [15:0] main_crc;
logic [15:0] crc_8bit;
logic [15:0] crc_16bit;
logic [15:0] crc_24bit;
logic        long_pkt_eop_d1;

always_ff @( posedge clk_i )
  if( rst_i )
    long_pkt_eop_d1 <= 1'b0;
  else
    long_pkt_eop_d1 <= long_pkt_eop_i;

crc_calc #(
  .POLY         ( CSI2_CRC_POLY            ),
  .CRC_SIZE     ( 16                       ),
  .DATA_WIDTH   ( 32                       ),
  .INIT         ( 16'hffff                 ),
  .REF_IN       ( "TRUE"                   ),
  .REF_OUT      ( "TRUE"                   ),
  .XOR_OUT      ( 16'h0                    )
) main_calc (
  .clk_i        ( clk_i                    ),
  .rst_i        ( rst_i                    ),
  .soft_reset_i ( long_pkt_eop_d1          ),
  .valid_i      ( long_pkt_payload_valid_i ),
  .data_i       ( long_pkt_payload_i       ),
  .crc_o        ( main_crc                 )
);

// One byte EOP CRC
always_comb
  begin
    for( int i = 0; i < 8; i++ )
      begin
        crc_8bit[15] = main_crc[0] ^ long_pkt_payload_i[i];
        for( int j = 1; j < 16; j++ )
          if( CSI2_CRC_POLY[j] )
            crc_8bit[15-j] = main_crc[16-j] ^ main_crc[0] ^ long_pkt_payload_i[i];
          else
            crc_8bit[15-j] = main_crc[16-j];
      end
  end

// Two byte EOP CRC
always_comb
  begin
    for( int i = 0; i < 16; i++ )
      begin
        crc_16bit[15] = main_crc[0] ^ long_pkt_payload_i[i];
        for( int j = 1; j < 16; j++ )
          if( CSI2_CRC_POLY[j] )
            crc_16bit[15-j] = main_crc[16-j] ^ main_crc[0] ^ long_pkt_payload_i[i];
          else
            crc_16bit[15-j] = main_crc[16-j];
      end
  end

// Three byte EOP CRC
always_comb
  begin
    for( int i = 0; i < 24; i++ )
      begin
        crc_24bit[15] = main_crc[0] ^ long_pkt_payload_i[i];
        for( int j = 1; j < 16; j++ )
          if( CSI2_CRC_POLY[j] )
            crc_24bit[15-j] = main_crc[16-j] ^ main_crc[0] ^ long_pkt_payload_i[i];
          else
            crc_24bit[15-j] = main_crc[16-j];
      end
  end

assign crc_passed_o = ( long_pkt_eop_d1 &&
                        ( ( long_pkt_payload_be_i == 4'b0001 && ~|crc_8bit  ) ||
                          ( long_pkt_payload_be_i == 4'b0011 && ~|crc_16bit ) ||
                          ( long_pkt_payload_be_i == 4'b0111 && ~|crc_24bit ) ||
                          ( long_pkt_payload_be_i == 4'b1111 && ~|main_crc  ) ) );

assign crc_failed_o = ( long_pkt_eop_d1 && ~crc_passed_o );


endmodule
