module csi2_stat_acc
(
  input                clk_i,
  input                srst_i,
  input                clear_stat_i,
  axi4_stream_if.slave video_i,
  input                header_err_i,
  input                corr_header_err_i,
  input                crc_err_i,
  output [31 : 0]      header_err_cnt_o,
  output [31 : 0]      corr_header_err_cnt_o,
  output [31 : 0]      crc_err_cnt_o,
  output [31 : 0]      max_ln_per_frame_o,
  output [31 : 0]      min_ln_per_frame_o,
  output [31 : 0]      max_px_per_ln_o,
  output [31 : 0]      min_px_per_ln_o  
);

logic header_err_d1;
logic header_err_d2;
logic corr_header_err_d1;
logic corr_header_err_d2;
logic crc_err_d1;
logic crc_err_d2;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    begin
      header_err_d1      <= '0; 
      header_err_d1      <= '0; 
      corr_header_err_d1 <= '0; 
      corr_header_err_d2 <= '0; 
      crc_err_d1         <= '0; 
      crc_err_d2         <= '0; 
    end
  else
    begin
      header_err_d1      <= header_err_i;
      header_err_d1      <= header_err_d2;
      corr_header_err_d1 <= corr_header_err_i;
      corr_header_err_d2 <= corr_header_err_d1;
      crc_err_d1         <= crc_err_i;
      crc_err_d2         <= crc_err_d1;
    end

logic [31 : 0] header_err_cnt;
logic [31 : 0] corr_header_err_cnt;
logic [31 : 0] crc_err_cnt;

logic [31 : 0] px_cnt;
logic [31 : 0] max_px_per_ln;
logic [31 : 0] min_px_per_ln;
logic [31 : 0] ln_cnt;
logic [31 : 0] max_ln_per_frame;
logic [31 : 0] min_ln_per_frame;

assign header_err_cnt_o      = header_err_cnt;
assign corr_header_err_cnt_o = corr_header_err_cnt;
assign crc_err_cnt_o         = crc_err_cnt;
assign max_ln_per_frame_o    = max_ln_per_frame;
assign min_ln_per_frame_o    = min_ln_per_frame;
assign max_px_per_ln_o       = max_px_per_ln;
assign min_px_per_ln_o       = min_px_per_ln;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    header_err_cnt <= '0;
  else
    if( clear_stat_i )
      header_err_cnt <= '0;
    else
      if( header_err_d2 )
        header_err_cnt <= header_err_cnt + 1'b1;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    corr_header_err_cnt <= '0;
  else
    if( clear_stat_i )
      corr_header_err_cnt <= '0;
    else
      if( header_err_d2 && corr_header_err_d2 )
        corr_header_err_cnt <= corr_header_err_cnt + 1'b1;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    crc_err_cnt <= '0;
  else
    if( clear_stat_i )
      crc_err_cnt <= '0;
    else
      if( crc_err_d2 )
        crc_err_cnt <= crc_err_cnt + 1'b1;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    px_cnt <= '0;
  else
    if( video_i.tvalid && video_i.tready )
      if( video_i.tlast )
        px_cnt <= '0;
      else
        px_cnt <= px_cnt + 1'b1;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    max_px_per_ln <= '0;
  else
    if( clear_stat_i )
      max_px_per_ln <= '0;
    else
      if( video_i.tvalid && video_i.tready && video_i.tlast )
        if( ( px_cnt + 1'b1 ) > max_px_per_ln )
          max_px_per_ln <= px_cnt + 1'b1;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    min_px_per_ln <= '1;
  else
    if( clear_stat_i )
      min_px_per_ln <= '1;
    else
      if( video_i.tvalid && video_i.tready && video_i.tlast )
        if( ( px_cnt + 1'b1 ) < min_px_per_ln )
          min_px_per_ln <= px_cnt + 1'b1;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    ln_cnt <= '0;
  else
    if( video_i.tvalid && video_i.tready )
      if( video_i.tuser )
        ln_cnt <= '0;
      else
        if( video_i.tlast )
          ln_cnt <= ln_cnt + 1'b1;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    max_ln_per_frame <= '0;
  else
    if( clear_stat_i )
      max_ln_per_frame <= '0;
    else
      if( video_i.tvalid && video_i.tready && video_i.tuser )
        if( ln_cnt > max_ln_per_frame )
          max_ln_per_frame <= ln_cnt;

always_ff @( posedge clk_i, posedge srst_i )
  if( srst_i )
    min_ln_per_frame <= '1;
  else
    if( clear_stat_i )
      min_ln_per_frame <= '1;
    else
      if( video_i.tvalid && video_i.tready && video_i.tuser )
        min_ln_per_frame <= ln_cnt;

endmodule
