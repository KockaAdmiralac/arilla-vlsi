module receive_shift_register
(
	input  serial_data,
	input  sample,
	output dot,
	output dash,
	output character_break,
	output space,
	output etx,
	output [7:0] receive_history,

	input  clk,
	input  rst_n
);

localparam DOT_PATTERN             =   3'b010;
localparam DASH_PATTERN            =  4'b0110;
localparam CHARACTER_BREAK_PATTERN =  4'b1001;
localparam SPACE_PATTERN           = 5'b10001;
localparam EXT_PATTERN             = 5'b10000;

reg [7:0] receive_register;

assign receive_history = receive_register;

assign dot             = receive_register[2:0] == DOT_PATTERN             && sample;
assign dash            = receive_register[3:0] == DASH_PATTERN            && sample;
assign character_break = receive_register[3:0] == CHARACTER_BREAK_PATTERN && sample;
assign space           = receive_register[4:0] == SPACE_PATTERN           && sample;
assign etx             = receive_register[4:0] == EXT_PATTERN             && sample;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		receive_register <= 8'd0;
	end
	else
	begin
		if(sample)
		begin
			receive_register <= {receive_register[6:0],serial_data};
		end
	end
end

endmodule