module vga_adapter
(
	input  [3:0] r,
	input  [3:0] g,
	input  [3:0] b,
	input  horizontal_sync,
	input  vertical_sync,
	input  video_output,
	
	output [7:0] vga_r,
	output [7:0] vga_g,
	output [7:0] vga_b,
	output vga_horizontal_sync,
	output vga_vertical_sync,
	output vga_clk,
	output vga_blank_n,
	output vga_sync_n,

	input  clk
);

assign vga_r = {r,r};
assign vga_g = {g,g};
assign vga_b = {b,b};

assign vga_horizontal_sync = horizontal_sync;
assign vga_vertical_sync = vertical_sync;
assign vga_clk = clk;
assign vga_blank_n = video_output;
assign vga_sync_n = 1'b0;

endmodule