module Single_hex_interface
(
	input [3:0] in,
	output reg [7:0] out
);
	always @(*)
	begin
		case (in)
			4'b0000: out = ~8'h3F;
			4'b0001: out = ~8'h06;
			4'b0010: out = ~8'h5B;
			4'b0011: out = ~8'h4F;
			4'b0100: out = ~8'h66;
			4'b0101: out = ~8'h6D;
			4'b0110: out = ~8'h7D;
			4'b0111: out = ~8'h07;
			4'b1000: out = ~8'h7F;
			4'b1001: out = ~8'h6F;
			4'b1010: out = ~8'h77;
			4'b1011: out = ~8'h7C;
			4'b1100: out = ~8'h39;
			4'b1101: out = ~8'h5E;
			4'b1110: out = ~8'h79;
			4'b1111: out = ~8'h71;
		endcase
	end
endmodule