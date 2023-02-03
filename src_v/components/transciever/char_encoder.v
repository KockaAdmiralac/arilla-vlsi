module char_encoder
(
	input  dot,
	input  dash,
	input  character_break,
	input  space,
	input  etx,
	output [7:0] character_data,
	output outgoing_request,

	input  clk,
	input  rst_n
);

localparam SPACE_DATA = 8'b110_00000;
localparam ETX_DATA   = 8'b111_00000;

localparam DOT_DATA  = 1'b0;
localparam DASH_DATA = 1'b1;

reg [2:0] cnt;
reg [4:0] data;

reg hold_space;
reg hold_etx;

assign character_data = hold_space ? SPACE_DATA : hold_etx ? ETX_DATA : {cnt,data};

assign outgoing_request = character_break || space || etx || hold_space || hold_etx;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		cnt <= 3'd0;
		data <= 5'd0;
		hold_space <= 1'b0;
		hold_etx <= 1'b0;
	end
	else
	begin
		hold_space <= 1'b0;
		hold_etx <= 1'b0;

		if(space)
		begin
			hold_space <= 1'b1;
		end
		if(etx)
		begin
			hold_etx <= 1'b1;
		end

		if(outgoing_request)
		begin
			cnt <= 3'd0;
			data <= 5'd0;
		end
		else if(dot)
		begin
			cnt <= cnt + 3'd1;
			data <= {data[3:0],DOT_DATA};
		end
		else if(dash)
		begin
			cnt <= cnt + 3'd1;
			data <= {data[3:0],DASH_DATA};
		end
	end
end

endmodule