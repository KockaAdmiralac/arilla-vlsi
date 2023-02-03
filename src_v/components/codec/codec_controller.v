module codec_controller 
(
	inout  i2c_sdat,
	output i2c_sclk,
	output complete,

	input  clk,
	input  rst_n
);

localparam STARTED   = 2'b00;
localparam WAIT_ACK  = 2'b01;
localparam INCREMENT = 2'b10;

localparam CODEC_ADDRESS = 8'h34;

reg [1:0] transfer_state;

//I2C register configuration
reg [15:0] register_data;
reg  [3:0] register_index;

//I2C controller
reg transfer_start;
reg [23:0] i2c_data;

wire transfer_end;
wire transfer_ack_n;

assign complete = register_index == 4'd10;

i2c_controller i2c_inst(
	.transfer_start    (transfer_start),
	.transfer_data     (i2c_data),
	.transfer_end      (transfer_end),
	.transfer_ack_n    (transfer_ack_n),
	.i2c_sdata         (i2c_sdat),
	.i2c_clk           (i2c_sclk),
	.clk               (clk),
	.rst_n             (rst_n)
);
											
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
	begin
		register_index <= 4'b0;
		transfer_state <= 2'b0;
		transfer_start <= 1'b0;
	end 
	else
	begin
		if(register_index < 4'd10) 
		begin
			case (transfer_state)
				STARTED : 
				begin
					i2c_data <= {CODEC_ADDRESS, register_data};
					transfer_start <= 1'b1;
					transfer_state <= WAIT_ACK;
				end
				INCREMENT:
				begin
					register_index <= register_index + 4'b1;
					transfer_state <= STARTED;
				end
				WAIT_ACK:
				begin
					if(transfer_end) 
					begin
						transfer_start <= 1'b0;
						transfer_state <= transfer_ack_n ? STARTED : INCREMENT;
					end
				end
			endcase
		end
	end
end

always @(*) begin
	case (register_index)
		//DATA: address_value
		0 : register_data <= {{7'b0000000}, {9'h000}};			//all zero
		1 : register_data <= {{7'b0001111}, {9'h000}};			//reset
		2 : register_data <= {{7'b0000010}, {9'h07b}};			//left headphone out
		3 : register_data <= {{7'b0000011}, {9'h07b}};			//right headphone out
		4 : register_data <= {{7'b0000100}, {9'h078}};			//analog audio path control
		5 : register_data <= {{7'b0000101}, {9'h006}};			//digital audio path control
		6 : register_data <= {{7'b0000110}, {9'h000}};			//power down control
		7 : register_data <= {{7'b0000111}, {9'h001}};			//digital audio interface format
		8 : register_data <= {{7'b0001000}, {9'h006}};			//sampling control
		9 : register_data <= {{7'b0001001}, {9'h001}};			//active control
		default : register_data <= {{7'b0000000}, {9'h000}};	//all zero
	endcase
end

endmodule