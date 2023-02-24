module char_decoder
(
	input  [7:0] paralel_data,
	input  incoming_request,
	output [2:0] serial_data,
	output outgoing_request,
	
	input  clk,
	input  rst_n
);

localparam SPACE_CODE = 3'd6;
localparam ETX_CODE = 3'd7;

localparam SPACE_COUNT = 3'd7;
localparam ETX_COUNT = 3'd0;

localparam DOT_OUTPUT = 3'b010;
localparam DASH_OUTPUT = 3'b110;
localparam MASK_OUTPUT = 3'b000;

reg [2:0] cnt;
reg [4:0] data;
reg mask;

wire [2:0] paralel_count = paralel_data[7:5];
wire [4:0] paralel_code = paralel_data[4:0];

assign serial_data = (cnt == 3'd7 || mask) ? MASK_OUTPUT : (data[cnt]) ? DASH_OUTPUT : DOT_OUTPUT;
assign outgoing_request = cnt == 3'd7 && incoming_request;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		cnt <= 3'd7;
		data <= 5'd0;
		mask <= 1'b0;
	end
	else
	begin
		if(incoming_request)
		begin
			if(outgoing_request)
			begin
				if(paralel_count == SPACE_CODE)
				begin
					cnt <= SPACE_COUNT;
					mask <= 1'b1;
				end
				else if(paralel_count == ETX_CODE)
				begin
					cnt <= ETX_COUNT;
					mask <= 1'b1;
				end
				else
				begin
					cnt <= paralel_count - 3'd1;
					mask <= 1'b0;
				end
				data <= paralel_code;
			end
			else
			begin
				cnt <= cnt - 3'd1;
			end
		end
	end
end

endmodule