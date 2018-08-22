module dphy_slave #(
  parameter DATA_LANES = 2
  parameter DELAY [4]  = '{0,0,0,0};
)(
  input                        dphy_clk_p_i,
  input                        dphy_clk_n_i,
  input  [DATA_LANES-1:0]      dphy_data_p_i,
  input  [DATA_LANES-1:0]      dphy_data_n_i,
  input                        ref_clk_i,
  input                        rst_i,
  input                        enable_i,
  input                        wait_for_sync_i,
  input                        pkt_done_i,
  input                        rst_o,
  output [DATA_LANES-1:0][7:0] data_o,
  output                       clk_o,
  output                       valid_o
);

logic                       bit_clk;
logic                       bit_clk_inv;
logic                       byte_clk;
logic [DATA_LANES-1:0][7:0] byte_data;
logic [DATA_LANES-1:0][7:0] aligned_byte_data;
logic                       reset_aligner;
logic                       byte_valid;

dphy_hs_clk_lane clk_phy
(
  .dphy_clk_p_i  ( dphy_clk_p_i ),
  .dphy_clk_n_i  ( dphy_clk_n_i ),
  .rst_i         ( rst_i        ),
  .bit_clk_o     ( bit_clk      ),
  .bit_clk_inv_o ( bit_clk_inv  ),
  .byte_clk_o    ( byte_clk     )
);

dphy_clk_detect clk_detect
(
  .ref_clk_i  ( ref_clk_i ),
  .byte_clk_i ( byte_clk  ),
  .enable_i   ( enable_i  ),
  .rst_i      ( rst_i     ),
  .rst_o      ( rst_o     )
);

generate
  begin : data_lane
    for( genvar i = 0; i < DATA_LANES; i++ )
      dphy_hs_data_lane #(
        .DELAY         ( DELAY[i]         ) 
      ) data_phy (
        .bit_clk_i     ( bit_clk          ),
        .bit_clk_inv_i ( bit_clk_inv      ),
        .byte_clk_i    ( byte_clk_inv     ),
        .ref_clk_i     ( ref_clk          ),
        .enable_i      ( enable_i         ),
        .rst_i         ( rst_o            ),
        .dphy_data_p_i ( dphy_data_p_i[i] ),
        .dphy_data_n_i ( dphy_data_n_i[i] ),
        .byte_data_o   ( byte_data[i]     )
      ); 
  end
endgenerate

generate
  begin : byte_align
    for( genvar i = 0; i < DATA_LANES; i++ )
      dphy_byte_align byte_aligner
      (
        .clk_i            ( byte_clk             ),
        .rst_i            ( rst_o                ),
        .enable_i         ( enable_i             ),
        .unaligned_byte_i ( byte_data[i]         ),
        .wait_for_sync_i  ( wait_for_sync_i      ),
        .packet_done_i    ( reset_aligner        ),
        .valid_o          ( byte_valid           ),
        .aligned_byte     ( aligned_byte_data[i] )
      )
  end
endgenerate

dphy_word_align #(
  .DATA_LANES      ( DATA_LANES      ),
) word_aligner (
  .byte_clk_i      ( byte_clk        ),
  .rst_i           ( rst_o           ),
  .enable_i        ( enable_i        ),
  .pkt_done_i      ( pkt_done_i      ),
  .wait_for_sync_i ( wait_for_sync_i ),
  .pkt_done_o      ( reset_aligner   ),
  .word_o          ( data_o          ),
  .valid_o         ( valid_o         )
);

endmodule
