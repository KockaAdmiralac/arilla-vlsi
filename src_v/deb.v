module deb
(
	input clk,
	input rst_n,
	input in,
	output out
);

parameter debTicks = 32'd10;

reg out_regA, out_regB, out_regC;
reg out_nextA, out_nextB, out_nextC;

integer timeleft_reg;
integer timeleft_next;

assign out = out_regC;

always@(posedge clk, negedge rst_n)
begin
	if(!rst_n)
	begin
		out_regA <= 0;
		out_regB <= 0;
		out_regC <= 0;
		timeleft_reg <= debTicks;
	end
	else
	begin
		out_regA <= out_nextA;
		out_regB <= out_nextB;
		out_regC <= out_nextC;
		timeleft_reg <= timeleft_next;
	end
end

always@(*)
begin
	out_nextA <= in;
	out_nextB <= out_regA;
	
	if(out_regA == out_regB)
	begin
		if(timeleft_reg > 0)
		begin
			timeleft_next <= timeleft_reg - 1;
		end
		else
		begin
			timeleft_next <= timeleft_reg;
		end
	end
	else
	begin
		timeleft_next <= debTicks;
	end
	
	if(timeleft_reg == 0)
	begin
		out_nextC <= out_regB;
	end
	else
	begin
		out_nextC <= out_regC;
	end
end

endmodule