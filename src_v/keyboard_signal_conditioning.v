module keyboard_signal_conditioning
(
	input  ps2_clk,
	input  ps2_data,
	
	input  synchronizer_enable,
	input  [4:0] debounce_time,
	output keyboard_clk,
	output keyboard_data,

	input  clk,
	input  rst_n
);

wire synchronized_clk;
wire debounced_clk;
wire synchronized_data;

wire intermediate_clk;

wire [31:0] reload;

assign intermediate_clk = synchronizer_enable ? synchronized_clk  : ps2_clk;
assign keyboard_data    = synchronizer_enable ? synchronized_data : ps2_data;

assign reload = 32'd1 << debounce_time;

assign keyboard_clk = (debounce_time != 5'd0) ? debounced_clk : intermediate_clk;

cdc_synchronizer clk_cdc_synchronizer(
	.in       (ps2_clk),
	.out      (synchronized_clk),
	.clk      (clk),
	.rst_n    (rst_n)
);

cdc_synchronizer data_cdc_synchronizer(
	.in       (ps2_data),
	.out      (synchronized_data),
	.clk      (clk),
	.rst_n    (rst_n)
);

debouncer clk_debouncer(
	.in        (intermediate_clk),
	.reload    (reload),
	.out       (debounced_clk),
	.clk       (clk),
	.rst_n     (rst_n)
);

endmodule