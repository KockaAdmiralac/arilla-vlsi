module CodecDriver 
(
	input 		clk,
	input 		rst_n,
	// Input control
	input 		MC_SOUND_EN,
	input			MC_SOUND_IN,
	input 		MC_SOUND_SAMPLE,
	// Codec digital audio interface
	output		AUD_DACLRCK,			//	Audio CODEC DAC LR Clock
	output		AUD_DACDAT,				//	Audio CODEC DAC Data
	output reg	AUD_BCLK,				//	Audio CODEC Bit-Stream Clock
	output		AUD_XCK,				   //	Audio CODEC Chip Clock
	// Codec control interface
	inout			I2C_SDAT,				//	I2C Data
	output		I2C_SCLK 				//	I2C Clock
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
	.I2C_SCLK(I2C_SCLK),
	.I2C_SDAT(I2C_SDAT),
	.complete(complete)
); 

//	AUD_XCK (Master clock) generation 
CodecPLL  pll_inst (	
	.areset(!complete),
	.inclk0(clk),
	.c0(AUD_XCK)
);

// BCLK generation
reg [5:0] bclk_divider;

always @(posedge AUD_XCK, negedge rst_n) begin
	if (!rst_n) begin
		bclk_divider <= 4'b0;
		AUD_BCLK <= 1'b0;
	end else begin
		if (bclk_divider >= (MCLK_FREQUENCY / BCLK_FREQUENCY - 1)) begin
			bclk_divider <= 1'b0;
			AUD_BCLK <= ~AUD_BCLK;
		end else begin
			bclk_divider <= bclk_divider + 1'b1;
			//AUD_BCLK <= AUD_BCLK;
		end
	end
end

// Channel clock (AUD_DACLRCK) generation
reg [10:0] channel_clock_divider;
reg channel_clock;
assign AUD_DACLRCK = channel_clock;

always @(posedge AUD_XCK, negedge rst_n) begin
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
	.in(AUD_BCLK),
	.out_re(BCLK_RE),
	.out_fe(BCLK_FE)
);

wire start_playing;

EdgeDetector in_edge_inst
(
	.clk(clk),
	.rst_n(rst_n),
	.in(MC_SOUND_IN),
	.out_re(start_playing)
);


wire [7:0] sample_data = (MC_SOUND_SAMPLE) ? sine_sample_data : quack_sample_data;
assign AUD_DACDAT = (current_bit < ROM_SAMPLE_WIDTH && MC_SOUND_EN && MC_SOUND_IN) ? sample_data[7 - current_bit] : 1'b0;

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
SineROM sine_inst
(
	.address(current_sample),
	.clock(clk),
	.q(sine_sample_data)
);

LongQuackROM quack_inst
(
	.address(current_sample),
	.clock(clk),
	.q(quack_sample_data)
);

endmodule