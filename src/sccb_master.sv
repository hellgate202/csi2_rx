/*
  FSM-wrapper over I2C-controller to create SCCB transactions
  from AXI4-Lite interface to provide simple memory maped interface
  to sensor registers
  Device address should be passed from outside (CSR for example)
  Required address must be contained in first 16 bits of AXI address
  Write data must be in first 8 bits in AXI data
*/

// Package with I2C commands
import i2c_master_pkg::*;

module sccb_master #(
  parameter int CLK_FREQ   = 74_250_000,
  parameter int SCL_FREQ   = 400_000
)(
  input              clk_i,
  input              rst_i,
  axi4_lite_if.slave ctrl_if,
  // Sensor address from CSR
  input [6 : 0]      slave_addr_i,
  input              sda_i,
  output             sda_o,
  output             sda_oe,
  input              scl_i,
  output             scl_o,
  output             scl_oe
);

// Command for I2C PHY
logic [2 : 0]  phy_cmd;
// Competition of command from I2C PHY
logic          cmd_done;
// 1 - Read, 0 - Write
logic          cci_cmd;
// Register address
logic [15 : 0] sub_addr;
// We save write value from AXI here
logic [7 : 0]  tx_reg_data;
logic          tx_bit;
// We save read value from PHY here to send it over AXI
logic [7 : 0]  rx_reg_data;
logic          rx_bit;
// Whatever goes to phy: data or address
logic [7 : 0]  phy_data;

// Always 8 bit transactions over I2C
logic [2 : 0]  bit_cnt;

assign tx_bit = phy_data[7];

/*
  2 Scenarios for read and write
  One starts with arvalid other starts with awvalid 
  Same begining for read and write
  Start -> Device Address -> ACK -> 
  Register Address MSB -> ACK -> Register Address LSB ->
  ACK -> 
  Read:
  Repeated Start -> Device Address -> ACK ->
  Receive Data -> NACK -> Stop
  Write:
  Write Data -> NACK -> Stop
  Whenever we get NACK when there is should be an ACK
  we go to Stop state and if it was read operation we 
  return zeroes
*/
enum logic [3 : 0] { IDLE_S,
                     START_0_S,
                     SLAVE_ADDR_0_S,
                     ACK_0_S,
                     SUB_ADDR_MSB_S,
                     ACK_1_S,
                     SUB_ADDR_LSB_S,
                     ACK_2_S,
                     START_1_S,
                     SLAVE_ADDR_1_S,
                     ACK_3_S,
                     WR_DATA_S,
                     RD_DATA_S,
                     NACK_S,
                     STOP_S } state, next_state;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    state <= IDLE_S;
  else
    state <= next_state;

always_comb
  begin
    next_state = state;
    case( state )
      IDLE_S:
        begin
          if( ctrl_if.arvalid || ctrl_if.awvalid )
            next_state = START_0_S;
        end
      START_0_S:
        begin
          if( cmd_done )
            next_state = SLAVE_ADDR_0_S;
        end
      SLAVE_ADDR_0_S:
        begin
          if( cmd_done && bit_cnt == 3'd7 )
            next_state = ACK_0_S;
        end
      ACK_0_S:
        begin
          if( cmd_done )
            if( !rx_bit )
              next_state = SUB_ADDR_MSB_S;
            else
              next_state = STOP_S;
        end
      SUB_ADDR_MSB_S:
        begin
          if( cmd_done && bit_cnt == 3'd7)
            next_state = ACK_1_S;
        end
      ACK_1_S:
        begin
          if( cmd_done )
            if( !rx_bit )
              next_state = SUB_ADDR_LSB_S;
            else
              next_state = STOP_S;
        end
      SUB_ADDR_LSB_S:
        begin
          if( cmd_done  && bit_cnt == 3'd7 )
            next_state = ACK_2_S;
        end
      ACK_2_S:
        begin
          if( cmd_done )
            if( !rx_bit )
              if( cci_cmd )
                next_state = START_1_S;
              else
                next_state = WR_DATA_S;
            else
              next_state = STOP_S;
        end
      START_1_S:
        begin
          if( cmd_done )
            next_state = SLAVE_ADDR_1_S;
        end
      SLAVE_ADDR_1_S:
        begin
          if( cmd_done && bit_cnt == 3'd7)
            next_state = ACK_3_S;
        end
      ACK_3_S:
        begin
          if( cmd_done )
            if( !rx_bit )
              next_state = RD_DATA_S;
            else
              next_state = STOP_S;
        end
      RD_DATA_S:
        begin
          if( cmd_done && bit_cnt == 3'd7 )
            next_state = NACK_S;
        end
      NACK_S:
        begin
          if( cmd_done )
            next_state = STOP_S;
        end
      STOP_S:
        begin
          if( cmd_done )
            next_state = IDLE_S;
        end
      WR_DATA_S:
        begin
          if( cmd_done && bit_cnt == 3'd7 )
            next_state = NACK_S;
        end
    endcase
  end

assign ctrl_if.awready = state == IDLE_S;
assign ctrl_if.wready  = state == IDLE_S;
assign ctrl_if.arready = state == IDLE_S;
assign ctrl_if.bresp   = 2'b00;
assign ctrl_if.rresp   = 2'b00;

// Locking I2C PHY commands and data from AXI interface
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      cci_cmd     <= 1'b0;
      sub_addr    <= 16'd0;
      tx_reg_data <= 8'd0;
    end
  else
    if( state == IDLE_S )
      if( ctrl_if.awvalid )
        begin
          cci_cmd     <= 1'b0;
          sub_addr    <= ctrl_if.awaddr[15 : 0];
          tx_reg_data <= ctrl_if.wdata[7 : 0];
        end
      else
        if( ctrl_if.arvalid )
          begin
            cci_cmd    <= 1'b1;
            sub_addr   <= ctrl_if.araddr[15 : 0];
          end

// I2C PHY
i2c_master_phy #(
  .SCL_FREQ   ( SCL_FREQ       ),
  .CLK_FREQ   ( CLK_FREQ       )
) i2c_master_phy (
  .clk_i      ( clk_i          ),
  .rst_i      ( rst_i          ),
  .cmd_i      ( phy_cmd        ),
  .data_i     ( tx_bit         ),
  .data_o     ( rx_bit         ),
  .cmd_done_o ( cmd_done       ),
  .arb_lost_o (                ),
  .bus_busy_o (                ),
  .sda_i      ( sda_i          ),
  .sda_o      ( sda_o          ),
  .sda_oe     ( sda_oe         ),
  .scl_i      ( scl_i          ),
  .scl_o      ( scl_o          ),
  .scl_oe     ( scl_oe         )
);

// On states when we are transmitting byte
// data we need to count bits
always_ff @( posedge clk_i, posedge rst_i )
  if ( rst_i )
    bit_cnt <= '0;
  else
    if( ( state == SLAVE_ADDR_0_S ) ||
        ( state == SUB_ADDR_MSB_S ) ||
        ( state == SUB_ADDR_LSB_S ) ||
        ( state == SLAVE_ADDR_1_S ) ||
        ( state == WR_DATA_S      ) ||
        ( state == RD_DATA_S      ) )
      if( cmd_done )
        bit_cnt <= bit_cnt + 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    phy_data <= '0;
  else
    // State transfer conditions when
    // we need to change transmitted data
    if( state != SLAVE_ADDR_0_S && 
        next_state == SLAVE_ADDR_0_S )
      phy_data <= { slave_addr_i, 1'b0 };
    else
      if( state != SLAVE_ADDR_1_S &&
          next_state == SLAVE_ADDR_1_S )
        phy_data <= { slave_addr_i, 1'b1 };
      else
        if( state != SUB_ADDR_MSB_S &&
            next_state == SUB_ADDR_MSB_S )
          phy_data <= sub_addr[15 : 8];
        else
          if( state != SUB_ADDR_LSB_S &&
              next_state == SUB_ADDR_LSB_S )
            phy_data <= sub_addr[7 : 0];
          else
            if( state != WR_DATA_S &&
                next_state == WR_DATA_S )
              phy_data <= tx_reg_data;
            else
              // NACK == 1
              if( state != NACK_S &&
                  next_state == NACK_S )
                phy_data <= 8'h80;
              else
                // Shifting data to PHY MSB first
                if( ( state == SLAVE_ADDR_0_S ) ||
                    ( state == SUB_ADDR_MSB_S ) ||
                    ( state == SUB_ADDR_LSB_S ) ||
                    ( state == SLAVE_ADDR_1_S ) ||
                    ( state == WR_DATA_S      ) )
                  if( cmd_done )
                    phy_data <= phy_data << 1;

// When we complete READ command we get one bit of data
// We accumulate it in rx_reg_data register
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    rx_reg_data <= '0;
  else
    if( state == RD_DATA_S && cmd_done )
      rx_reg_data <= { rx_reg_data[6 : 0], rx_bit };

// If it was read command we return read value
// just before returning into IDLE state
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    begin
      ctrl_if.rvalid <= 1'b0;
      ctrl_if.rdata  <= '0;
    end
  else
    if( state != IDLE_S && next_state == IDLE_S && cci_cmd )
      begin
        ctrl_if.rvalid <= 1'b1;
        ctrl_if.rdata  <= rx_reg_data;
      end
    else
      if( ctrl_if.rready )
        begin
          ctrl_if.rvalid <= 1'b0;
          ctrl_if.rdata  <= '0;
        end

// If it was write command we return write response
// just before returning into IDLE state
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    ctrl_if.bvalid <= 1'b0;
  else
    if( state != IDLE_S && next_state == IDLE_S && !cci_cmd )
      ctrl_if.bvalid <= 1'b1;
    else
      if( ctrl_if.bready )
        ctrl_if.bvalid <= 1'b0;

/*
  We have 4 commands to I2C PHY:
  READ, WRITE, START and STOP
  When we write data we are doing
  WRITE x8. When we read data we are doing
  READ x8. Aquiring ACK is equal to READ x1,
  transfering NACK is equal to WRITE x1.
*/
always_ff @( posedge clk_i, posedge rst_i )
  if ( rst_i )
    phy_cmd <= NOP;
  else
    case( next_state )
      START_0_S:      phy_cmd <= START;
      SLAVE_ADDR_0_S: phy_cmd <= WRITE;
      ACK_0_S:        phy_cmd <= READ;
      SUB_ADDR_MSB_S: phy_cmd <= WRITE;
      ACK_1_S:        phy_cmd <= READ;
      SUB_ADDR_LSB_S: phy_cmd <= WRITE;
      ACK_2_S:        phy_cmd <= READ;
      START_1_S:      phy_cmd <= START;
      SLAVE_ADDR_1_S: phy_cmd <= WRITE;
      ACK_3_S:        phy_cmd <= READ;
      RD_DATA_S:      phy_cmd <= READ;
      NACK_S:         phy_cmd <= WRITE;
      STOP_S:         phy_cmd <= STOP;
      WR_DATA_S:      phy_cmd <= WRITE;
      default:        phy_cmd <= NOP;
    endcase


endmodule

