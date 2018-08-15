`timescale 1 ps / 1 ps
module tb_dphy_data_lane;

parameter CLOCK_PERIOD = 10000;
parameter DELAY        = 0;

logic       dphy_data_p;
logic       dphy_data_n;
logic       rst;
logic       byte_clk;
logic       bit_clk;
logic       bit_clk_inv;
logic [7:0] byte_data_from_dut;

initial
  begin
    dphy_data_p = 0;
    dphy_data_n = 1;
    rst         = 0;
    byte_clk    = 1;
    bit_clk     = 1;
    bit_clk_inv = 0;
  end

task automatic clk_gen;
  fork
    forever
      begin
        #(CLOCK_PERIOD / 2 );
        bit_clk     <= ~bit_clk;
        bit_clk_inv <= ~bit_clk_inv;
      end
    forever
      begin
        #(CLOCK_PERIOD * 2);
        byte_clk <= ~byte_clk;
      end
   join_none
endtask

task automatic clk_stop;
  byte_clk    <= 1'b1;
  bit_clk     <= 1'b1;
  bit_clk_inv <= 1'b0;
endtask

task automatic apply_reset;
  rst <= 1'b0;
  @( posedge byte_clk );
  rst <= 1'b1;
  @( posedge byte_clk );
  rst <= 1'b0;
endtask

task automatic send_byte
(
  input [7:0] input_byte
);
  for( int i = 0; i < 8; i = i + 2 )
    begin
      dphy_data_p <= input_byte[i];
      dphy_data_n <= ~input_byte[i];
      @( posedge bit_clk_inv );
      dphy_data_p <= input_byte[i+1];
      dphy_data_n <= ~input_byte[i+1];
    end
  @( posedge bit_clk );  
  dphy_data_p <= 1'b0;
  dphy_data_n <= 1'b1;
endtask

dphy_hs_data_lane #(
  .DELAY         ( DELAY              )
) DUT (
  .bit_clk_i     ( bit_clk            ),
  .bit_clk_inv_i ( bit_clk_inv        ),
  .byte_clk_i    ( byte_clk           ),
  .enable_i      ( 1'b1               ),
  .rst_i         ( rst                ),
  .dphy_data_p_i ( dphy_data_p        ),
  .dphy_data_n_i ( dphy_data_n        ),
  .byte_data_o   ( byte_data_from_dut )
);

initial
  begin
    fork
      clk_gen;
      apply_reset;
    join_none
    repeat(10)
      @( posedge byte_clk );
    send_byte( 8'hff );
    repeat(10)
      @( posedge byte_clk );
    $stop;
  end

endmodule
