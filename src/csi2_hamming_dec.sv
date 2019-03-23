module csi2_hamming_dec
(
  input                 clk_i,
  input                 rst_i,
  input                 valid_i,
  input        [31 : 0] data_i,
  input                 pkt_done_i,
  output logic          error_o,
  output logic          error_corrected_o,
  output logic [31 : 0] data_o,
  output logic          valid_o
);

localparam string INIT_PATH = "./err_bit_pos_lut.txt";

logic [5 : 0]  generated_parity;
logic [5 : 0]  syndrome;
logic [4 : 0]  err_bit_pos;
logic [31 : 0] data_d;
logic          valid_d;
logic          header_valid;
logic          header_passed;
logic          error_detected;

assign syndrome     = generated_parity ^ data_i[29 : 24];
assign header_valid = valid_d && !header_passed;

always_ff @( posedge clk_i )
  if( rst_i )
    header_passed <= 1'b0;
  else
    if( header_valid )
      header_passed <= 1'b1;
    else
      if( pkt_done_i )
        header_passed <= 1'b0;

always_ff @( posedge clk_i )
  if( rst_i )
    error_detected <= 1'b0;
  else
    if( pkt_done_i )
      error_detected <= 1'b0;
    else
      if( syndrome != 6'd0 )
        error_detected <= 1'b1;
      else
        error_detected <= 1'b0;

always_ff @( posedge clk_i )
  if( rst_i )
    begin
      data_d  <= '0;
      valid_d <= '0;
    end
  else
    begin
      data_d  <= data_i;
      valid_d <= valid_i;
    end

always_comb
  begin
    generated_parity[0] = data_i[0]  ^ data_i[1]  ^ data_i[2]  ^ data_i[4]  ^ data_i[5]  ^
                          data_i[7]  ^ data_i[10] ^ data_i[11] ^ data_i[13] ^ data_i[16] ^
                          data_i[20] ^ data_i[21] ^ data_i[22] ^ data_i[23];
    generated_parity[1] = data_i[0]  ^ data_i[1]  ^ data_i[3]  ^ data_i[4]  ^ data_i[6]  ^
                          data_i[8]  ^ data_i[10] ^ data_i[12] ^ data_i[14] ^ data_i[17] ^
                          data_i[20] ^ data_i[21] ^ data_i[22] ^ data_i[23];
    generated_parity[2] = data_i[0]  ^ data_i[2]  ^ data_i[3]  ^ data_i[5]  ^ data_i[6]  ^
                          data_i[9]  ^ data_i[11] ^ data_i[12] ^ data_i[15] ^ data_i[18] ^
                          data_i[20] ^ data_i[21] ^ data_i[22];
    generated_parity[3] = data_i[1]  ^ data_i[2]  ^ data_i[3]  ^ data_i[7]  ^ data_i[8]  ^
                          data_i[9]  ^ data_i[13] ^ data_i[14] ^ data_i[15] ^ data_i[19] ^
                          data_i[20] ^ data_i[21] ^ data_i[23];
    generated_parity[4] = data_i[4]  ^ data_i[5]  ^ data_i[6]  ^ data_i[7]  ^ data_i[8]  ^
                          data_i[9]  ^ data_i[16] ^ data_i[17] ^ data_i[18] ^ data_i[19] ^
                          data_i[20] ^ data_i[22] ^ data_i[23];
    generated_parity[5] = data_i[10] ^ data_i[11] ^ data_i[12] ^ data_i[13] ^ data_i[14] ^
                          data_i[15] ^ data_i[16] ^ data_i[17] ^ data_i[18] ^ data_i[19] ^
                          data_i[21] ^ data_i[22] ^ data_i[23];
  end

dual_port_ram #(
  .DATA_WIDTH        ( 5              ),
  .ADDR_WIDTH        ( 6              ),
  .INIT_FILE         ( INIT_PATH      )
) err_bit_pos_lut (
  .rst_i             ( rst_i          ),
  .wr_clk_i          ( clk_i          ),
  .wr_addr_i         ( 6'd0           ),
  .wr_data_i         ( 5'd0           ),
  .wr_i              ( 1'b0           ),
  .rd_clk_i          ( clk_i          ),
  .rd_addr_i         ( syndrome       ),
  .rd_data_o         ( err_bit_pos    ),
  .rd_i              ( 1'b1           )
);

always_ff @( posedge clk_i )
  if( rst_i )
    error_o <= 1'b0;
  else
    if( pkt_done_i )
      error_o <= 1'b0;
    else
      if( header_valid && error_detected )
        error_o <= 1'b1;

always_ff @( posedge clk_i )
  if( rst_i )
    error_corrected_o <= 1'b0;
  else
    if( pkt_done_i )
      error_corrected_o <= 1'b0;
    else
      if( header_valid && error_detected && err_bit_pos != 5'h1f )
        error_corrected_o <= 1'b1;

always_ff @( posedge clk_i )
  if( rst_i )
    data_o <= '0;
  else
    begin
      data_o <= data_d;
      if( header_valid && error_detected && err_bit_pos != 5'h1f )
        for( int i = 0; i < 24; i++ )
          if( i == err_bit_pos )
            data_o[i] <= ~data_d[i];
    end

always_ff @( posedge clk_i )
  if( rst_i )
    valid_o <= 1'b0;
  else
    valid_o <= valid_d;

endmodule
