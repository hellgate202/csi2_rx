module tb_dphy_word_align;

parameter DATA_LANES   = 4;
parameter CLOCK_PERIOD = 10000;

logic                       clk;
logic                       rst;
logic                       wait_for_sync;
logic [DATA_LANES-1:0][7:0] input_data;
logic [DATA_LANES-1:0]      input_valid;
logic                       pkt_done;
logic [DATA_LANES-1:0][7:0] word;
logic                       valid;

initial
  begin
    clk           = 1'b0;
    rst           = 1'b0;
    wait_for_sync = 1'b0;
    input_data    = '0;
    input_valid   = '0;
  end

task automatic clk_gen;
  forever
    begin
      #( CLOCK_PERIOD/2 );
      clk <= ~clk;
    end
endtask

task automatic apply_reset;
  @( posedge clk );
  rst <= 1'b1;
  @( posedge clk );
  rst <= 1'b0;
endtask

task automatic traf_gen(
  input int lane
);
input_valid[lane] <= 1'b1;
forever
  begin
    @( posedge clk );
    input_data[lane] <= input_data[lane] + 1'b1; 
  end
endtask

task automatic wait_for_sync_proc;
  wait_for_sync <= 1'b1;
  forever
    begin
      @( posedge clk );
      if( valid )
        wait_for_sync <= 1'b0;
    end
endtask

dphy_word_align #(
  .DATA_LANES      ( DATA_LANES    )
) DUT (
  .byte_clk_i      ( clk           ),
  .rst_i           ( rst           ),
  .enable_i        ( 1'b1          ),
  .pkt_done_i      ( 1'b0          ),
  .wait_for_sync_i ( wait_for_sync ),
  .byte_data_i     ( input_data    ),
  .valid_i         ( input_valid   ),
  .pkt_done_o      ( pkt_done      ),
  .word_o          ( word          ),
  .valid_o         ( valid         )
);

initial
  begin
    fork
      clk_gen;
      apply_reset;
      wait_for_sync_proc;
    join_none
    repeat(10)
      @( posedge clk );
    fork
      traf_gen(0);
      begin
        @( posedge clk );
        fork
          traf_gen(1);
          traf_gen(2);
          begin
            @( posedge clk );
            fork
              traf_gen(3);
            join_none
          end
        join_none
      end
    join_none
    repeat(100)
      @( posedge clk );
    $stop;
  end

endmodule
