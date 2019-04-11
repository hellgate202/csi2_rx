# Clock Configuration
set_property -dict [list                             \
  CONFIG.PCW_OVERRIDE_BASIC_CLOCK        {1}         \
  CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ  {33.333333} \
  CONFIG.PCW_ARMPLL_CTRL_FBDIV           {40}        \
  CONFIG.PCW_DDRPLL_CTRL_FBDIV           {32}        \
  CONFIG.PCW_IOPLL_CTRL_FBDIV            {30}        \
  CONFIG.PCW_APU_CLK_RATIO_ENABLE        {6:2:1}     \
  CONFIG.PCW_CPU_PERIPHERAL_CLKSRC       {ARM PLL}   \
  CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0     {2}         \
  CONFIG.PCW_DDR_PERIPHERAL_CLKSRC       {DDR PLL}   \
  CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0     {2}         \
  CONFIG.PCW_SMC_PERIPHERAL_CLKSRC       {IO PLL}    \
  CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0     {10}        \
  CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC      {IO PLL}    \
  CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0    {5}         \
  CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC     {IO PLL}    \
  CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0   {8}         \
  CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1   {1}         \
  CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC     {IO PLL}    \
  CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0   {8}         \
  CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1   {1}         \
  CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC      {IO PLL}    \
  CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0    {20}        \
  CONFIG.PCW_SPI_PERIPHERAL_CLKSRC       {IO PLL}    \
  CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0     {50}        \
  CONFIG.PCW_UART_PERIPHERAL_CLKSRC      {IO PLL}    \
  CONFIG.PCW_UART_PERIPHERAL_DIVISOR0    {10}        \
  CONFIG.PCW_DCI_PERIPHERAL_CLKSRC       {DDR PLL}   \
  CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0     {15}        \
  CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1     {7}         \
  CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC      {IO PLL}    \
  CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0    {5}         \
  CONFIG.PCW_CAN_PERIPHERAL_CLKSRC       {IO PLL}    \
  CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0     {10}        \
  CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1     {1}         \
  CONFIG.PCW_EN_CLK0_PORT                {1}         \
  CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0   {5}         \
  CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1   {1}         \
  CONFIG.PCW_EN_CLK1_PORT                {0}         \
  CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0   {5}         \
  CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1   {2}         \
  CONFIG.PCW_EN_CLK2_PORT                {0}         \
  CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0   {1}         \
  CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1   {1}         \
  CONFIG.PCW_EN_CLK3_PORT                {0}         \
  CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0   {1}         \
  CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1   {1}         \
  CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC      {External}  \
  CONFIG.PCW_WDT_PERIPHERAL_CLKSRC       {CPU_1X}    \
  CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X}    \
  CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X}    \
  CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X}    \
  CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X}    \
  CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X}    \
  CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X}]   \
[get_bd_cells processing_system7_0]

# DDR Configuration
set_property -dict [list                                                \
  CONFIG.PCW_UIPARAM_DDR_ENABLE                   {1}                   \
  CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE              {DDR 3 (Low Voltage)} \
  CONFIG.PCW_UIPARAM_DDR_PARTNO                   {MT41K256M16 RE-125}  \
  CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH                {32 Bit}              \
  CONFIG.PCW_UIPARAM_DDR_BL                       {8}                   \
  CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ                 {533.333333}          \
  CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF        {1}                   \
  CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP                {Normal (0-85)}       \
  CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL        {1}                   \
  CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE           {1}                   \
  CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE          {1}                   \
  CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0       {0}                   \
  CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1       {0}                   \
  CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2       {0}                   \
  CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3       {0}                   \
  CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0             {0.221}               \
  CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1             {0.222}               \
  CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2             {0.217}               \
  CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3             {0.244}               \
  CONFIG.PCW_UIPARAM_DDR_AL                       {0}                   \
  CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE               {1}                   \
  CONFIG.PCW_DDR_PRIORITY_READPORT_0              {Low}                 \
  CONFIG.PCW_DDR_PRIORITY_READPORT_1              {Low}                 \
  CONFIG.PCW_DDR_PRIORITY_READPORT_2              {Low}                 \
  CONFIG.PCW_DDR_PRIORITY_READPORT_3              {Low}                 \
  CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0             {Low}                 \
  CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1             {Low}                 \
  CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2             {Low}                 \
  CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3             {Low}                 \
  CONFIG.PCW_DDR_PORT0_HPR_ENABLE                 {0}                   \
  CONFIG.PCW_DDR_PORT1_HPR_ENABLE                 {0}                   \
  CONFIG.PCW_DDR_PORT2_HPR_ENABLE                 {0}                   \
  CONFIG.PCW_DDR_PORT3_HPR_ENABLE                 {0}                   \
  CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL   {2}                   \
  CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL   {15}                  \
  CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2}]                  \
[get_bd_cells processing_system7_0]

# MIO Configuration
# Bank Voltages
set_property -dict [list                         \
  CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V}  \
  CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V}] \
[get_bd_cells processing_system7_0]

# QSPI Flash Configuration
set_property -dict [list                             \
  CONFIG.PCW_QSPI_PERIPHERAL_ENABLE    {1}           \
  CONFIG.PCW_QSPI_QSPI_IO              {MIO 1 .. 6}  \
  CONFIG.PCW_QSPI_GRP_SS1_ENABLE       {0}           \
  CONFIG.PCW_QSPI_GRP_IO1_ENABLE       {0}           \
  CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1}           \
  CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO     {MIO 1 .. 6}  \
  CONFIG.PCW_SINGLE_QSPI_DATA_MODE     {x4}          \
  CONFIG.PCW_MIO_1_IOTYPE              {LVCMOS 3.3V} \
  CONFIG.PCW_MIO_1_SLEW                {slow}        \
  CONFIG.PCW_MIO_1_PULLUP              {enabled}     \
  CONFIG.PCW_MIO_2_IOTYPE              {LVCMOS 3.3V} \
  CONFIG.PCW_MIO_2_SLEW                {slow}        \
  CONFIG.PCW_MIO_3_IOTYPE              {LVCMOS 3.3V} \
  CONFIG.PCW_MIO_3_SLEW                {slow}        \
  CONFIG.PCW_MIO_4_IOTYPE              {LVCMOS 3.3V} \
  CONFIG.PCW_MIO_4_SLEW                {slow}        \
  CONFIG.PCW_MIO_5_IOTYPE              {LVCMOS 3.3V} \
  CONFIG.PCW_MIO_5_SLEW                {slow}        \
  CONFIG.PCW_MIO_6_IOTYPE              {LVCMOS 3.3V} \
  CONFIG.PCW_MIO_6_SLEW                {slow}        \
  CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE     {1}           \
  CONFIG.PCW_QSPI_GRP_FBCLK_IO         {MIO 8}       \
  CONFIG.PCW_MIO_8_IOTYPE              {LVCMOS 3.3V} \
  CONFIG.PCW_MIO_8_SLEW                {slow}]       \
[get_bd_cells processing_system7_0]

# Ethernet Controller Configuration
set_property -dict [list \
  CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1}            \
  CONFIG.PCW_ENET0_ENET0_IO          {MIO 16 .. 27} \
  CONFIG.PCW_MIO_16_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_16_SLEW             {fast}         \
  CONFIG.PCW_MIO_16_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_17_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_17_SLEW             {fast}         \
  CONFIG.PCW_MIO_17_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_18_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_18_SLEW             {fast}         \
  CONFIG.PCW_MIO_18_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_19_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_19_SLEW             {fast}         \
  CONFIG.PCW_MIO_19_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_20_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_20_SLEW             {fast}         \
  CONFIG.PCW_MIO_20_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_21_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_21_SLEW             {fast}         \
  CONFIG.PCW_MIO_21_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_22_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_22_SLEW             {fast}         \
  CONFIG.PCW_MIO_22_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_23_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_23_SLEW             {fast}         \
  CONFIG.PCW_MIO_23_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_24_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_24_SLEW             {fast}         \
  CONFIG.PCW_MIO_24_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_25_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_25_SLEW             {fast}         \
  CONFIG.PCW_MIO_25_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_26_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_26_SLEW             {fast}         \
  CONFIG.PCW_MIO_26_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_27_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_27_SLEW             {fast}         \
  CONFIG.PCW_MIO_27_PULLUP           {enabled}      \
  CONFIG.PCW_ENET0_GRP_MDIO_ENABLE   {1}            \
  CONFIG.PCW_ENET0_GRP_MDIO_IO       {MIO 52 .. 53} \
  CONFIG.PCW_MIO_52_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_52_SLEW             {slow}         \
  CONFIG.PCW_MIO_52_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_53_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_53_SLEW             {slow}         \
  CONFIG.PCW_MIO_53_PULLUP           {enabled}      \
  CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0}]           \
[get_bd_cells processing_system7_0]
  
# USB Controller Configuration
set_property -dict [list                           \
  CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1}            \
  CONFIG.PCW_USB0_USB0_IO           {MIO 28 .. 39} \
  CONFIG.PCW_MIO_28_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_28_SLEW            {fast}         \
  CONFIG.PCW_MIO_28_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_29_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_29_SLEW            {fast}         \
  CONFIG.PCW_MIO_29_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_30_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_30_SLEW            {fast}         \
  CONFIG.PCW_MIO_30_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_31_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_31_SLEW            {fast}         \
  CONFIG.PCW_MIO_31_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_32_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_32_SLEW            {fast}         \
  CONFIG.PCW_MIO_32_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_33_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_33_SLEW            {fast}         \
  CONFIG.PCW_MIO_33_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_34_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_34_SLEW            {fast}         \
  CONFIG.PCW_MIO_34_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_35_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_35_SLEW            {fast}         \
  CONFIG.PCW_MIO_35_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_36_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_36_SLEW            {fast}         \
  CONFIG.PCW_MIO_36_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_37_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_37_SLEW            {fast}         \
  CONFIG.PCW_MIO_37_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_38_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_38_SLEW            {fast}         \
  CONFIG.PCW_MIO_38_PULLUP          {enabled}      \
  CONFIG.PCW_MIO_39_IOTYPE          {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_39_SLEW            {fast}         \
  CONFIG.PCW_MIO_39_PULLUP          {enabled}      \
  CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0}]           \
[get_bd_cells processing_system7_0]

# SD Controller Configuration
set_property -dict [list                          \
  CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1}            \
  CONFIG.PCW_SD0_SD0_IO            {MIO 40 .. 45} \
  CONFIG.PCW_MIO_40_IOTYPE         {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_40_SLEW           {slow}         \
  CONFIG.PCW_MIO_40_PULLUP         {enabled}      \
  CONFIG.PCW_MIO_41_IOTYPE         {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_41_SLEW           {slow}         \
  CONFIG.PCW_MIO_41_PULLUP         {enabled}      \
  CONFIG.PCW_MIO_42_IOTYPE         {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_42_SLEW           {slow}         \
  CONFIG.PCW_MIO_42_PULLUP         {enabled}      \
  CONFIG.PCW_MIO_43_IOTYPE         {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_43_SLEW           {slow}         \
  CONFIG.PCW_MIO_43_PULLUP         {enabled}      \
  CONFIG.PCW_MIO_44_IOTYPE         {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_44_SLEW           {slow}         \
  CONFIG.PCW_MIO_44_PULLUP         {enabled}      \
  CONFIG.PCW_MIO_45_IOTYPE         {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_45_SLEW           {slow}         \
  CONFIG.PCW_MIO_45_PULLUP         {enabled}      \
  CONFIG.PCW_SD0_GRP_CD_ENABLE     {1}            \
  CONFIG.PCW_SD0_GRP_CD_IO         {MI0 47}       \
  CONFIG.PCW_MIO_47_IOTYPE         {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_47_SLEW           {slow}         \
  CONFIG.PCW_MIO_47_PULLUP         {enabled}      \
  CONFIG.PCW_SD0_GRP_POW_ENABLE    {0}            \
  CONFIG.PCW_SD0_GRP_WP_ENABLE     {0}            \
  CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0}]           \
[get_bd_cells processing_system7_0]

# UART Controller Configuration
set_property -dict [list                            \
  CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0}            \
  CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1}            \
  CONFIG.PCW_UART1_UART1_IO          {MIO 48 .. 49} \
  CONFIG.PCW_MIO_48_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_48_SLEW             {slow}         \
  CONFIG.PCW_MIO_48_PULLUP           {enabled}      \
  CONFIG.PCW_MIO_49_IOTYPE           {LVCMOS 1.8V}  \
  CONFIG.PCW_MIO_49_SLEW             {slow}         \
  CONFIG.PCW_MIO_49_PULLUP           {enabled}      \
  CONFIG.PCW_UART1_GRP_FULL_ENABLE   {0}]           \
[get_bd_cells processing_system7_0]

# I2C Controller Configuration
set_property -dict [list                 \
  CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0}  \
  CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0}] \
[get_bd_cells processing_system7_0]

# SPI Controller Configuration
set_property -dict [list                 \
  CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0}  \
  CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0}] \
[get_bd_cells processing_system7_0]

# CAN Controller Configuration
set_property -dict [list                 \
  CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0}  \
  CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0}] \
[get_bd_cells processing_system7_0]

# GPIO Configuration
set_property -dict [list                              \
  CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0}               \
  CONFIG.PCW_GPIO_MIO_GPIO_ENABLE   {1}               \
  CONFIG.PCW_GPIO_MIO_GPIO_IO       {MIO}             \
  CONFIG.PCW_MIO_0_IOTYPE           {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_0_SLEW             {slow}            \
  CONFIG.PCW_MIO_0_PULLUP           {enabled}         \
  CONFIG.PCW_MIO_7_IOTYPE           {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_7_SLEW             {slow}            \
  CONFIG.PCW_MIO_9_IOTYPE           {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_9_SLEW             {slow}            \
  CONFIG.PCW_MIO_9_PULLUP           {enabled}         \
  CONFIG.PCW_MIO_10_IOTYPE          {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_10_SLEW            {slow}            \
  CONFIG.PCW_MIO_10_PULLUP          {enabled}         \
  CONFIG.PCW_MIO_11_IOTYPE          {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_11_SLEW            {slow}            \
  CONFIG.PCW_MIO_11_PULLUP          {enabled}         \
  CONFIG.PCW_MIO_12_IOTYPE          {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_12_SLEW            {slow}            \
  CONFIG.PCW_MIO_12_PULLUP          {enabled}         \
  CONFIG.PCW_MIO_13_IOTYPE          {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_13_SLEW            {slow}            \
  CONFIG.PCW_MIO_13_PULLUP          {enabled}         \
  CONFIG.PCW_MIO_14_IOTYPE          {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_14_SLEW            {slow}            \
  CONFIG.PCW_MIO_14_PULLUP          {enabled}         \
  CONFIG.PCW_MIO_15_IOTYPE          {LVCMOS 3.3V}     \
  CONFIG.PCW_MIO_15_SLEW            {slow}            \
  CONFIG.PCW_MIO_15_PULLUP          {enabled}         \
  CONFIG.PCW_MIO_47_IOTYPE          {LVCMOS 1.8V}     \
  CONFIG.PCW_MIO_47_SLEW            {slow}            \
  CONFIG.PCW_MIO_47_PULLUP          {enabled}         \
  CONFIG.PCW_MIO_50_IOTYPE          {LVCMOS 1.8V}     \
  CONFIG.PCW_MIO_50_SLEW            {slow}            \
  CONFIG.PCW_MIO_50_PULLUP          {enabled}         \
  CONFIG.PCW_MIO_51_IOTYPE          {LVCMOS 1.8V}     \
  CONFIG.PCW_MIO_51_SLEW            {slow}            \
  CONFIG.PCW_MIO_51_PULLUP          {enabled}         \
  CONFIG.PCW_ENET_RESET_ENABLE      {0}               \
  CONFIG.PCW_USB_RESET_ENABLE       {1}               \
  CONFIG.PCW_USB_RESET_SELECT       {Share reset pin} \
  CONFIG.PCW_USB0_RESET_ENABLE      {1}               \
  CONFIG.PCW_USB0_RESET_IO          {MIO 46}          \
  CONFIG.PCW_MIO_46_IOTYPE          {LVCMOS 1.8V}     \
  CONFIG.PCW_MIO_46_SLEW            {slow}            \
  CONFIG.PCW_MIO_46_PULLUP          {enabled}         \
  CONFIG.PCW_USB_RESET_POLARITY     {Active low}      \
  CONFIG.PCW_I2C_RESET_ENABLE       {0}]              \
[get_bd_cells processing_system7_0]

# APU GPIO
set_property -dict [list                 \
  CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0}  \
  CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0}  \
  CONFIG.PCW_WDT_PERIPHERAL_ENABLE  {0}] \
[get_bd_cells processing_system7_0]

# Programmable Logic Test and Debug
set_property -dict [list                  \
  CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0}  \
  CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0}] \
[get_bd_cells processing_system7_0]

# Fabric Interrupts
set_property -dict [list               \
  CONFIG.PCW_USE_FABRIC_INTERRUPT {0}] \
[get_bd_cells processing_system7_0]

# PS-PL Configuration
set_property -dict [list                      \
  CONFIG.PCW_UART1_BAUD_RATE         {115200} \
  CONFIG.PCW_USE_AXI_FABRIC_IDLE     {0}      \
  CONFIG.PCW_USE_DDR_BYPASS          {0}      \
  CONFIG.PCW_USE_DEBUG               {0}      \
  CONFIG.PCW_USE_TRACE               {0}      \
  CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0}      \
  CONFIG.PCW_EN_4K_TIMER             {0}      \
  CONFIG.PCW_USE_PROC_EVENT_BUS      {0}      \
  CONFIG.PCW_USE_HIGH_OCM            {0}      \
  CONFIG.PCW_USE_EXPANDED_IOP        {0}      \
  CONFIG.PCW_USE_CORESIGHT           {0}      \
  CONFIG.PCW_USE_PS_SLCR_REGISTERS   {0}      \
  CONFIG.PCW_EN_CLKTRIG0_PORT        {0}      \
  CONFIG.PCW_EN_CLKTRIG1_PORT        {0}      \
  CONFIG.PCW_EN_CLKTRIG2_PORT        {0}      \
  CONFIG.PCW_EN_CLKTRIG3_PORT        {0}      \
  CONFIG.PCW_EN_RST0_PORT            {1}      \
  CONFIG.PCW_EN_RST1_PORT            {0}      \
  CONFIG.PCW_EN_RST2_PORT            {0}      \
  CONFIG.PCW_EN_RST3_PORT            {0}      \
  CONFIG.PCW_USE_AXI_NONSECURE       {0}      \
  CONFIG.PCW_USE_M_AXI_GP0           {0}      \
  CONFIG.PCW_USE_M_AXI_GP1           {0}      \
  CONFIG.PCW_USE_S_AXI_GP0           {0}      \
  CONFIG.PCW_USE_S_AXI_GP1           {0}      \
  CONFIG.PCW_USE_S_AXI_HP0           {0}      \
  CONFIG.PCW_USE_S_AXI_HP1           {0}      \
  CONFIG.PCW_USE_S_AXI_HP2           {0}      \
  CONFIG.PCW_USE_S_AXI_HP3           {0}      \
  CONFIG.PCW_USE_S_AXI_ACP           {0}      \
  CONFIG.PCW_USE_DMA0                {0}      \
  CONFIG.PCW_USE_DMA1                {0}      \
  CONFIG.PCW_USE_DMA2                {0}      \
  CONFIG.PCW_USE_DMA3                {0}      \
  CONFIG.PCW_USE_CROSS_TRIGGER       {0}]     \
[get_bd_cells processing_system7_0]

