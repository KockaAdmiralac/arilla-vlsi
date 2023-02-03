module keyboard_controller 
(
    input  keyboard_clk,
    input  keyboard_data,
   
    output [23:0] key_code,
    output parity_error,
    output frame_error,

	input  clk,
    input  rst_n
);

reg [23:0] out_reg;
reg [23:0] out_next;

reg [15:0] byte_shift_reg; 
reg [15:0] byte_shift_next; 

reg [10:0] bit_shift_reg;
reg [10:0] bit_shift_next;

reg parrity_reg, parrity_next;
reg frame_reg, frame_next;

reg eda_reg, edb_reg;

wire falling;
wire [7:0] byte_data;
wire parity;
wire frame;

assign key_code = out_reg;
assign parity_error = parrity_reg;
assign frame_error = frame_reg;
assign falling = !eda_reg && edb_reg;

assign byte_data = bit_shift_reg[8:1];
assign parity = ^bit_shift_reg[9:1];
assign frame = bit_shift_reg[10];


always@(posedge clk, negedge rst_n)
begin
	if(!rst_n)
	begin
		out_reg <= 24'd0;
		byte_shift_reg <= 16'd0;
		bit_shift_reg <= 11'h7FF;

		eda_reg <= 1'b0;
		edb_reg <= 1'b0;

		parrity_reg <= 1'd0;
		frame_reg <= 1'd0;
	end
	else
	begin
		out_reg <= out_next;
		byte_shift_reg <= byte_shift_next;
		bit_shift_reg <= bit_shift_next;

		eda_reg <= keyboard_clk;
		edb_reg <= eda_reg;

		parrity_reg <= parrity_next;
		frame_reg <= frame_next;
	end
end

always@(*)
begin
	out_next <= out_reg;
	byte_shift_next <= byte_shift_reg;
	bit_shift_next <= bit_shift_reg;
	parrity_next <= parrity_reg;
	frame_next <= frame_reg;

	if(falling)
	begin
		bit_shift_next <= {keyboard_data,bit_shift_reg[10:1]};
	end

	if(!bit_shift_reg[0])
	begin
		if(!parity)
		begin
			parrity_next <= 1'd1;
		end
		else if(!frame)
		begin
			frame_next <= 1'd1;
		end
		else if(byte_data != 8'hF0 && byte_data != 8'hE0)
		begin
			if(parrity_reg || frame_reg)
			begin
				parrity_next <= 1'd0;
				frame_next <= 1'd0;
			end
			else
			begin
				out_next <= {byte_shift_reg,byte_data};
			end
			byte_shift_next <= 16'd0;
		end
		else
		begin
			byte_shift_next <= {byte_shift_reg[7:0],byte_data};
		end
		bit_shift_next <= 11'h7FF;
	end
end

endmodule