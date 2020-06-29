package csi2_csr_pkg;

parameter int CLEAR_STAT_CR          = 0; //0x0000
parameter int PHY_ENABLE_CR          = 1; //0x0004
parameter int SCCB_SLAVE_ADDR_CR     = 2; //0x0008
parameter int LANE_0_DELAY_CR        = 3; //0x000c
parameter int LANE_1_DELAY_CR        = 4; //0x0010
parameter int DELAY_ACT_CR           = 5; //0x0014
parameter int CAM_RST_STB_CR         = 6; //0x0018

parameter int TOTAL_CR_CNT           = 7;

parameter int HEADER_ERR_CNT_SR      = 7;  //0x001c
parameter int CORR_HEADER_ERR_CNT_SR = 8;  //0x0020
parameter int CRC_ERR_CNT_SR         = 9;  //0x0024
parameter int MAX_LN_PER_FRAME_SR    = 10; //0x0028
parameter int MIN_LN_PER_FRAME_SR    = 11; //0x002c
parameter int MAX_PX_PER_LN_SR       = 12; //0x0030
parameter int MIN_PX_PER_LN_SR       = 13; //0x0034
parameter int DPHY_BYTE_CLK_SR       = 14; //0x0038
parameter int FPS_SR                 = 15; //0x003c

parameter int TOTAL_SR_CNT           = 9;

parameter int TOTAL_REGS_CNT         = 16;

endpackage
