module csi2_hamming_dec
(
  input                 clk_i,
  input                 srst_i,
(* mark_debug = "true" *)  input                 valid_i,
(* mark_debug = "true" *)  input        [31 : 0] data_i,
(* mark_debug = "true" *)  input                 pkt_done_i,
(* mark_debug = "true" *)  output logic          error_o,
(* mark_debug = "true" *)  output logic          error_corrected_o,
(* mark_debug = "true" *)  output logic [31 : 0] data_o,
(* mark_debug = "true" *)  output logic          valid_o
);

localparam INIT_PATH = "../../../../../err_bit_pos_lut.txt";

(* mark_debug = "true" *) logic [5 : 0]  generated_parity;
logic [5 : 0]  syndrome;
logic [4 : 0]  err_bit_pos;
logic [31 : 0] data_d;
logic          valid_d;
logic          header_valid;
logic          header_passed;
logic          error_detected;

assign syndrome     = generated_parity ^ data_i[29 : 24];
assign header_valid = valid_d && !header_passed && !pkt_done_i;

/* DBG STUFF */

localparam int DBG_CNT_W = $clog2( 52_500_000 );

(* mark_debug = "true" *) logic [DBG_CNT_W - 1 : 0] dbg_cnt;
(* mark_debug = "true" *) logic [DBG_CNT_W - 1 : 0] err_cnt;
(* mark_debug = "true" *) logic [DBG_CNT_W - 1 : 0] err_lock;
(* mark_debug = "true" *) logic [DBG_CNT_W - 1 : 0] corr_err_cnt;
(* mark_debug = "true" *) logic [DBG_CNT_W - 1 : 0] corr_err_lock;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    dbg_cnt <= '0;
  else
    if( dbg_cnt == 'd52_500_000 )
      dbg_cnt <= '0;
    else
      dbg_cnt <= dbg_cnt + 1'b1;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    begin
      err_cnt      <= '0;
      corr_err_cnt <= '0;
    end
  else
    if( dbg_cnt == 'd52_500_000 )
      begin
        err_cnt      <= '0;
        corr_err_cnt <= '0;
      end
    else
      if( header_valid && error_detected )
        begin
          err_cnt <= err_cnt + 1'b1;
          if( err_bit_pos != 5'h1f )
            corr_err_cnt <= corr_err_cnt + 1'b1; 
        end

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    begin
      err_lock      <= '0;
      corr_err_lock <= '0;
    end
  else
    if( dbg_cnt == 'd52_500_000 )
      begin
        err_lock      <= err_cnt;
        corr_err_lock <= corr_err_cnt;
      end

/* DBG STUFF */

always_ff @( posedge clk_i )
  if( srst_i )
    header_passed <= 1'b0;
  else
    if( pkt_done_i )
      header_passed <= 1'b0;
    else
      if( header_valid )
        header_passed <= 1'b1;

always_ff @( posedge clk_i )
  if( srst_i )
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
  if( srst_i )
    begin
      data_d  <= '0;
      valid_d <= '0;
    end
  else
    if( pkt_done_i )
      begin
        data_d  <= 32'd0;
        valid_d <= 1'b0;
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
  .rst_i             ( srst_i         ),
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
  if( srst_i )
    error_o <= 1'b0;
  else
    if( pkt_done_i )
      error_o <= 1'b0;
    else
      if( header_valid && error_detected )
        error_o <= 1'b1;

always_ff @( posedge clk_i )
  if( srst_i )
    error_corrected_o <= 1'b0;
  else
    if( pkt_done_i )
      error_corrected_o <= 1'b0;
    else
      if( header_valid && error_detected && err_bit_pos != 5'h1f )
        error_corrected_o <= 1'b1;

always_ff @( posedge clk_i )
  if( srst_i )
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
  if( srst_i )
    valid_o <= 1'b0;
  else
    if( pkt_done_i )
      valid_o <= 1'b0;
    else
      valid_o <= valid_d;

endmodule
