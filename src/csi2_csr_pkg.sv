package csi2_csr_pkg;

parameter int CLEAR_STAT_CR          = 0;
parameter int PHY_ENABLE_CR          = 1;
parameter int SCCB_SLAVE_ADDR_CR     = 2;

parameter int TOTAL_CR_CNT           = 3;

parameter int HEADER_ERR_CNT_SR      = 0;
parameter int CORR_HEADER_ERR_CNT_SR = 1;
parameter int CRC_ERR_CNT_SR         = 2;
parameter int MAX_LN_PER_FRAME_SR    = 3;
parameter int MIN_LN_PER_FRAME_SR    = 4;
parameter int MAX_PX_PER_LN_SR       = 5;
parameter int MIN_PX_PER_LN_SR       = 6;

parameter int TOTAL_SR_CNT           = 7;

parameter int TOTAL_REGS_CNT         = 10;

endpackage
