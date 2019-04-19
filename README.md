CSI2 Receiver IP-core
=====================

IP-core is designed for educational purposes to receive video data from PCAM-5C to Zybo Z7-20 Development Kit.

But i honestly believe this core can also work with other MIPI CSI2 camera modules like Pi Camera.

Module can be reviewed as convertor from CSI2 to AXI4-Stream video stream.

As for CSI2 signals it requires separated DPHY signals for high-speed transmissions and for low-power transmission.

Hence low-power communication is not supported and low-power signals are used to determine whenever high-speed communication starts.

I designed and tested this core for two-lane communication, but was keeping in mind to use up to four lanes, which was verified by testbench.

All following description relates only to two-lane mode of operation.

Structure
---------

```text
                 +----------------+                                                    
  CAM_PWUP       |                |                                                    
<----------------| Power-UP timer |                                                    
                 |                |                                                    
                 +----------------+                                                    
 SCCB Signals    +----------------+                                                    
<--------------->|                |                                                    
 SCCB AXI4-Lite  |  sccb_master   |                                                    
<--------------->|                |                                                    
                 +----------------+                                                    
                 +----------------+       +---------------+                            
 DPHY Signals    |                |       |               | AXI4-Stream Video          
---------------->|    csi2_rx     |------>|   stat_acc    |------------------->        
                 |                |       |               |                            
                 +----------------+       +---------------+                            
                          ^                       |                                    
                          |                       |                                    
                          v                       v                                    
                 +----------------------------------------+                            
 CSR AXI4-Lite   |                                        |                            
<--------------->|                  CSR                   |                            
                 |                                        |                            
                 +----------------------------------------+      
```

As shown above design wrapper contains:

  * AXI4-Lite SCCB master for communication with sensor
  * Error and video output statistics accumulator
  * AXI4-Lite CSR for core tuning and debug
  * Power-up sequence module
  * CSI-2 receiver

CSR Description
---------------

```text
 ________________________________________________________________________________________
|                     |                                     |              |             |
|         Name        |              Description            | Byte Address |   Accsess   |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| CLEAR_STAT          | Clear statistics gathered by the    |     0x00     |     R/W     |
|                     | core. 0-to-1 transition sensitive   |              |             |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| PHY_ENABLE          | When set to 0 byte synchronization  |     0x04     |     R/W     |
|                     | is disabled and no video output is  |              |             |
|                     | provided. Enabled otherwis          |              |             |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| SCCB_SLAVE_ADDR     | Sensor device ID on SCCB bus        |     0x08     |     R/W     |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| LANE_0_DELAY        | Data-to-clock additional delay for  |     0x0c     |     R/W     |
|                     | lane 0                              |              |             |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| LANE_1_DELAY        | Data-to-clock additional delay for  |     0x10     |     R/W     |
|                     | lane 1                              |              |             |  
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| DELAY_ACT           | Actualize additional lane delays.   |     0x14     |     R/W     |
|                     | 0-to-1 transition sensitive         |              |             |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| HEADER_ERR_CNT      | Amount of header errors (droped     |     0x18     |      R      |
|                     | packetS)                            |              |             |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| CORR_HEADER_ERR_CNT | Amount of corrected header errors   |     0x1c     |      R      |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| CRC_ERR_CNT         | Amount of corrupted long packets    |     0x20     |      R      |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| MAX_LN_PER_FRAME    | Maximum amount of long packets      |     0x24     |      R      |
|                     | between FRAME START short packets   |              |             |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| MIN_LN_PER_FRAME    | Minimum amount of long packets      |     0x28     |      R      |
|                     | between FRAME START short packets   |              |             |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| MAX_PX_PER_LN       | Maximum amount of pixels in one     |     0x2c     |      R      |
|                     | long packet                         |              |             |
|_____________________|_____________________________________|______________|_____________|
|                     |                                     |              |             |
| MIN_PX_PER_LN       | Minimum amount of pixels in one     |     0x30     |      R      |
|                     | long packet                         |              |             |
|_____________________|_____________________________________|______________|_____________|

```
Example project description
---------------------------

To create example project for ZYBO Z7-20 and PCAM-5C move to ./example directory and run:

    make build

It will create QSPI boot image for ZYNQ Processing System with FPGA firmware in it.

Connect your ZYBO Z7-20 board to PC and run:

    make prog

After competition you can run:

    make dbg

to run vivado in TCL mode and connect to the board automaticaly or you can do it manuly from gui and running
config script:

    source ./dbg.tcl

It will add some handy commands to accsess sensor and core registers:

  * wr 32b_hex_addr_value 32b_hex_data_value
    To set sensor device ID to 0x3c
    wr 0x00010008 0x0000003c

  * rd 32b_hex_addr_value
    To read amount of CRC errors
    rd 0x00010020

  * run
    Initiaize sensor to 1080p30

In this example design SCCB registers has offset of 0x00000000 and core CSR has offset of 0x00010000

PCAM-5C has 0x3c device ID on SCCB bus
