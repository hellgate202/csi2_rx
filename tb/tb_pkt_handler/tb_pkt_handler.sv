`timescale 1 ps / 1 ps
module tb_pkt_handler;

parameter CLK_T = 10000;

logic        clk;
logic        rst;
logic        valid;
logic [31:0] data;
logic        error;
logic        error_corrected;

logic        short_pkt_valid;
logic [1:0]  short_pkt_v_channel;
logic [5:0]  short_pkt_data_type;
logic [15:0] short_pkt_data_field;
logic        long_pkt_header_valid;
logic [1:0]  long_pkt_v_channel;
logic [5:0]  long_pkt_data_type;
logic [15:0] long_pkt_word_cnt;
logic [31:0] long_pkt_payload;
logic        long_pkt_payload_valid;
logic [3:0]  long_pkt_payload_be;
logic        pkt_done_o;

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
  .clk_i                    ( clk                    ),
  .rst_i                    ( rst                    ),
  .valid_i                  ( valid                  ),
  .data_i                   ( data                   ),
  .error_i                  ( error                  ),
  .error_corrected_i        ( error_corrected        ),
  .short_pkt_valid_o        ( short_pkt_valid        ),
  .short_pkt_v_channel_o    ( short_pkt_v_channel    ),
  .short_pkt_data_type_o    ( short_pkt_data_type    ),
  .short_pkt_data_field_o   ( short_pkt_data_field   ),
  .long_pkt_header_valid_o  ( long_pkt_header_valid  ),
  .long_pkt_v_channel_o     ( long_pkt_v_channel     ),
  .long_pkt_data_type_o     ( long_pkt_data_type     ),
  .long_pkt_word_cnt_o      ( long_pkt_word_cnt      ),
  .long_pkt_payload_o       ( long_pkt_payload       ),
  .long_pkt_payload_valid_o ( long_pkt_payload_valid ),
  .long_pkt_payload_be_o    ( long_pkt_payload_be    )
);

initial
  begin
    fork
      clk_gen;
      apply_reset;
    join_none
    @( posedge clk );
    @( posedge clk );
    valid       <= 1'b1;
    data[29:24] <= 6'h10;
    data[23:8]  <= 16'd8;
    @( posedge clk );
    valid      <= 1'b0;
    data       <= '1;
    @( posedge clk );
    valid      <= 1'b1;
    @( posedge clk );
    valid      <= 1'b1;
    @( posedge clk );
    valid      <= 1'b0;
    @( posedge clk );
    valid      <= 1'b0;
    repeat(30)
      @( posedge clk );
    $stop;
  end

endmodule
