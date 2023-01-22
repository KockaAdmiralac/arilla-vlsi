module  TOP
(
    input CLK,
    
    input [9:0] SW,
    input [3:0] BTN,

    input PS2_CLK,
    input PS2_DATA,

    inout [1:0] GPIO,
    output GPIO2,

    output AUD_ADCLRCK,
    output AUD_ADCDAT,
    output AUD_DACLRCK,
    output AUD_DACDAT,
    output AUD_XCK,
    output AUD_BCLK,
    output I2C_SCLK,
    output I2C_SDAT,

    output [22:0] SDRAM_CTL,
    inout [15:0] SDRAM_DATA,

    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_CLK,
    output VGA_SYNC_N,
    output VGA_BLANK_N,

    output [47:0] HEX,
    output [9:0] LED
);

wire rst;
wire clk;
wire rst_p;
wire rst_n;

assign clk = CLK;

wire [9:0] D_SW;
wire [2:0] D_BTN;
wire [1:0] CNTRL;

wire pc_n;
wire LED_SEL;

assign pc_n = CNTRL[0];
assign LED_SEL = CNTRL[1];

wire RD;
wire WR;
wire [31:0] ADDR;
wire [31:0] DATA;
wire [3:0] ByteEna;
wire [31:0] PC;
wire [9:0] DEBUG_OUT;

wire [9:0] mX;
wire [9:0] mY;

assign mX = 10'd0;
assign mY = 10'd0;

wire [3:0] R;
wire [3:0] G;
wire [3:0] B;
wire HSYNC;
wire VSYNC;
wire VDO_OUT;

wire SYNCH_EN;
wire [4:0] DEB_TIME;

wire K_CLK;
wire K_DATA;

wire [23:0] K_CD;
wire P_ERR;
wire F_ERR;

wire MC_OUT;
wire MC_IN;
wire [7:0] MC_REC_REG;
wire MC_LINE_INV;
wire MC_LINE_LOOP;
wire MC_SOUND_EN;
wire MC_SOUND_SAMP;

User_interface u_User_interface (
    .SW       (SW),
    .BTN      (BTN),
    .rst      (rst),
    .D_SW     (D_SW),
    .D_BTN    (D_BTN),
    .CNTRL    (CNTRL)
);

POR_counter #(
    .POR_VALUE    (5050)
) u_POR_counter (
    .rst          (rst),
    .clk          (clk),
    .rst_p        (rst_p),
    .rst_n        (rst_n)
);
  
Arilla_core u_Arilla_core (
    .D_SW         (D_SW),
    .D_BTN        (D_BTN),
    .clk          (clk),
    .RD           (RD),
    .WR           (WR),
    .ADDR         (ADDR),
    .DATA         (DATA),
    .ByteEna      (ByteEna),
    .PC           (PC),
    .DEBUG_OUT    (DEBUG_OUT)
);

SRAM u_SRAM (
    .ByteEna    (ByteEna),
    .clk        (clk),
    .RD         (RD),
    .WR         (WR),
    .ADDR       (ADDR),
    .DATA       (DATA)
);

GPU u_GPU (
    .mX            (mX),
    .mY            (mY),
    .clk           (clk),
    .rst_p         (rst_p),
    .RD            (RD),
    .WR            (WR),
    .ADDR          (ADDR),
    .DATA          (DATA),
    .SDRAM_CTL     (SDRAM_CTL),
    .SDRAM_DATA    (SDRAM_DATA),
    .R             (R),
    .G             (G),
    .B             (B),
    .HSYNC         (HSYNC),
    .VSYNC         (VSYNC),
    .VDO_OUT       (VDO_OUT)
);

PS2_signal_conditioning u_PS2_signal_conditioning (
    .PS2_CLK     (PS2_CLK),
    .PS2_DATA    (PS2_DATA),
    .clk         (clk),
    .rst_n       (rst_n),
    .SYNCH_EN    (SYNCH_EN),
    .DEB_TIME    (DEB_TIME),
    .CLK         (K_CLK),
    .DATA        (K_DATA)
);

PS2_keyboard_controller u_PS2_keyboard_controller (
    .K_CLK     (K_CLK),
    .K_DATA    (K_DATA),
    .clk       (clk),
    .rst_n     (rst_n),
    .K_CD      (K_CD),
    .P_ERR     (P_ERR),
    .F_ERR     (F_ERR)
);

ArillaBus_interface u_ArillaBus_interface (
    .DATA        (DATA),
    .ADDR        (ADDR),
    .RD          (RD),
    .WR          (WR),
    .F_ERR       (F_ERR),
    .P_ERR       (P_ERR),
    .K_CD        (K_CD),
    .clk         (clk),
    .rst_n       (rst_n),
    .DEB_TIME    (DEB_TIME),
    .SYNCH_EN    (SYNCH_EN)
);

VGA_adapter u_VGA_adapter (
    .R              (R),
    .G              (G),
    .B              (B),
    .HSYNC          (HSYNC),
    .VSYNC          (VSYNC),
    .VDO_OUT        (VDO_OUT),
    .clk            (clk),
    .VGA_R          (VGA_R),
    .VGA_G          (VGA_G),
    .VGA_B          (VGA_B),
    .VGA_HSYNC      (VGA_HSYNC),
    .VGA_VSYNC      (VGA_VSYNC),
    .VGA_CLK        (VGA_CLK),
    .VGA_BLANK_N    (VGA_BLANK_N),
    .VGA_SYNC_N     (VGA_SYNC_N)
);

Seven_segment_interface u_Seven_segment_interface (
    .PC      (PC),
    .K_CD    (K_CD),
    .pc_n    (pc_n),
    .HEX     (HEX)
);

LED_controller u_LED_controller (
    .DEBUG_OUT     (DEBUG_OUT),
    .MC_OUT        (MC_OUT),
    .MC_IN         (MC_IN),
    .MC_REC_REG    (MC_REC_REG),
    .LED_SEL       (LED_SEL),
    .LED           (LED)
);

Morse_code_transciever u_Morse_code_transciever (
    .RD              (RD),
    .WR              (WR),
    .ADDR            (ADDR),
    .DATA            (DATA),
    .clk             (clk),
    .rst_n           (rst_n),
    .IN              (MC_IN),
    .OUT             (MC_OUT),
    .INV             (MC_LINE_INV),
    .LOOP            (MC_LINE_LOOP),
    .SOUND_EN        (MC_SOUND_EN),
    .SOUND_SAMP      (MC_SOUND_SAMP),
    .REC_REG         (MC_REC_REG)
);

Square_wave_generator #(
    .HIGH_FREQ    (32'd49999),
    .LOW_FREQ     (32'd99999)
) u_Square_wave_generator (
    .in           (MC_OUT),
    .en           (MC_SOUND_EN),
    .freqSel      (MC_SOUND_SAMP),
    .clk          (clk),
    .rst_n        (rst_n),
    .out          (GPIO2)
);

Morse_switch u_Morse_switch (
    .INV          (MC_LINE_INV),
    .LOOP         (MC_LINE_LOOP),
    .MORSE_IN     (MC_IN),
    .MORSE_OUT    (MC_OUT),
    .GPIO0        (GPIO[0]),
    .GPIO1        (GPIO[1])
);

CODEC u_CODEC (
    .clk            (clk),
    .rst_n          (rst_n),
    .out            (MC_OUT),
    .en             (MC_SOUND_EN),
    .samp           (MC_SOUND_SAMP),
    .AUD_ADCLRCK    (AUD_ADCLRCK),
    .AUD_ADCDAT     (AUD_ADCDAT),
    .AUD_DACLRCK    (AUD_DACLRCK),
    .AUD_DACDAT     (AUD_DACDAT),
    .AUD_XCK        (AUD_XCK),
    .AUD_BCLK       (AUD_BCLK),
    .I2C_SCLK       (I2C_SCLK),
    .I2C_SDAT       (I2C_SDAT)
);

endmodule