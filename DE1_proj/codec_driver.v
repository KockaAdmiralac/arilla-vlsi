module codec_driver 
(
	input 		clk,
	input 		rst_n,
	// Input control
	input 		sound_enable,
	input			sound_input,
	input 		sound_sample_select,
	// Codec digital audio interface
	output		aud_daclrck,			//	Audio CODEC DAC LR Clock
	output		aud_dacdat,				//	Audio CODEC DAC Data
	output reg	aud_bclk,				//	Audio CODEC Bit-Stream Clock
	output		aud_xck,				   //	Audio CODEC Chip Clock
	// Codec control interface
	inout			i2c_sdat,				//	I2C Data
	output		i2c_sclk 				//	I2C Clock
);

// Constants
localparam MCLK_FREQUENCY = 18_432_000;
localparam FUNDAMENTAL_SR = 8_000;
localparam SAMPLE_WIDTH = 16;
localparam CHANNELS = 2;
localparam BCLK_FREQUENCY = 2 * CHANNELS * SAMPLE_WIDTH * FUNDAMENTAL_SR;

localparam NUM_OF_SAMPLES = 1023;
localparam ROM_SAMPLE_WIDTH = 8;

// Codec control
wire complete;

CodecControl codec_control_inst (
	.rst_n(rst_n),
	.clk(clk),
	.I2C_SCLK(i2c_sclk),
	.I2C_SDAT(i2c_sdat),
	.complete(complete)
); 

//	aud_xck (Master clock) generation 
CodecPLL  pll_inst (	
	.areset(!complete),
	.inclk0(clk),
	.c0(aud_xck)
);

// BCLK generation
reg [5:0] bclk_divider;

always @(posedge aud_xck, negedge rst_n) begin
	if (!rst_n) begin
		bclk_divider <= 4'b0;
		aud_bclk <= 1'b0;
	end else begin
		if (bclk_divider >= (MCLK_FREQUENCY / BCLK_FREQUENCY - 1)) begin
			bclk_divider <= 1'b0;
			aud_bclk <= ~aud_bclk;
		end else begin
			bclk_divider <= bclk_divider + 1'b1;
			//aud_bclk <= aud_bclk;
		end
	end
end

// Channel clock (aud_daclrck) generation
reg [10:0] channel_clock_divider;
reg channel_clock;
assign aud_daclrck = channel_clock;

always @(posedge aud_xck, negedge rst_n) begin
	if (!rst_n) begin
		channel_clock <= 1'b0;
		channel_clock_divider <= 11'b0;
	end else begin
		if (channel_clock_divider >=  MCLK_FREQUENCY / (FUNDAMENTAL_SR * 2) - 1) begin
			channel_clock_divider <= 11'b0;
			channel_clock <= ~channel_clock;
		end else begin
			channel_clock_divider <= channel_clock_divider + 11'b1;
		end
	end
end


// Playing samples
wire next_sample;
wire replay_sample;
reg [9:0] current_sample;
reg [3:0] current_bit;

wire[7:0] sine_sample_data;
wire[7:0] quack_sample_data;

EdgeDetector channel_edge_inst
(
	.clk(clk),
	.rst_n(rst_n),
	.in(channel_clock),
	.out_fe(replay_sample),
	.out_re(next_sample)
);

wire BCLK_RE;
wire BCLK_FE;

EdgeDetector bclk_edge_inst
(
	.clk(clk),
	.rst_n(rst_n),
	.in(aud_bclk),
	.out_re(BCLK_RE),
	.out_fe(BCLK_FE)
);

wire start_playing;

EdgeDetector in_edge_inst
(
	.clk(clk),
	.rst_n(rst_n),
	.in(sound_input),
	.out_re(start_playing)
);


wire [7:0] sample_data = (sound_sample_select) ? quack_sample_data : sine_sample_data;
assign aud_dacdat = (current_bit < ROM_SAMPLE_WIDTH && sound_enable && sound_input) ? sample_data[7 - current_bit] : 1'b0;

always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		current_bit <= 4'b0;
		current_sample <= 10'b0;
	end else begin
		if (next_sample) begin
			current_bit <= 4'b0;
			current_sample <= current_sample + 10'b1;
		end
		
		if (replay_sample) begin 
			current_bit <= 4'b0;
		end
		
		if (BCLK_FE) begin
			if (current_bit < ROM_SAMPLE_WIDTH) begin
				current_bit <= current_bit + 4'b1;
			end
		end
		
		if (start_playing)
			current_sample <= 10'b0;
	end
end

// ROMs
sync_rom #(
    .BusWidth              (10),
    .DataWidth             (8),
    .InitializationFile    ("../samples/sine.hex")
) sine_sync_rom(
    .read_address          (current_sample),
    .data_out              (sine_sample_data),
    .clk                   (clk)
);

sync_rom #(
    .BusWidth              (10),
    .DataWidth             (8),
    .InitializationFile    ("../samples/quack.hex")
) quack_sync_rom(
    .read_address          (current_sample),
    .data_out              (quack_sample_data),
    .clk                   (clk)
);

endmodule