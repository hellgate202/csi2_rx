`timescale 1 ps / 1 ps
module tb_dphy_clk_detect;

logic ref_clk;
logic dphy_clk_p;
logic dphy_clk_n;
logic bit_clk;
logic bit_clk_inv;
logic byte_clk;
logic rst;
logic serdes_rst;
logic serdes_rst_cdc;

parameter DPHY_CLK_T = 3334;
parameter REF_CLK_T  = 5000;
parameter BURST_GAP  = 2000000;

initial
  begin
    ref_clk    = 1'b0;
    rst        = 1'b0;
    dphy_clk_p = 1'b0;
    dphy_clk_n = 1'b1;
  end

task automatic ref_clk_gen;
  forever
    begin
      #( REF_CLK_T / 2 );
      ref_clk <= ~ref_clk;
    end
endtask

task automatic dphy_burst_clk_gen;
  forever
    begin
      #( BURST_GAP );
      repeat( 1000 )
        begin
          #( DPHY_CLK_T / 2 );
          dphy_clk_p <= dphy_clk_n;
          dphy_clk_n <= dphy_clk_p;
        end
    end
endtask

task automatic apply_reset;
  @( posedge ref_clk );
  rst <= 1'b1;
  @( posedge ref_clk );
  rst <= 1'b0;
endtask

dphy_hs_clk_lane clk_phy
(
  .dphy_clk_p_i  ( dphy_clk_p  ),
  .dphy_clk_n_i  ( dphy_clk_n  ),
  .rst_i         ( rst         ),
  .bit_clk_o     ( bit_clk     ),
  .bit_clk_inv_o ( bit_clk_inv ),
  .byte_clk_o    ( byte_clk    )
);

dphy_clk_detect DUT
(
  .ref_clk_i  ( ref_clk    ),
  .byte_clk_i ( byte_clk   ),
  .enable_i   ( 1'b1       ),
  .rst_i      ( rst        ),
  .rst_o      ( serdes_rst )
);

dphy_clk_detect_cdc DUT_cdc
(
  .ref_clk_i  ( ref_clk        ),
  .byte_clk_i ( byte_clk       ),
  .enable_i   ( 1'b1           ),
  .rst_i      ( rst            ),
  .rst_o      ( serdes_rst_cdc )
);

initial
  begin
    fork
      ref_clk_gen;
      dphy_burst_clk_gen;
      apply_reset;
    join_none
    repeat( 10000 )
      @( posedge ref_clk );
    $stop;
  end

endmodule
