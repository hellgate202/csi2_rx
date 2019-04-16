/*
  Module looks for sync pattern in unaligned byte stream
  And then shift output value for how much sync pattern
  was shifted
*/
module dphy_byte_align
(
  input                clk_i,
  input                rst_i,
  input        [7 : 0] unaligned_byte_i,
  input                reset_align_i,
  input                hs_data_valid_i,
  output logic         valid_o,
  output logic [7 : 0] aligned_byte_o
);

localparam bit [7 : 0] SYNC_PATTERN = 8'b10111000;

// | compare_window                                                |
//                     | SYNC_PATTERN                  |
// | X | X | X | X | X | 1 | 0 | 1 | 1 | 1 | 0 | 0 | 0 | X | X | X |
// | unaligned_byte_d1             | unaligned_byte_d2             |
//                                                     | sync_offset = 2

logic [7 : 0]  unaligned_byte_d1;
logic [7 : 0]  unaligned_byte_d2;
logic [3 : 0]  sync_offset;
logic          found_sync;
logic [15 : 0] compare_window;
logic [3 : 0]  align_shift;
logic          sync_done;

always_ff @( posedge clk_i, posedge rst_i )
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
     
// Looking for sync pattern by shiffting compare window
always_comb
  begin
    sync_offset = 4'd0;
    found_sync  = 1'b0;
    compare_window = { unaligned_byte_d1, unaligned_byte_d2 };
    if( hs_data_valid_i )
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

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      align_shift <= 3'd0;
      sync_done   <= 1'b0;
    end
  else
    // We lock shift only once
    if( !sync_done && found_sync )
      begin
        align_shift <= sync_offset;
        sync_done   <= 1'b1;
      end
    else
      // And reset it from packet level handler
      if( reset_align_i )
        sync_done <= 1'b0;

// Output data became valid after synchronization sequence
// was catched
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    valid_o <= 1'b0;
  else
    // Packet level protocol resets phy when packet
    // has ended. Also when we are ignoring 300ns
    // period there are no valid data
    if( reset_align_i || !hs_data_valid_i)
      valid_o <= 1'b0;
    else
      valid_o <= sync_done;

// Shift by locked value
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    aligned_byte_o <= '0;
  else
    for( bit [3:0] i = 4'd0; i < 4'd8; i++ )
      if( i == align_shift )
        aligned_byte_o <= { unaligned_byte_d1, unaligned_byte_d2 } >> i;
      
endmodule
