`timescale 1 ps / 1 ps
module tb_dphy_byte_align;

parameter CLOCK_PERIOD = 10000;
parameter DELAY        = 0;

// DPHY inputs
logic       rst_clk;
logic       rst_data;
logic       dphy_clk_p;
logic       dphy_clk_n;
logic       dphy_data_p;
logic       dphy_data_n;

// Interconnect
logic       bit_clk;
logic       bit_clk_inv;
logic       byte_clk;
logic [7:0] unaligned_byte;

// DUT signals
logic [7:0] aligned_byte;
logic       valid;
logic       wait_for_sync;

task automatic clk_gen;
  dphy_clk_p <= 1'b0;
  dphy_clk_n <= 1'b1;
  forever
    begin
      #(CLOCK_PERIOD / 2);
      dphy_clk_p <= ~dphy_clk_p;
      dphy_clk_n <= ~dphy_clk_n;
    end
endtask

task automatic apply_reset;
  rst_clk <= 1'b0;
  #( CLOCK_PERIOD );
  rst_clk <= 1'b1;
  #( CLOCK_PERIOD );
  rst_clk <= 1'b0;
  @( posedge byte_clk );
  rst_data <= 1'b0;
  @( posedge byte_clk );
  rst_data <= 1'b1;
  @( posedge byte_clk );
  rst_data <= 1'b0;
endtask

task automatic send_byte
(
  input [7:0] input_byte
);
  for( int i = 0; i < 8; i = i + 2 )
    begin
      @( posedge bit_clk );
      dphy_data_p <= input_byte[i];
      dphy_data_n <= ~input_byte[i];
      @( posedge bit_clk_inv );
      dphy_data_p <= input_byte[i+1];
      dphy_data_n <= ~input_byte[i+1];
    end
endtask

task automatic wfs;
  wait_for_sync <= 1'b1;
  forever
    begin
      if( valid )
        begin
          @( posedge byte_clk );
          wait_for_sync <= 1'b0;
        end
      @( posedge byte_clk );
    end  
endtask

dphy_hs_clk_lane clk_phy (
  .dphy_clk_p_i  ( dphy_clk_p  ),
  .dphy_clk_n_i  ( dphy_clk_n  ),
  .rst_i         ( rst_clk     ),
  .bit_clk_o     ( bit_clk     ),
  .bit_clk_inv_o ( bit_clk_inv ),
  .byte_clk_o    ( byte_clk    )
);

dphy_hs_data_lane #(
  .DELAY         ( DELAY          )
) data_phy (
  .bit_clk_i     ( bit_clk        ),
  .bit_clk_inv_i ( bit_clk_inv    ),
  .byte_clk_i    ( byte_clk       ),
  .enable_i      ( 1'b1           ),
  .rst_i         ( rst_data       ),
  .dphy_data_p_i ( dphy_data_p    ),
  .dphy_data_n_i ( dphy_data_n    ),
  .byte_data_o   ( unaligned_byte )
);

dphy_byte_align DUT (
  .clk_i            ( byte_clk       ),
  .rst_i            ( rst_data       ),
  .enable_i         ( 1'b1           ),
  .unaligned_byte_i ( unaligned_byte ),
  .wait_for_sync_i  ( wait_for_sync  ),
  .packet_done_i    ( 1'b0           ),
  .valid_o          ( valid          ),
  .aligned_byte_o   ( aligned_byte   )
);

initial
  begin
    fork
      clk_gen;
      apply_reset;
      wfs;
    join_none
    repeat( 10 )
      @( posedge bit_clk );
    repeat(10)
        send_byte(8'd0);
    send_byte(8'hb8);
    repeat(10)
      for( byte i = 0; i < 10; i++ )
        send_byte(i);
    repeat( 20 )
      @( posedge bit_clk );
    $stop;
  end

endmodule
