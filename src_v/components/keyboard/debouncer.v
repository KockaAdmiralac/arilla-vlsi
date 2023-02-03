module debouncer
(
	input  in,
	input  [31:0] reload,
	output out,

	input  clk,
	input  rst_n
);

reg reg_a;
reg reg_b;
reg reg_out;

reg [31:0] cnt;

wire change;

assign out = reg_out;
assign change = reg_a ^ reg_b;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		reg_a <= 1'b0;
		reg_b <= 1'b0;
		reg_out <= 1'b0;
		cnt <= 32'd0;
	end
	else
	begin
		if(change)
		begin
			cnt <= reload;
		end
		else if(cnt != 32'd0) 
		begin
			cnt <= cnt - 32'd1;
		end

		if(cnt == 32'd0)
		begin
			reg_out <= reg_b;
		end

		reg_a <= in;
		reg_b <= reg_a;
	end
end

endmodule