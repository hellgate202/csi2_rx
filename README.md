# CSI2

2 lanes

420 Mbps each == 210 MHz

word_clk on 32 bit bus will be 52.5 MHz

which will result in 26.25 MHz because data will be
available every 2 ticks

to be sure its 26.25*32 = 840 Mbps

for FHD@30fps 10 bit raw 1936*1096*10*30 = 636.5568 Mbps required

So we are capturing on 52.5 MHz clk and transfer to internal 26.25 Mhz via FIFO

Pixels are aranged by 40 bit packs or 4 pixels, so we captue (32/40)*4 = 3.2 pixels per word

It will resul in 3.2*26.25 = 84 MHz pixel clock
