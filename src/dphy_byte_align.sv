module dphy_byte_align
(
  input              clk_i,
  input              rst_i,
  input              enable_i,
  input        [7:0] unaligned_byte_i,
  input              wait_for_sync_i,
  input              packet_done_i,
  output logic       valid_o,
  output logic [7:0] aligned_byte_o
);

localparam [7:0] SYNC_PATTERN = 8'b10111000;
 
logic [7:0]  unaligned_byte_d1;
logic [7:0]  unaligned_byte_d2;
logic [3:0]  sync_offset;
logic [3:0]  align_shift;
logic        found_sync;
logic [15:0] compare_window;

always_ff @( posedge clk_i )
  if( rst_i )
    begin
      unaligned_byte_d1 <= '0;
      unaligned_byte_d2 <= '0;
    end
  else
    if( enable_i )
      begin
        unaligned_byte_d1 <= unaligned_byte_i;
        unaligned_byte_d2 <= unaligned_byte_d1;
      end
     
always_comb
  begin
    sync_offset = 4'd0;
    found_sync  = 1'b0;
    compare_window = {unaligned_byte_d1,unaligned_byte_d2};
    for( bit [3:0] i = 4'd0; i < 4'd8; i++ )
      begin
        compare_window = {unaligned_byte_d1,unaligned_byte_d2} >> i;
        if( compare_window[7:0] == SYNC_PATTERN )
          begin
            sync_offset = i;
            found_sync  = 1'b1;
            break;
          end
      end
  end

always_ff @( posedge clk_i )
  if( rst_i )
    align_shift <= 3'd0;
  else
    if( wait_for_sync_i && found_sync && ~valid_o )
      align_shift <= sync_offset;

always_ff @( posedge clk_i )
  if( rst_i )
    valid_o <= 1'b0;
  else
    if( packet_done_i )
      valid_o <= found_sync;
    else
      if( wait_for_sync_i && found_sync && ~valid_o )
        valid_o <= 1'b1;

always_ff @( posedge clk_i )
  if( rst_i )
    aligned_byte_o <= '0;
  else
    for( bit [3:0] i = 4'd0; i < 4'd8; i++ )
      if( i == align_shift )
        aligned_byte_o <= {unaligned_byte_d1,unaligned_byte_d2} >> i;
      
endmodule
