module synch
(
	input clk,
	input rst_n,
	input in,
	output out
);

reg out_regA, out_regB;
reg out_nextA, out_nextB;

assign out = out_regA;

always @(posedge clk, negedge rst_n)
begin
	if(!rst_n)
	begin
		out_regA = 0;
		out_regB = 0; 
	end
	else 
	begin
		out_regA = out_nextA;
		out_regB = out_nextB;
	end
end

always @(*)
begin
	out_nextB=out_regA;
	out_nextA=in;
	
end

endmodule