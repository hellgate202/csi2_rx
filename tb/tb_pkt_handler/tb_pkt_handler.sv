`timescale 1 ps / 1 ps
module tb_pkt_handler;

parameter CLK_T = 10000;

logic        clk;
logic        rst;
logic        valid;
logic [31:0] data;
logic        short_pkt_o;
logic        long_pkt_o;
logic [1:0]  virtual_channel_o;
logic [5:0]  data_type_o;
logic [31:0] payload_data_o;
logic        valid_o;
logic        pkt_done_o;
logic        crc_check_o;
logic        error;
logic        error_corrected;

initial
  begin
    clk             = 1'b0;
    rst             = 1'b0;
    valid           = 1'b0;
    data            = 32'd0;
    error           = 1'b0;
    error_corrected = 1'b0;
  end

task automatic clk_gen;
  forever
    begin
      #( CLK_T / 2 );
      clk <= ~clk;
    end
endtask

task automatic apply_reset;
  @( posedge clk );
  rst = 1'b1;
  @( posedge clk );
  rst = 1'b0;
endtask

csi2_pkt_handler DUT (
  .clk_i             ( clk               ),
  .rst_i             ( rst               ),
  .valid_i           ( valid             ),
  .data_i            ( data              ),
  .error_i           ( error             ),
  .error_corrected_i ( error_corrected   ),
  .short_pkt_o       ( short_pkt_o       ),
  .long_pkt_o        ( long_pkt_o        ),
  .virtual_channel_o ( virtual_channel_o ),
  .data_type_o       ( data_type_o       ),
  .payload_data_o    ( payload_data_o    ),
  .valid_o           ( valid_o           ),
  .pkt_done_o        ( pkt_done_o        ),
  .crc_check_o       ( crc_chceck_o      )
);

initial
  begin
    fork
      clk_gen;
      apply_reset;
    join_none
    @( posedge clk );
    @( posedge clk );
    valid      <= 1'b1;
    data[23:8] <= 16'd8;
    @( posedge clk );
    valid      <= 1'b0;
    data       <= '1;
    @( posedge clk );
    valid      <= 1'b1;
    @( posedge clk );
    valid      <= 1'b0;
    @( posedge clk );
    valid      <= 1'b1;
    @( posedge clk );
    valid      <= 1'b0;
    repeat(30)
      @( posedge clk );
    $stop;
  end

endmodule
