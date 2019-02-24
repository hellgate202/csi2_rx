module dphy_byte_align
(
  input                clk_i,
  input                rst_i,
  input        [7 : 0] unaligned_byte_i,
  input                reset_align_i,
  output logic         valid_o,
  output logic [7 : 0] aligned_byte_o
);

localparam bit [7 : 0] SYNC_PATTERN = 8'b10111000;

logic [7 : 0]  unaligned_byte_d1;
logic [7 : 0]  unaligned_byte_d2;
logic [3 : 0]  sync_offset;
logic          found_sync;
logic [15 : 0] compare_window;
logic [3 : 0]  align_shift;
logic          sync_done;

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
    sync_offset = 4'd0;
    found_sync  = 1'b0;
    compare_window = { unaligned_byte_d1, unaligned_byte_d2 };
    for( bit [3 : 0] i = 4'd0; i < 4'd8; i++ )
      begin
        compare_window = { unaligned_byte_d1, unaligned_byte_d2 } >> i;
        if( compare_window[7 : 0] == SYNC_PATTERN )
          begin
            sync_offset = i;
            found_sync  = 1'b1;
            break;
          end
      end
  end

always_ff @( posedge clk_i )
  if( rst_i )
    begin
      align_shift <= 3'd0;
      sync_done   <= 1'b0;
    end
  else
    if( ~sync_done && found_sync )
      begin
        align_shift <= sync_offset;
        sync_done   <= 1'b1;
      end
    else
      if( reset_align_i )
        sync_done <= 1'b0;

always_ff @( posedge clk_i )
  if( rst_i )
    valid_o <= 1'b0;
  else
    if( reset_align_i )
      valid_o <= 1'b0;
    else
      valid_o <= sync_done;

always_ff @( posedge clk_i )
  if( rst_i )
    aligned_byte_o <= '0;
  else
    for( bit [3:0] i = 4'd0; i < 4'd8; i++ )
      if( i == align_shift )
        aligned_byte_o <= { unaligned_byte_d1, unaligned_byte_d2 } >> i;
      
endmodule
