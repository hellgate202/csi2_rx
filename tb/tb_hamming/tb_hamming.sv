module tb_hamming;

parameter LUT_REG_OUTPUT = 1;
parameter CLK_T          = 10000;

logic        clk;
logic        rst;
logic        valid;
logic [31:0] data;
logic        pkt_done;
logic        error_o;
logic        error_corrected_o;
logic [31:0] data_o;
logic        valid_o;

bit [23:0] data_queue [$];

initial
  begin
    clk      = 1'b0;
    rst      = 1'b0;
    valid    = 1'b0;
    data     = 32'd0;
    pkt_done = 1'b0;
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

task automatic gen_queue;
  for( int i = 0; i < 16; i++ )
    data_queue.push_back($urandom_range(65535,0));
endtask

task automatic gen_valid;
  forever
    begin
      if( data_queue.size() > 0 )
        valid <= $urandom_range(1,0);
      else
        valid <= 1'b0;
      @( posedge clk );
    end
endtask

task automatic send_data( err );
  gen_queue;
  begin
    data[23:0] = data_queue.pop_front();
    data[31:24] = gen_ham(data[23:0]);
    if( err != 0 )
      data[1] = ~data[1];
  end
  @( posedge clk );
  while( data_queue.size() > 0 )
    begin
      if( valid )
        begin
          data[23:0]  = data_queue.pop_front();
          data[31:24] = $urandom_range(255,0);
        end
      @( posedge clk );
    end
endtask

function automatic logic [7:0] gen_ham (logic [23:0] data);
  logic [5:0] generated_parity;

  generated_parity[0] = data[0]  ^ data[1]  ^ data[2]  ^ data[4]  ^ data[5]  ^
                        data[7]  ^ data[10] ^ data[11] ^ data[13] ^ data[16] ^
                        data[20] ^ data[21] ^ data[22] ^ data[23];
  generated_parity[1] = data[0]  ^ data[1]  ^ data[3]  ^ data[4]  ^ data[6]  ^
                        data[8]  ^ data[10] ^ data[12] ^ data[14] ^ data[17] ^
                        data[20] ^ data[21] ^ data[22] ^ data[23];
  generated_parity[2] = data[0]  ^ data[2]  ^ data[3]  ^ data[5]  ^ data[6]  ^
                        data[9]  ^ data[11] ^ data[12] ^ data[15] ^ data[18] ^
                        data[20] ^ data[21] ^ data[22];
  generated_parity[3] = data[1]  ^ data[2]  ^ data[3]  ^ data[7]  ^ data[8]  ^
                        data[9]  ^ data[13] ^ data[14] ^ data[15] ^ data[19] ^
                        data[20] ^ data[21] ^ data[23];
  generated_parity[4] = data[4]  ^ data[5]  ^ data[6]  ^ data[7]  ^ data[8]  ^
                        data[9]  ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^
                        data[20] ^ data[22] ^ data[23];
  generated_parity[5] = data[10] ^ data[11] ^ data[12] ^ data[13] ^ data[14] ^
                        data[15] ^ data[16] ^ data[17] ^ data[18] ^ data[19] ^
                        data[21] ^ data[22] ^ data[23];

  gen_ham = {2'b0,generated_parity};
endfunction

csi2_hamming_dec #(
  .LUT_REG_OUTPUT    ( LUT_REG_OUTPUT    )
) DUT (
  .clk_i             ( clk               ),
  .rst_i             ( rst               ),
  .valid_i           ( valid             ),
  .data_i            ( data              ),
  .pkt_done_i        ( pkt_done          ),
  .error_o           ( error_o           ),
  .error_corrected_o ( error_corrected_o ),
  .data_o            ( data_o            ),
  .valid_o           ( valid_o           )
);

initial
  begin
    fork
      clk_gen;
      apply_reset;
      gen_valid;
    join_none
    @( posedge clk );
    @( posedge clk );
    send_data(0);
    pkt_done = 1'b1;
    @( posedge clk );
    pkt_done = 1'b0;
    send_data(1);
    pkt_done = 1'b1;
    @( posedge clk );
    pkt_done = 1'b0;
    send_data(0);
    pkt_done = 1'b1;
    @( posedge clk );
    pkt_done = 1'b0;
    send_data(1);
    pkt_done = 1'b1;
    @( posedge clk );
    pkt_done = 1'b0;   
    send_data(0);
    pkt_done = 1'b1;
    @( posedge clk );
    pkt_done = 1'b0;
    send_data(0);
    pkt_done = 1'b1;
    @( posedge clk );
    pkt_done = 1'b0;
    send_data(1);
    pkt_done = 1'b1;
    @( posedge clk );
    pkt_done = 1'b0;
    send_data(1);
    pkt_done = 1'b1;
    @( posedge clk );
    pkt_done = 1'b0;
    repeat( 10 )
      @( posedge clk );
    $stop;
  end

endmodule
