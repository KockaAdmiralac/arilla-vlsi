module PS2_signal_conditioning
(
    input PS2_CLK,
    input PS2_DATA,
    input clk,
    input rst_n,
    input SYNCH_EN,
    input [4:0] DEB_TIME,
    output CLK,
    output DATA
);

wire SYNCH_CLK;
wire SYNCH_DATA;
wire DEB_CLK;

wire immedClk;

wire [31:0] RELOAD;

CDC_synchronizer clks(PS2_CLK,clk,rst_n,SYNCH_CLK);
CDC_synchronizer datas(PS2_DATA,clk,rst_n,SYNCH_DATA);

assign immedClk = SYNCH_EN ? SYNCH_CLK : PS2_CLK;
assign DATA = SYNCH_EN ? SYNCH_DATA : PS2_DATA;

assign RELOAD = 1 << DEB_TIME;

Debouncer deb(immedClk,clk,rst_n,RELOAD,DEB_CLK);

assign CLK = (DEB_TIME != 0) ? DEB_CLK : immedClk;

endmodule