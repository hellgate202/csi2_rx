`timescale 1 ps / 1 ps
module tb_dphy_clk_lane;

parameter CLOCK_PERIOD = 10000;

logic dphy_clk_p;
logic dphy_clk_n;
logic rst;
logic byte_clk;
logic bit_clk;
logic bit_clk_inv;

task clk_gen;
  dphy_clk_p = 1'b0;
  dphy_clk_n = 1'b1;
  forever
    begin
      #(CLOCK_PERIOD / 2);
      dphy_clk_p <= ~dphy_clk_p;
      dphy_clk_n <= ~dphy_clk_n;
    end
endtask

task apply_reset;
  rst = 1'b0;
  @( posedge bit_clk );
  rst <= 1'b1;
  @( posedge bit_clk );
  rst <= 1'b0;
endtask

dphy_clk_lane #(
  .ENABLE_TERMINATION ( 1             )
) DUT (
  .dphy_clk_p_i       ( dphy_clk_p    ),
  .dphy_clk_n_i       ( dphy_clk_n    ),
  .rst_i              ( rst           ),
  .byte_clk_o         ( byte_clk      ),
  .bit_clk_o          ( bit_clk       ),
  .bit_clk_inv_o      ( bit_clk_inv_o )
);

initial
  begin
    fork
      clk_gen;
      apply_reset;
    join_none
    repeat( 1000 )
      @( posedge byte_clk );
    $stop;
  end

endmodule
