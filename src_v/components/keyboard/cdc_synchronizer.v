module cdc_synchronizer
(
	input  in,
	output out,
	
	input  clk,
	input  rst_n
);

reg reg_a;
reg reg_b;

assign out = reg_b;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		reg_a <= 1'b0;
		reg_b <= 1'b0;
	end
	else
	begin
		reg_a <= in;
		reg_b <= reg_a;
	end
end

endmodule