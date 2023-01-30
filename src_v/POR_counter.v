module por_counter
#(
	parameter PorValue = 32'd5050
)
(
	output rst_p,
	output rst_n,
	
	input  clk,
	input  rst
);

reg [31:0] val;

assign rst_p = val != 32'd0;
assign rst_n = val == 32'd0;

always @(posedge clk) begin
	if(rst)
	begin
		val <= PorValue;
	end
	else if(val != 32'd0)
	begin
		val <= val - 32'd1;
	end
end

endmodule