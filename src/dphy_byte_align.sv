module dphy_byte_align
(
  input              clk_i,
  input              rst_i,
  input              enable_i,
  input        [7:0] unaligned_byte_i,
  input              wait_for_sync_i,
  input              packet_done_i,
  output logic       vaild_o,
  output logic [7:0] aligned_byte_o
);

localparam [7:0] SYNC_PATTERN = 8'b10111000;
 
logic [7:0] unaligned_byte_d1;
logic [7:0] unaligned_byte_d2;
logic [2:0] sync_offset;

always_ff @( posedge clk_i )
  if( rst_i )
    begin
      unaligned_byte_d1 <= '0;
      unaligned_byte_d2 <= '0;
    end
  else
    begin
      unaligned_byte_d1 <= unaligned_byte_i;
      unaligned_byte_d2 <= unaligned_byte_d1;
    end
     
always_comb
  begin
    sync_offset = 3'd0;
    for( bit [2:0] i = 3'd0; i < 3'd7; i++ )
      if( ( {unaligned_byte_d1[i:0],unaligned_byte_d2[7:i+1]} == SYNC_PATTERN ) &&
          ( unaligned_byte_d2[i:0] == '0 ) )
        sync_offset = i;
      if( unaligned_byte_d1 == SYNC_PATTERN )
        sync_offset = 3'd7;
  end

always_ff @( posedge clk_i )
  if( rst_i )
    aligned_byte_o <= '0;
  else
    if( sync_offset == 3'd7 )
      aligned_byte_o <= unaligned_byte_d1;
    else
      for( bit [2:0] i = 3'd0; i < 3'd7; i++ )
        if( i == sync_offset )
          aligned_byte_o <= {unaligned_byte_d1[i:0],unaligned_byte_d2[7:i+1]};
    

endmodule
