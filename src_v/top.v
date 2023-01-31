module top
(
	input  CLOCK_50,
	
	input  [9:0] SW,
	input  [3:0] KEY,

	input  PS2_CLK,
	input  PS2_DAT,

	inout  [2:0] GPIO,

	output AUD_DACLRCK,
	output AUD_DACDAT,
	output AUD_XCK,
	output AUD_BCLK,
	output I2C_SCLK,
	inout  I2C_SDAT,

	output [12:0] DRAM_ADDR,
	output  [1:0] DRAM_BA,
	output        DRAM_LDQM,
	output        DRAM_UDQM,
	output        DRAM_RAS_N,
	output        DRAM_CAS_N,
	output        DRAM_CKE,
	output        DRAM_CLK,
	output        DRAM_WE_N,
	output        DRAM_CS_N,
	inout  [15:0] DRAM_DQ,

	output [7:0] VGA_R,
	output [7:0] VGA_G,
	output [7:0] VGA_B,
	output VGA_HS,
	output VGA_VS,
	output VGA_CLK,
	output VGA_BLANK_N,
	output VGA_SYNC_N,

	output [6:0] HEX0,
	output [6:0] HEX1,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [9:0] LED
);

wire clk = CLOCK_50;
wire rst;
wire rst_p;
wire rst_n;

wire [9:0] debug_switch;
wire [2:0] debug_button;
wire led_select, seven_segment_select;

wire read;
wire write;
wire [31:0] address;
wire [31:0] data;
wire  [3:0] memory_byte_enable;
wire [31:0] pc;
wire  [9:0] debug_leds;

wire [9:0] mX = 10'd0;
wire [9:0] mY = 10'd0;

wire [3:0] r;
wire [3:0] g;
wire [3:0] b;
wire horizontal_sync;
wire vertical_sync;
wire video_output;

wire synchronizer_enable;
wire [4:0] debounce_time;

wire keyboard_clk;
wire keyboard_data;

wire [23:0] key_code;
wire parity_error;
wire frame_error;

wire morse_code_in;
wire morse_code_out;
wire [7:0] receive_history;
wire line_invert;
wire line_loop;
wire sound_enable;
wire sound_sample_select;

wire [41:0] hex;

assign HEX0 = hex[6:0];
assign HEX1 = hex[13:7];
assign HEX2 = hex[20:14];
assign HEX3 = hex[27:21];
assign HEX4 = hex[34:28];
assign HEX5 = hex[41:35];

user_interface u_user_interface(
	.switch                  (SW),
	.button                  (KEY),
	.rst                     (rst),
	.debug_switch            (debug_switch),
	.debug_button            (debug_button),
	.led_select              (led_select),
	.seven_segment_select    (seven_segment_select)
);

por_counter #(
	.PorValue    (32'd5050)
) u_por_counter(
	.rst_p       (rst_p),
	.rst_n       (rst_n),
	.clk         (clk),
	.rst         (rst)
);

//TODO cleanup these port names

ArillaCore ArillaCore_inst(
	.FPGA_CLK            (clk),
	.SW                  (debug_switch),
	.BUTTON              (debug_button),
	.LED                 (debug_leds),
	.MemoryByteEnable    (memory_byte_enable),
	.WR                  (write),
	.RD                  (read),
	.ADDR                (address),
	.PC                  (pc),
	.DATA                (data)
);

SRAMAdapter SRAMAdapter_inst(
	.ADDR          (address),
	.RD            (read),
	.WR            (write),
	.ByteEnable    (memory_byte_enable),
	.clk           (clk),
	.DATA          (data)
);

GPU GPU_inst(
	.ADDR          (address),
	.WR            (write),
	.RD            (read),
	.clk           (clk),
	.mY            (mY),
	.mX            (mX),
	.rst           (rst_p),
	.G             (g),
	.R             (r),
	.B             (b),
	.H_SYNC        (horizontal_sync),
	.V_SYNC        (vertical_sync),
	.SDRAM_CTRL    ({DRAM_ADDR,DRAM_BA,DRAM_RAS_N,DRAM_CAS_N,DRAM_LDQM,DRAM_UDQM,DRAM_CKE,DRAM_CLK,DRAM_WE_N,DRAM_CS_N}),
	.VDO_OUT       (video_output),
	.DATA          (data),
	.SDRAM_DQ      (DRAM_DQ)
);

keyboard_bus_interface u_keyboard_bus_interface(
	.data_wire              (data),
	.address_wire           (address),
	.read                   (read),
	.write_wire             (write),
	.debounce_time          (debounce_time),
	.synchronizer_enable    (synchronizer_enable),
	.frame_error            (frame_error),
	.parity_error           (parity_error),
	.key_code               (key_code),
	.clk                    (clk),
	.rst_n                  (rst_n)
);

keyboard_controller u_keyboard_controller(
	.keyboard_clk     (keyboard_clk),
	.keyboard_data    (keyboard_data),
	.key_code         (key_code),
	.parity_error     (parity_error),
	.frame_error      (frame_error),
	.clk              (clk),
	.rst_n            (rst_n)
);

keyboard_signal_conditioning u_keyboard_signal_conditioning(
	.ps2_clk                (PS2_CLK),
	.ps2_data               (PS2_DAT),
	.synchronizer_enable    (synchronizer_enable),
	.debounce_time          (debounce_time),
	.keyboard_clk           (keyboard_clk),
	.keyboard_data          (keyboard_data),
	.clk                    (clk),
	.rst_n                  (rst_n)
);

morse_code_transciever u_morse_code_transciever(
	.data                   (data),
	.address                (address),
	.read                   (read),
	.write                  (write),
	.in                     (morse_code_in),
	.out                    (morse_code_out),
	.line_invert            (line_invert),
	.line_loop              (line_loop),
	.sound_enable           (sound_enable),
	.sound_sample_select    (sound_sample_select),
	.receive_history        (receive_history),
	.clk                    (clk),
	.rst_n                  (rst_n)
);

transciever_switch u_transciever_switch(
	.line_invert       (line_invert),
	.line_loop         (line_loop),
	.morse_code_in     (morse_code_in),
	.morse_code_out    (morse_code_out),
	.GPIO0             (GPIO[0]),
	.GPIO1             (GPIO[1])
);

square_wave_generator #(
	.HighFrequency       (32'd49999),
	.LowFrequency        (32'd99999)
) u_square_wave_generator(
	.in                  (morse_code_out),
	.enable              (sound_enable),
	.frequency_select    (sound_sample_select),
	.out                 (GPIO[2]),
	.clk                 (clk),
	.rst_n               (rst_n)
);

codec_driver u_codec_driver(
	.sound_input            (morse_code_out),
	.sound_enable           (sound_enable),
	.sound_sample_select    (sound_sample_select),
	.aud_daclrck            (AUD_DACLRCK),
	.aud_dacdat             (AUD_DACDAT),
	.aud_bclk               (AUD_BCLK),
	.aud_xck                (AUD_XCK),
	.i2c_sdat               (I2C_SDAT),
	.i2c_sclk               (I2C_SCLK),
	.clk                    (clk),
	.rst_n                  (!rst)
);

vga_adapter u_vga_adapter(
	.r                      (r),
	.g                      (g),
	.b                      (b),
	.horizontal_sync        (horizontal_sync),
	.vertical_sync          (vertical_sync),
	.video_output           (video_output),
	.vga_r                  (VGA_R),
	.vga_g                  (VGA_G),
	.vga_b                  (VGA_B),
	.vga_horizontal_sync    (VGA_HS),
	.vga_vertical_sync      (VGA_VS),
	.vga_clk                (VGA_CLK),
	.vga_blank_n            (VGA_BLANK_N),
	.vga_sync_n             (VGA_SYNC_N),
	.clk                    (clk)
);

seven_segment_interface u_seven_segment_interface(
	.pc                      (pc[23:0]),
	.key_code                (key_code),
	.seven_segment_select    (seven_segment_select),
	.hex                     (hex)
);

led_controller u_led_controller(
	.debug_leds         (debug_leds),
	.receive_history    (receive_history),
	.morse_code_in      (morse_code_in),
	.morse_code_out     (morse_code_out),
	.led_select         (led_select),
	.led                (LED)
);

endmodule