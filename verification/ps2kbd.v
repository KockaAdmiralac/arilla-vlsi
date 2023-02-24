module ps2kbd
(
	input clk,
	input rst_n,
	input ps2clk,
	input ps2dat,
	output [31:0]out
);

reg [31:0] out_reg;
reg [31:0] out_next;

reg [10:0] int_reg;
reg [10:0] int_next;

reg last_reg;
reg last_next;

assign out = out_reg;

always@(posedge clk, negedge rst_n)
begin
	if(!rst_n)
	begin
		out_reg <= 32'd0;
		int_reg <= 11'h7FF;
		last_reg <= 1'b0;
	end
	else
	begin
		out_reg <= out_next;
		int_reg <= int_next;
		last_reg <=last_next;
	end
end

always@(*)
begin
	last_next <= ps2clk;
	out_next <= out_reg;
	if(!ps2clk && last_reg)
	begin
		int_next <= {ps2dat,int_reg[10:1]};
	end
	else
	begin
		int_next <= int_reg;
	end
	if(!int_reg[0])
	begin
		if(out_reg[7:0]==8'hF0 || out_reg[7:0]==8'hE0)
		begin
			out_next <= {out_reg[23:0],{int_reg[8:1]}};
		end
		else
		begin
			out_next <= {24'd0,{int_reg[8:1]}};
		end		
		int_next <= 11'h7FF;
	end
end

endmodule