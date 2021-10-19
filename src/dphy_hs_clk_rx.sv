module dphy_hs_clk_rx #(
  parameter COMPENSATION_METHOD = "PLL"
)(
  input  dphy_clk_p_i,
  input  dphy_clk_n_i,
  output bit_clk_o,
  output bit_clk_inv_o,
  output byte_clk_o
);

logic bit_clk;

// Transform differential clock to bit clk
IBUFDS #(
  .DIFF_TERM    ( 0            ),
  .IBUF_LOW_PWR ( 0            ),
  .IOSTANDARD   ( "DEFAULT"    )
) clk_diff_input (
  .O            ( bit_clk      ),
  .I            ( dphy_clk_p_i ),
  .IB           ( dphy_clk_n_i )
);

generate
  if( COMPENSATION_METHOD == "PLL" )
    begin : pll_compensation
      logic clk_fb_pre_bufg;
      logic clk_fb_post_bufg;
      logic comp_clk_pre_bufg;
      
      PLLE2_ADV #(
        .BANDWIDTH          ( "OPTIMIZED"       ),
        .COMPENSATION       ( "ZHOLD"           ),
        .STARTUP_WAIT       ( "FALSE"           ),
        .DIVCLK_DIVIDE      ( 1                 ),
        .CLKFBOUT_MULT      ( 3                 ),
        .CLKFBOUT_PHASE     ( 0.000             ),
        .CLKOUT0_DIVIDE     ( 3                 ),
        .CLKOUT0_PHASE      ( 0.000             ),
        .CLKOUT0_DUTY_CYCLE ( 0.500             ),
        .CLKIN1_PERIOD      ( 2.500             )
      ) plle2_adv_inst (
        .CLKFBOUT           ( clk_fb_pre_bufg   ),
        .CLKOUT0            ( comp_clk_pre_bufg ),
        .CLKOUT1            (                   ),
        .CLKOUT2            (                   ),
        .CLKOUT3            (                   ),
        .CLKOUT4            (                   ),
        .CLKOUT5            (                   ),
        .CLKFBIN            ( clk_fb_post_bufg  ),
        .CLKIN1             ( bit_clk           ),
        .CLKIN2             ( 1'b0              ),
        .CLKINSEL           ( 1'b1              ),
        .DADDR              ( 7'h0              ),
        .DCLK               ( 1'b0              ),
        .DEN                ( 1'b0              ),
        .DI                 ( 16'h0             ),
        .DO                 (                   ),
        .DRDY               (                   ),
        .DWE                ( 1'b0              ),
        .LOCKED             (                   ),
        .PWRDWN             ( 1'b0              ),
        .RST                ( 1'b0              )
      );
      
      BUFG clk_fb_bufg
      (
        .O ( clk_fb_post_bufg ),
        .I ( clk_fb_pre_bufg  )
      );
      
      BUFG clkout1_buf
      (
        .O ( bit_clk_o         ),
        .I ( comp_clk_pre_bufg )
      );
      
      // Bit clk is DDR clk, so we divide it by 4 to get
      // byte clk
      BUFR #(
        .BUFR_DIVIDE ( "4"        ),
        .SIM_DEVICE  ( "7SERIES"  )
      ) clk_divider (
        .O           ( byte_clk_o ),
        .CE          ( 1'b1       ),
        .CLR         ( 1'b0       ),
        .I           ( bit_clk_o  )
      );

    end
  else
    if( COMPENSATION_METHOD == "MMCM" )
      begin : mmcm_compensation
        logic clk_fb_pre_bufg;
        logic clk_fb_post_bufg;
        logic comp_clk_pre_bufg;
      
        MMCME2_ADV #( 
          .BANDWIDTH            ( "OPTIMIZED"       ),
          .CLKOUT4_CASCADE      ( 0                 ),
          .COMPENSATION         ( "ZHOLD"           ),
          .STARTUP_WAIT         ( 0                 ),
          .DIVCLK_DIVIDE        ( 1                 ),
          .CLKFBOUT_MULT_F      ( 3.000             ),
          .CLKFBOUT_PHASE       ( 0.000             ),
          .CLKFBOUT_USE_FINE_PS ( 0                 ),
          .CLKOUT0_DIVIDE_F     ( 3.000             ),
          .CLKOUT0_PHASE        ( 0.000             ),
          .CLKOUT0_DUTY_CYCLE   ( 0.500             ),
          .CLKOUT0_USE_FINE_PS  ( 0                 ),
          .CLKIN1_PERIOD        ( 2.500             )
        ) mmcm_adv_inst (
          .CLKFBOUT             ( clk_fb_pre_bufg   ),
          .CLKFBOUTB            (                   ),
          .CLKOUT0              ( comp_clk_pre_bufg ),
          .CLKOUT0B             (                   ),
          .CLKOUT1              (                   ),
          .CLKOUT1B             (                   ),
          .CLKOUT2              (                   ),
          .CLKOUT2B             (                   ),
          .CLKOUT3              (                   ),
          .CLKOUT3B             (                   ),
          .CLKOUT4              (                   ),
          .CLKOUT5              (                   ),
          .CLKOUT6              (                   ),
          .CLKFBIN              ( clk_fb_post_bufg  ),
          .CLKIN1               ( bit_clk           ),
          .CLKIN2               ( 1'b0              ),
          .CLKINSEL             ( 1'b1              ),
          .DADDR                ( 7'h0              ),
          .DCLK                 ( 1'b0              ),
          .DEN                  ( 1'b0              ),
          .DI                   ( 16'h0             ),
          .DO                   (                   ),
          .DRDY                 (                   ),
          .DWE                  ( 1'b0              ),
          .PSCLK                ( 1'b0              ),
          .PSEN                 ( 1'b0              ),
          .PSINCDEC             ( 1'b0              ),
          .PSDONE               (                   ),
          .LOCKED               (                   ),
          .CLKINSTOPPED         (                   ),
          .CLKFBSTOPPED         (                   ),
          .PWRDWN               ( 1'b0              ),
          .RST                  ( 1'b0              )
        );

        BUFG clk_fb_bufg
        (
          .O ( clk_fb_post_bufg ),
          .I ( clk_fb_pre_bufg  )
        );
        
        BUFG clkout1_buf
        (
          .O ( bit_clk_o         ),
          .I ( comp_clk_pre_bufg )
        );
        
        // Bit clk is DDR clk, so we divide it by 4 to get
        // byte clk
        BUFR #(
          .BUFR_DIVIDE ( "4"        ),
          .SIM_DEVICE  ( "7SERIES"  )
        ) clk_divider (
          .O           ( byte_clk_o ),
          .CE          ( 1'b1       ),
          .CLR         ( 1'b0       ),
          .I           ( bit_clk_o  )
        );
      end
    else
      begin : no_pll_compensation
        // Allows us to use bit clk as logic clk
        BUFIO clk_buf (
          .O ( bit_clk_o ),
          .I ( bit_clk   )
        );
        
        // Bit clk is DDR clk, so we divide it by 4 to get
        // byte clk
        BUFR #(
          .BUFR_DIVIDE ( "4"        ),
          .SIM_DEVICE  ( "7SERIES"  )
        ) clk_divider (
          .O           ( byte_clk_o ),
          .CE          ( 1'b1       ),
          .CLR         ( 1'b0       ),
          .I           ( bit_clk    )
        );
      end
endgenerate

assign bit_clk_inv_o = !bit_clk_o;

endmodule
