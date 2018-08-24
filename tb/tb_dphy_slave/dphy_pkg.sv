package dphy_pkg;

`timescale 1 ps / 1 ps
class DPHYSender #(
  parameter DATA_LANES = 1,
  parameter DPHY_CLK_T = 3000
);

localparam SYNC_SEQUENCE = 8'b10111000;

// We rule this interface
virtual dphy_if #(
  .DATA_LANES ( DATA_LANES )
) dphy_if_v;

// User put bytes to send here
mailbox                   data_to_send;
// We transfer data from mailbox to queue to work with
bit [7:0]                 data_buffer [$];
// From this buffer data is sent to lanes
bit [DATA_LANES-1:0][7:0] lane_buffer;

bit clk_en = 1'b0;

function new(
  virtual dphy_if #(
    .DATA_LANES ( DATA_LANES )
  ) dphy_if_v,
  mailbox data_to_send
);
  this.dphy_if_v    = dphy_if_v;
  this.data_to_send = data_to_send;
  init_interface();
endfunction

function automatic void init_interface();
  dphy_if_v.hs_data_p <= '0;
  dphy_if_v.hs_data_n <= '1;
  dphy_if_v.hs_clk_p  <= 1'b0;
  dphy_if_v.hs_clk_n  <= 1'b1;
  fork
    gen_clk;
  join_none
endfunction

task automatic send;
  bit [7:0] data;
  if( data_to_send.num() == 0 )
    begin
      $display("Error! No data to send.");
      $stop;
    end
  else
    begin
      // Get all data from mailbox and put it to queue
      // After that add synchronizing sequence
      get_data_from_mbx;
      // Start clk for 300 ns before first valid byte
      start_clk;
      #300000;
      while( data_buffer.size() > 0 )
        begin
          // Get as much bytes as lanes from queue to lane buffer
          // If there is no data left fill other lanes with zeroes
          for( int i = 0; i < DATA_LANES; i++ )
            if( data_buffer.size() > 0 )
              lane_buffer[i] = data_buffer.pop_front();
            else
              lane_buffer[i] = 8'd0;
          for( int i = 0; i < DATA_LANES; i++ )
            $display(lane_buffer[i]);
          // Send data from lane buffer to every lane
          for( int i = 0; i < 8; i = i + 2 )
            begin
              for ( int j = 0; j < DATA_LANES; j++ )
                begin
                  dphy_if_v.hs_data_p[j] <= lane_buffer[j][i];
                  dphy_if_v.hs_data_n[j] <= ~lane_buffer[j][i];
                end
              @( posedge dphy_if_v.hs_clk_n );
              for( int j = 0; j < DATA_LANES; j++ )
                begin
                  dphy_if_v.hs_data_p[j] <= lane_buffer[j][i+1];
                  dphy_if_v.hs_data_n[j] <= ~lane_buffer[j][i+1];
                end
              @( posedge dphy_if_v.hs_clk_p );
            end
        end
      // Run clk for 300 ns after last valid byte
      #300000;
      stop_clk;
    end
endtask

task automatic gen_clk;
  forever
    if( clk_en == 1'b1 )
      begin
        #( DPHY_CLK_T / 2 );
        dphy_if_v.hs_clk_p <= ~dphy_if_v.hs_clk_p;
        dphy_if_v.hs_clk_n <= ~dphy_if_v.hs_clk_n;
      end
    else
      begin
        #( DPHY_CLK_T / 2 );
        dphy_if_v.hs_clk_p <= dphy_if_v.hs_clk_p;
        dphy_if_v.hs_clk_n <= dphy_if_v.hs_clk_n;
      end
endtask

task automatic start_clk;
  clk_en = 1'b1;
endtask

task automatic stop_clk;
  clk_en = 1'b0;
endtask

task automatic get_data_from_mbx();
  bit [7:0] data;
  for( int i = 0; i < DATA_LANES; i++ )
    data_buffer.push_back( SYNC_SEQUENCE );
  while( data_to_send.num() > 0 )
    begin
      data_to_send.get( data );
      data_buffer.push_back( data );
    end
endtask

endclass

endpackage
