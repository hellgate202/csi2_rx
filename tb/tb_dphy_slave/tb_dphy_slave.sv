import dphy_pkg::*;

`timescale 1 ps / 1 ps

module tb_dphy_slave;

parameter     DATA_LANES = 4;
parameter int DELAY[4]   = '{0,0,0,0};
parameter     DPHY_CLK_T = 3000;
parameter     REF_CLK_T  = 5000;

logic [DATA_LANES-1:0]      dphy_data_p;
logic [DATA_LANES-1:0]      dphy_data_n;
logic                       dphy_clk_p;
logic                       dphy_clk_n;

logic                       ref_clk;
logic                       rst;
logic                       wait_for_sync;
logic                       pkt_done;
logic                       rst_o;
logic [31:0]                data_o;
logic                       clk_o;
logic                       valid_o;

initial
  begin
    ref_clk       = 1'b0;
    rst           = 1'b0;
    wait_for_sync = 1'b1;
    pkt_done      = 1'b0;
  end

dphy_if #(
  .DATA_LANES ( DATA_LANES )
) sender_if ();

assign dphy_data_p = sender_if.hs_data_p;
assign dphy_data_n = sender_if.hs_data_n;
assign dphy_clk_p  = sender_if.hs_clk_p;
assign dphy_clk_n  = sender_if.hs_clk_n;

mailbox data_to_send = new();

DPHYSender #(
  .DATA_LANES ( DATA_LANES ),
  .DPHY_CLK_T ( DPHY_CLK_T )
) dphy_gen = new( .dphy_if_v    ( sender_if    ),
                  .data_to_send ( data_to_send )
                );

task automatic ref_clk_gen;
  forever
    begin
      #( REF_CLK_T / 2 );
      ref_clk <= ~ref_clk;
    end
endtask

task automatic apply_rst;
  @( posedge ref_clk );
  rst <= 1'b1;
  @( posedge ref_clk );
  rst <= 1'b0;
endtask

task automatic deassert_wfs;
  forever
    begin
      if( valid_o )
        begin
          wait_for_sync <= 1'b0;
        end
      @( posedge clk_o );
    end
endtask

dphy_slave #(
  .DATA_LANES      ( DATA_LANES    ),
  .DELAY           ( DELAY         )
) DUT (
  .dphy_clk_p_i    ( dphy_clk_p    ),
  .dphy_clk_n_i    ( dphy_clk_n    ),
  .dphy_data_p_i   ( dphy_data_p   ),
  .dphy_data_n_i   ( dphy_data_n   ),
  .ref_clk_i       ( ref_clk       ),
  .rst_i           ( rst           ),
  .enable_i        ( 1'b1          ),
  .wait_for_sync_i ( wait_for_sync ),
  .pkt_done_i      ( pkt_done      ),
  .rst_o           ( rst_o         ),
  .data_o          ( data_o        ),
  .clk_o           ( clk_o         ),
  .valid_o         ( valid_o       )
);

initial
  begin
    fork
      ref_clk_gen;
      apply_rst;
      deassert_wfs;
    join_none
    repeat(5)
      @( posedge ref_clk );
    for( bit[7:0] i = 0; i < 255; i++ )
      data_to_send.put(i);
      dphy_gen.send();
    repeat(1000)
      @( posedge ref_clk );
    $stop;
  end

endmodule
