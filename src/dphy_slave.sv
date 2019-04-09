module dphy_slave #(
  parameter int DATA_LANES = 2,
  parameter int DELAY [4]  = '{ 0, 0, 0, 0}
)(
  input                       dphy_clk_p_i,
  input                       dphy_clk_n_i,
  input  [DATA_LANES - 1 : 0] dphy_data_p_i,
  input  [DATA_LANES - 1 : 0] dphy_data_n_i,
  input  [DATA_LANES - 1 : 0] lp_data_p_i,
  input  [DATA_LANES - 1 : 0] lp_data_n_i,
  input  [DATA_LANES - 1 : 0] inc_delay_i,
  input                       ref_clk_i,
  input                       srst_i,
  input                       enable_i,
  input                       phy_rst_i,
  output                      rx_clk_present_o,
  output [31 : 0]             data_o,
  output                      clk_o,
  output                      valid_o
);

logic                             bit_clk;
logic                             bit_clk_inv;
logic                             byte_clk;
logic                             rx_clk_present;
logic [DATA_LANES - 1 : 0][7 : 0] byte_data;
logic [DATA_LANES - 1 : 0][7 : 0] aligned_byte_data;
logic [DATA_LANES - 1 : 0]        aligned_byte_valid;
logic                             reset_align;
logic [DATA_LANES - 1 : 0][7 : 0] word_data;
logic [DATA_LANES - 1 : 0]        hs_data_valid;
logic                             word_valid;

logic [DATA_LANES - 1 : 0][4 : 0] cur_delay;

assign clk_o            = byte_clk;
assign rx_clk_present_o = rx_clk_present;

dphy_hs_clk_rx clk_phy
(
  .dphy_clk_p_i  ( dphy_clk_p_i ),
  .dphy_clk_n_i  ( dphy_clk_n_i ),
  .bit_clk_o     ( bit_clk      ),
  .bit_clk_inv_o ( bit_clk_inv  ),
  .byte_clk_o    ( byte_clk     )
);

clk_detect #(
  .REF_TICKS_TO_ABSENCE  ( 10             ),
  .OBS_TICKS_TO_PRESENCE ( 3              )
) clk_detect (
  .ref_clk_i             ( ref_clk_i      ),
  .obs_clk_i             ( byte_clk       ),
  .srst_i                ( srst_i         ),
  .clk_present_o         ( rx_clk_present )
);

generate
  begin: data_lane
    for( genvar i = 0; i < DATA_LANES; i++ )
      dphy_hs_data_rx #(
        .DELAY         ( DELAY[i]         ) 
      ) data_phy (
        .bit_clk_i     ( bit_clk          ),
        .bit_clk_inv_i ( bit_clk_inv      ),
        .byte_clk_i    ( byte_clk         ),
        .ref_clk_i     ( ref_clk_i        ),
        .enable_i      ( enable_i         ),
        .serdes_rst_i  ( ~rx_clk_present  ),
        .dphy_data_p_i ( dphy_data_p_i[i] ),
        .dphy_data_n_i ( dphy_data_n_i[i] ),
        .inc_delay_i   ( inc_delay_i[i]   ),
        .cur_delay_o   ( cur_delay[i]     ),
        .byte_data_o   ( byte_data[i]     )
      ); 
  end
endgenerate

IDELAYCTRL delay_ctrl
(
  .RDY    (           ),
  .REFCLK ( ref_clk_i ),
  .RST    ( 1'b0      )
);

generate
  for( genvar i = 0; i < DATA_LANES; i++ )
    begin : byte_align
      dphy_settle_ignore settle_ignore
      (
        .clk_i           ( ref_clk_i        ),
        .srst_i          ( srst_i           ),
        .lp_data_p_i     ( lp_data_p_i[i]   ),
        .lp_data_n_i     ( lp_data_n_i[i]   ),
        .hs_data_valid_o ( hs_data_valid[i] )
      );

      dphy_byte_align byte_align
      (
        .clk_i            ( byte_clk              ),
        .rst_i            ( ~rx_clk_present       ),
        .unaligned_byte_i ( byte_data[i]          ),
        .reset_align_i    ( reset_align           ),
        .hs_data_valid_i  ( hs_data_valid[i]      ),
        .valid_o          ( aligned_byte_valid[i] ),
        .aligned_byte_o   ( aligned_byte_data[i]  )
      );
    end
endgenerate

dphy_word_align #(
  .DATA_LANES    ( DATA_LANES         )
) word_align (
  .byte_clk_i    ( byte_clk           ),
  .rst_i         ( ~rx_clk_present    ),
  .enable_i      ( enable_i           ),
  .eop_i         ( phy_rst_i          ),
  .byte_data_i   ( aligned_byte_data  ),
  .valid_i       ( aligned_byte_valid ),
  .reset_align_o ( reset_align        ),
  .word_o        ( word_data          ),
  .valid_o       ( word_valid         )
);

dphy_32b_map #(
  .DATA_LANES   ( DATA_LANES )
) mapper (
  .byte_clk_i   ( byte_clk        ),
  .rst_i        ( ~rx_clk_present ),
  .word_data_i  ( word_data       ),
  .eop_i        ( phy_rst_i       ),
  .valid_i      ( word_valid      ),
  .maped_data_o ( data_o          ),
  .valid_o      ( valid_o         )
);

endmodule
