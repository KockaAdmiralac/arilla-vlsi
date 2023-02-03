module sampling_timer
(
	input  start,
	input  [31:0] bit_time,
	output sample,
	
	input  clk,
	input  rst_n
);

reg [31:0] cnt;

wire [31:0] reload = bit_time - 32'd1;
wire [31:0] preload = {1'b0,reload[31:1]};

assign sample = cnt == 32'd0;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		cnt <= 32'd0;
	end
	else
	begin
		if(start)
		begin
			cnt <= preload;
		end
		else if(cnt == 32'd0)
		begin
			cnt <= reload;
		end
		else
		begin
			cnt <= cnt - 32'd1;
		end
	end
end

endmodule