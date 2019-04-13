module dphy_32b_map #(
  parameter int DATA_LANES = 4
)(
  input                                    byte_clk_i,
  input                                    srst_i,
  input        [DATA_LANES - 1 : 0][7 : 0] word_data_i,
  input                                    valid_i,
  input                                    eop_i,
  output logic [31:0]                      maped_data_o,
  output logic                             valid_o
);

logic [3 : 0] word_pos;
logic         word_done;

always_ff @( posedge byte_clk_i )
  if( srst_i )
    word_pos <= 'b1;
  else
    if( word_done || eop_i )
      word_pos <= 'b1;
    else
      if( valid_i )
        word_pos <= { word_pos[2 : 0], word_pos[3] };

generate
  case( DATA_LANES )
    1:
      begin : one_lane
        always_ff @( posedge byte_clk_i )
          if( srst_i )
            maped_data_o <= '0;
          else
            for( int i = 0; i < 4; i++ )
              if( word_pos[i] )
                maped_data_o[(i + 1) * 8 - 1 -: 8] <= word_data_i;

        always_ff @( posedge byte_clk_i )
          if( srst_i )
            valid_o <= 1'b0;
          else
            if( word_pos == 4'b1000 && !eop_i )
              valid_o <= valid_i;
            else
              valid_o <= 1'b0;

          assign word_done = ( word_pos == 4'b1000 && valid_i );
      end
    2:
      begin : two_lanes
        always_ff @( posedge byte_clk_i )
          if( srst_i )
            maped_data_o <= '0;
          else
            for( int i = 0; i < 2; i++ )
              if( word_pos[i] )
                maped_data_o[( i + 1) * 16 - 1 -: 16] <= word_data_i;

        always_ff @( posedge byte_clk_i )
          if( srst_i )
            valid_o <= 1'b0;
          else
            if( ( word_pos == 4'b1000 || word_pos == 4'b0010 ) &&
                !eop_i )
              valid_o <= valid_i;
            else
              valid_o <= 1'b0;

        assign word_done = ( ( word_pos == 4'b1000 || word_pos == 4'b0010 ) && valid_i );
      end
    3:
      begin : three_lanes
        logic [15:0] old_bytes;

        always_ff @( posedge byte_clk_i )
          if( srst_i )
            begin
              maped_data_o <= '0;
              old_bytes    <= '0;
            end
          else
            case( word_pos )
              4'b0001:
                begin
                  maped_data_o[23 : 0] <= word_data_i;
                end
              4'b0010:
                begin
                  maped_data_o[31 : 24] <= word_data_i[0];
                  old_bytes             <= word_data_i[2:1];
                end
              4'b0100:
                begin
                  maped_data_o[15 : 0]  <= old_bytes;
                  maped_data_o[31 : 16] <= word_data_i[1 : 0];
                  old_bytes[7 : 0]      <= word_data_i[2];
                end
              4'b1000:
                begin
                  maped_data_o[7 : 0]  <= old_bytes[7 : 0];
                  maped_data_o[31 : 8] <= word_data_i;
                end
              default:
                begin
                  maped_data_o <= maped_data_o;
                  old_bytes    <= old_bytes;
                end
            endcase

        always_ff @( posedge byte_clk_i )
          if( srst_i )
            valid_o <= 1'b0;
          else
            if( word_pos != 4'b0001 && !eop_i )
              valid_o <= valid_i;
            else
              valid_o <= 1'b0;

        assign word_done = ( word_pos == 4'b1000 && valid_i );
      end
    4:
      begin : four_lanes
        always_ff @( posedge byte_clk_i )
          if( srst_i )
            maped_data_o <= '0;
          else
            maped_data_o <= word_data_i;

        always_ff @( posedge byte_clk_i )
          if( srst_i )
            valid_o <= 1'b0;
          else
            if( !eop_i )
              valid_o <= valid_i;

        assign word_done = valid_i;
      end
    default:
      begin : unspecified_lanes
        always_ff @( posedge byte_clk_i )
          if( srst_i )
            maped_data_o <= '0;
          else
            maped_data_o <= maped_data_o;

        always_ff @( posedge byte_clk_i )
          if( srst_i )
            valid_o <= 1'b0;
          else
            valid_o <= valid_o;

        assign word_done = 1'b0;
      end
  endcase
endgenerate

endmodule
