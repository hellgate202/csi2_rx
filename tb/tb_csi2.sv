include "../lib/dphy_lib/DPHYSender.sv";

`timescale 1 ps / 1 ps

module tb_csi2;

parameter     DATA_LANES = 4;
parameter int DELAY[4]   = '{0,0,0,0};
parameter     DPHY_CLK_T = 3000;
parameter     REF_CLK_T  = 5000;
parameter     WORD_CNT   = 11;

localparam CSI2_CRC_POLY = 16'h1021;

logic [DATA_LANES-1:0] dphy_data_p;
logic [DATA_LANES-1:0] dphy_data_n;
logic                  dphy_clk_p;
logic                  dphy_clk_n;
logic                  ref_clk;
logic                  rst;

logic                  short_pkt_valid;
logic [1:0]            short_pkt_v_channel;
logic [5:0]            short_pkt_data_type;
logic [15:0]           short_pkt_data_field;
logic                  long_pkt_header_valid;
logic [1:0]            long_pkt_v_channel;
logic [5:0]            long_pkt_data_type;
logic [15:0]           long_pkt_word_cnt;
logic [31:0]           long_pkt_payload;
logic                  long_pkt_payload_valid;
logic [3:0]            long_pkt_payload_be;
logic                  long_pkt_eop;
logic                  crc_passed;
logic                  crc_failed;

logic [31:0]           header;
logic [7:0]            crc_q[$];
logic [15:0]           crc;

initial
  begin
    ref_clk = 1'b0;
    rst     = 1'b0;
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

// This function generates ECC for header
function automatic logic [7:0] gen_ham ( logic [23:0] data );
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

function automatic logic [31:0] gen_header ( int          error_ins,
                                             int          error_pos,
                                             logic [7:0]  data_identifier,
                                             logic [15:0] word_cnt
                                           );
logic [7:0] ecc;
ecc = gen_ham ( {word_cnt,data_identifier} );
if( error_ins == 0 )
  gen_header = {ecc,word_cnt,data_identifier};
else
  begin
    gen_header            = {ecc,word_cnt,data_identifier};
    gen_header[error_pos] = ~gen_header[error_pos];
  end
endfunction

function automatic logic [15:0] gen_crc ( logic [7:0] payload [$] );
  logic [7:0] current_byte;
  logic [15:0] current_crc = 16'hffff;
  while( payload.size() > 0 )
    begin
      current_byte = payload.pop_front();
      for( int i = 0; i < 8; i++ )
        begin
          gen_crc[15] = current_crc[0] ^ current_byte[i];
          for( int j = 1; j < 16; j++ )
            if( CSI2_CRC_POLY[j] )
              gen_crc[15-j] = current_crc[16-j] ^ current_crc[0] ^ current_byte[i];
            else
              gen_crc[15-j] = current_crc[16-j];
          current_crc = gen_crc;
        end
    end
endfunction

csi2_rx #(
  .DATA_LANES               ( DATA_LANES             ),
  .DELAY                    ( DELAY                  )
) DUT (
  .dphy_clk_p_i             ( dphy_clk_p             ),
  .dphy_clk_n_i             ( dphy_clk_n             ),
  .dphy_data_p_i            ( dphy_data_p            ),
  .dphy_data_n_i            ( dphy_data_n            ),
  .ref_clk_i                ( ref_clk                ),
  .rst_i                    ( rst                    ),
  .enable_i                 ( 1'b1                   ),
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
  .long_pkt_payload_be_o    ( long_pkt_payload_be    ),
  .long_pkt_eop_o           ( long_pkt_eop           ),
  .crc_passed_o             ( crc_passed             ),
  .crc_failed_o             ( crc_failed             )
);

initial
  begin
    fork
      ref_clk_gen;
      apply_rst;
    join_none
    repeat(5)
      @( posedge ref_clk );
    // Generate header for first packet
    header = gen_header( .error_ins ( 1 ),
                         .error_pos ( 1 ),
                         .data_identifier ( 8'h12 ),
                         .word_cnt ( WORD_CNT )
                       );
    // Put header into mailbox and to crc_queue
    for( int i = 0; i < 4; i++ )
      data_to_send.put(header[(i*8+7)-:8]);
    // Put other data
    for( int i = 0; i < WORD_CNT; i++ )
      begin
        crc_q.push_back(i);
        data_to_send.put(i);
      end
    crc = gen_crc(crc_q);
    data_to_send.put(crc[7:0]);
    data_to_send.put(crc[15:8]);
    dphy_gen.send();
    repeat(1000)
      @( posedge ref_clk );
    $stop;
  end

endmodule
