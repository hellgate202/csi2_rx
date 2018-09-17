module csi2_crc_calc #(
  parameter [63:0] POLY       = 16'h1021,
  parameter        CRC_SIZE   = 16,
  parameter        DATA_WIDTH = 8,
  parameter        REF_IN     = "TRUE",
  parameter        REF_OUT    = "TRUE",
  parameter [63:0] XOR_OUT    = 16'h0000
)(
  input                   clk_i,
  input                   rst_i,
  input                   soft_reset_i,
  input                   valid_i,
  input  [CRC_SIZE-1:0]   init_i,
  input  [DATA_WIDTH-1:0] data_i,
  output [CRC_SIZE-1:0]   crc_o
);

logic [CRC_SIZE-1:0] crc;
logic [CRC_SIZE-1:0] crc_next;
logic [CRC_SIZE-1:0] crc_prev;

always_ff @( posedge clk_i )
  if( rst_i )
    crc <= 16'd0;
  else
    if( soft_reset_i )
      crc <= init_i;
    else
      if( valid_i )
        crc <= crc_next;

int i,j;

assign crc_o = crc ^ XOR_OUT[CRC_SIZE-1:0];

generate
  begin : calc_gen
    always_comb
      begin
        crc_next = crc;
        crc_prev = crc;
        if( REF_OUT == "TRUE" )
          for( i = 0; i < DATA_WIDTH; i++ )
            if( REF_IN == "TRUE" )
              begin
                crc_next[CRC_SIZE-1] = crc_prev[0] ^ data_i[i];
                for( j = 1; j < CRC_SIZE; j++ )
                  if( POLY[j] )
                    crc_next[CRC_SIZE-1-j] = crc_prev[CRC_SIZE-j] ^ crc_prev[0] ^ data_i[i];
                  else
                    crc_next[CRC_SIZE-1-j] = crc_prev[CRC_SIZE-j]; 
                 crc_prev = crc_next;
              end
            else
              begin
                crc_next[0] = crc_prev[CRC_SIZE-1] ^ data_i[i];
                for( j = 1; j < CRC_SIZE; j++ )
                  if( POLY[j] )
                    crc_next[j] = crc_prev[j-1] ^ crc_prev[CRC_SIZE-1] ^ data_i[i];
                  else
                    crc_next[j] = crc_prev[j-1];
                crc_prev = crc_next;
              end
        else
          for( i = 0; i < DATA_WIDTH; i++ )
            if( REF_IN == "TRUE" )
              begin
                crc_next[CRC_SIZE-1] = crc_prev[0] ^ data_i[DATA_WIDTH-1-i];
                for( j = 1; j < CRC_SIZE; j++ )
                  if( POLY[j] )
                    crc_next[CRC_SIZE-1-j] = crc_prev[CRC_SIZE-j] ^ crc_prev[0] ^ data_i[DATA_WIDTH-1-i];
                  else
                    crc_next[CRC_SIZE-1-j] = crc_prev[CRC_SIZE-j];
                crc_prev = crc_next;
              end
            else
              begin
                crc_next[0] = crc_prev[CRC_SIZE-1] ^ data_i[DATA_WIDTH-1-i];
                for( j = 1; j < CRC_SIZE; j++ )
                  if( POLY[j] )
                    crc_next[j] = crc_prev[j-1] ^ crc_prev[CRC_SIZE-1] ^ data_i[DATA_WIDTH-1-i];
                  else
                    crc_next[j] = crc_prev[j-1];
                crc_prev = crc_next;
              end
      end
  end
endgenerate

endmodule
