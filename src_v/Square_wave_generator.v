module square_wave_generator
#(
	parameter HighFrequency = 32'd49999,
	parameter LowFrequency = 32'd99999
)
(
	input  in,
	input  enable,
	input  frequency_select,
	output out,

	input  clk,
	input  rst_n
);

reg delay_reg;
reg [31:0] cnt;

wire generate_output;
wire delay_next;
wire [31:0] frequency;
wire [31:0] threshold;

assign out = delay_reg;
assign generate_output = in && enable;
assign delay_next = cnt > threshold && generate_output;

assign frequency = frequency_select ? LowFrequency : HighFrequency;
assign threshold = {1'b0,frequency[31:1]};

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		cnt <= HighFrequency;
		delay_reg <= 1'b0;
	end
	else
	begin
		if(!generate_output || cnt == 32'd0)
		begin
			cnt <= frequency;
		end
		else
		begin
			cnt <= cnt - 32'd1;
		end
		delay_reg <= delay_next;
	end
	
end

endmodule