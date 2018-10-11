package csi2_data_types_pkg;

// Long packets
parameter bit [5:0] NULL            = 6'h10;
parameter bit [5:0] BLANKING        = 6'h11;
parameter bit [5:0] EMBEDDED        = 6'h12;
parameter bit [5:0] YUV_420_8       = 6'h18;
parameter bit [5:0] YUV_420_10      = 6'h19;
parameter bit [5:0] YUV_420_LEGACY  = 6'h1a;
parameter bit [5:0] YUV_8_CR_SHIFT  = 6'h1c;
parameter bit [5:0] YUV_10_CR_SHIFT = 6'h1d;
parameter bit [5:0] YUV_422_8       = 6'h1e;
parameter bit [5:0] YUV_422_10      = 6'h1f;
parameter bit [5:0] RGB_444         = 6'h20;
parameter bit [5:0] RGB_555         = 6'h21;
parameter bit [5:0] RGB_565         = 6'h22;
parameter bit [5:0] RGB_666         = 6'h23;
parameter bit [5:0] RGB_888         = 6'h24;
parameter bit [5:0] RAW_6           = 6'h28;
parameter bit [5:0] RAW_7           = 6'h29;
parameter bit [5:0] RAW_8           = 6'h2a;
parameter bit [5:0] RAW_10          = 6'h2b;
parameter bit [5:0] RAW_12          = 6'h2c;
parameter bit [5:0] RAW_14          = 6'h2d;

// Short packets
parameter bit [5:0] FRAME_START     = 6'h0;
parameter bit [5:0] FRAME_END       = 6'h1;
parameter bit [5:0] LINE_START      = 6'h2;
parameter bit [5:0] LINE_END        = 6'h3;

endpackage
