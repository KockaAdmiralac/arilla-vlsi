module codec_driver 
(
	input  sound_input,
	input  sound_enable,
	input  sound_sample_select,

	output aud_daclrck, //Audio CODEC DAC LR Clock
	output aud_dacdat,  //Audio CODEC DAC Data
	output aud_bclk,    //Audio CODEC Bit-Stream Clock
	output aud_xck,     //Audio CODEC Chip Clock

	inout  i2c_sdat,    //I2C Data
	output i2c_sclk,    //I2C Clock

	input  clk,
	input  rst_n
);

//Constants
localparam MCLK_FREQUENCY = 32'd18_432_000;
localparam SAMPLE_RATE    = 32'd8_000;
localparam SAMPLE_WIDTH   = 32'd16;
localparam CHANNELS       = 32'd2;
localparam BCLK_FREQUENCY = 32'd2 * CHANNELS * SAMPLE_WIDTH * SAMPLE_RATE;
localparam BCLK_DIVIDER   = MCLK_FREQUENCY / BCLK_FREQUENCY - 32'd1;
localparam LRCK_DIVIDER   = MCLK_FREQUENCY / (SAMPLE_RATE * 32'd2) - 32'd1;

localparam ROM_SAMPLE_WIDTH = 4'd8;

reg [31:0] bclk_clock_divider;
reg bclk_clock;

reg [31:0] lrck_clock_divider;
reg lrck_clock;

wire xck_clock;

wire complete;

assign aud_daclrck = lrck_clock;
assign aud_bclk    = bclk_clock;
assign aud_xck     = xck_clock;

//BCLK generation
always @(posedge xck_clock, negedge rst_n) begin
	if(!rst_n) 
	begin
		bclk_clock_divider <= 32'b0;
		bclk_clock <= 1'b0;
	end
	else
	begin
		if(bclk_clock_divider == BCLK_DIVIDER)
		begin
			bclk_clock_divider <= 32'b0;
			bclk_clock <= ~bclk_clock;
		end
		else
		begin
			bclk_clock_divider <= bclk_clock_divider + 32'b1;
		end
	end
end

//Channel clock (AUD_DACLRCK) generation
always @(posedge xck_clock, negedge rst_n) begin
	if(!rst_n) 
	begin
		lrck_clock_divider <= 32'b0;
		lrck_clock <= 1'b0;
	end
	else
	begin
		if(lrck_clock_divider == LRCK_DIVIDER)
		begin
			lrck_clock_divider <= 32'b0;
			lrck_clock <= ~lrck_clock;
		end
		else
		begin
			lrck_clock_divider <= lrck_clock_divider + 32'b1;
		end
	end
end

codec_controller codec_control_inst(
	.i2c_sdat    (i2c_sdat),
	.i2c_sclk    (i2c_sclk),
	.complete    (complete),
	.clk         (clk),
	.rst_n       (rst_n)
); 

//	aud_xck (Master clock) generation 
codec_pll  pll_inst(	
	.areset    (!complete),
	.inclk0    (clk),
	.c0        (xck_clock)
);

//Playing samples
reg [9:0] current_sample;
reg [3:0] current_bit;

reg sound_playing;

wire next_sample;
wire replay_sample;

wire bclk_falling;

wire start_playing;
wire stop_playing;

wire sound_input_xckd;

wire[7:0] sine_sample_data;
wire[7:0] quack_sample_data;

cdc_synchronizer input_cdc_synchronizer1(
    .in       (sound_input),
    .out      (sound_input_xckd),
    .clk      (xck_clock),
    .rst_n    (rst_n)
);

edge_detector channel_edge_inst(
	.in         (lrck_clock),
	.rising     (next_sample),
	.falling    (replay_sample),
	.clk        (xck_clock),
	.rst_n      (rst_n)
);

edge_detector bclk_edge_inst(
	.in         (bclk_clock),
	.falling    (bclk_falling),
	.clk        (xck_clock),
	.rst_n      (rst_n)
);

edge_detector input_edge_inst(
	.in         (sound_input_xckd),
	.rising     (start_playing),
	.falling    (stop_playing),
	.clk        (xck_clock),
	.rst_n      (rst_n)
);

//ROMs
sync_rom #(
    .BusWidth              (10),
    .DataWidth             (8),
    .InitializationFile    ("../samples/sine.hex")
) sine_sync_rom(
    .read_address          (current_sample),
    .data_out              (sine_sample_data),
    .clk                   (xck_clock)
);

sync_rom #(
    .BusWidth              (10),
    .DataWidth             (8),
    .InitializationFile    ("../samples/quack.hex")
) quack_sync_rom(
    .read_address          (current_sample),
    .data_out              (quack_sample_data),
    .clk                   (xck_clock)
);

wire [7:0] sample_data = sound_sample_select ? quack_sample_data : sine_sample_data;
assign aud_dacdat = (current_bit < ROM_SAMPLE_WIDTH && sound_enable && sound_playing) ? sample_data[4'd7 - current_bit] : 1'b0;

always @(posedge xck_clock, negedge rst_n) begin
	if(!rst_n)
	begin
		current_bit <= 4'b0;
		current_sample <= 10'b0;
		sound_playing <= 1'b0;
	end
	else
	begin
		if(next_sample)
		begin
			current_bit <= 4'b0;
			current_sample <= current_sample + 10'b1;
		end
		
		if(replay_sample)
		begin 
			current_bit <= 4'b0;
		end
		
		if(bclk_falling)
		begin
			if(current_bit < ROM_SAMPLE_WIDTH)
			begin
				current_bit <= current_bit + 4'b1;
			end
		end
		
		if(start_playing)
		begin
			current_sample <= 10'b0;
			sound_playing <= 1'b1;
		end
		if(stop_playing)
		begin
			sound_playing <= 1'b0;
		end
	end
end

endmodule