import csi2_data_types_pkg::*;

module csi2_long_pkt_parser
(
  input        header_valid_i,
  input  [5:0] data_type_i
  // Genetic data types
  output       null_o,
  output       blanking_o,
  output       embedded_data_o,
  // YUV data types
  output       yuv_420_8_o,
  output       yuv_420_10_o,
  output       yuv_420_8_legacy_o,
  output       yuv_420_8_cr_shift_o,
  output       yuv_420_10_cr_shift_o,
  output       yuv_422_8_o,
  output       yuv_422_10_o,
  // RGB data types
  output       rgb_444_o,
  output       rgb_555_o,
  output       rgb_565_o,
  output       rgb_666_o,
  output       rgb_888_o
  // RAW data types
  output       raw_6_o,
  output       raw_7_o,
  output       raw_8_o,
  output       raw_10_o,
  output       raw_12_o,
  output       raw_14_o
);

assign null_o                = ( header_valid_i && data_type_i == NULL                ) ? 1'b1 : 1'b0;
assign blanking_o            = ( header_valid_i && data_type_i == BLANKING            ) ? 1'b1 : 1'b0;
assign embedded_o            = ( header_valid_i && data_type_i == EMBEDDED            ) ? 1'b1 : 1'b0;

assign yuv_420_8_o           = ( header_valid_i && data_type_i == YUV_420_8           ) ? 1'b1 : 1'b0;
assign yuv_420_10_o          = ( header_valid_i && data_type_i == YUV_420_10          ) ? 1'b1 : 1'b0;
assign yuv_420_8_legacy_o    = ( header_valid_i && data_type_i == YUV_420_8_LEGACY    ) ? 1'b1 : 1'b0;
assign yuv_420_8_cr_shift_o  = ( header_valid_i && data_type_i == YUV_420_8_CR_SHIFT  ) ? 1'b1 : 1'b0;
assign yuv_420_10_cr_shift_o = ( header_valid_i && data_type_i == YUV_420_10_CR_SHIFT ) ? 1'b1 : 1'b0;
assign yuv_422_8_o           = ( header_valid_i && data_type_i == YUV_422_8           ) ? 1'b1 : 1'b0;
assign yuv_422_10_o          = ( header_valid_i && data_type_i == YUV_422_10          ) ? 1'b1 : 1'b0;

assign rgb_444_o             = ( header_valid_i && data_type_i == RGB_444             ) ? 1'b1 : 1'b0;
assign rgb_555_o             = ( header_valid_i && data_type_i == RGB_555             ) ? 1'b1 : 1'b0;
assign rgb_565_o             = ( header_valid_i && data_type_i == RGB_565             ) ? 1'b1 : 1'b0;
assign rgb_666_o             = ( header_valid_i && data_type_i == RGB_666             ) ? 1'b1 : 1'b0;
assign rgb_888_o             = ( header_valid_i && data_type_i == RGB_888             ) ? 1'b1 : 1'b0;

assign raw_6_o               = ( header_valid_i && data_type_i == RAW_6               ) ? 1'b1 : 1'b0;
assign raw_7_o               = ( header_valid_i && data_type_i == RAW_7               ) ? 1'b1 : 1'b0;
assign raw_8_o               = ( header_valid_i && data_type_i == RAW_8               ) ? 1'b1 : 1'b0;
assign raw_10_o              = ( header_valid_i && data_type_i == RAW_10              ) ? 1'b1 : 1'b0;
assign raw_12_o              = ( header_valid_i && data_type_i == RAW_12              ) ? 1'b1 : 1'b0;
assign raw_14_o              = ( header_valid_i && data_type_i == RAW_14              ) ? 1'b1 : 1'b0;

endmodule
