import csi2_data_types_pkg::*;

module csi2_short_pkt_parser
(
  input               clk_i,
  input               rst_i,
  input               header_valid_i,
  input        [5:0]  data_type_i,
  input        [15:0] data_field_i,
  output              frame_start_o,
  output              frame_end_o,
  output logic [15:0] frame_number_o,
  output              line_start_o,
  output              line_end_o,
  output logic [15:0] line_number_o
);

assign frame_start_o = ( header_valid_i && data_type_i == FRAME_START ) ? 1'b1 : 1'b0;
assign frame_end_o   = ( header_valid_i && data_type_i == FRAME_END   ) ? 1'b1 : 1'b0;
assign line_start_o  = ( header_valid_i && data_type_i == LINE_START  ) ? 1'b1 : 1'b0;
assign line_end_o    = ( header_valid_i && data_type_i == LINE_END    ) ? 1'b1 : 1'b0;

always_ff @( posedge clk_i )
  if( rst_i )
    frame_number_o <= 16'd0;
  else
    if( frame_start_o )
      frame_number_o <= data_field_i;

always_ff @( posedge clk_i )
  if( rst_i )
    line_number_o <= 16'd0;
  else
    if( line_start_o )
      line_number_o <= data_field_i

endmodule
