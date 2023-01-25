module CodecControl 
(
	input 		rst_n,
	input			clk,
	// I2C
	inout			I2C_SDAT,				//	I2C Data
	output		I2C_SCLK,				//	I2C Clock
	// Control
	output reg	complete
);

// Constants
localparam clock_frequency = 50_000_000;
localparam i2c_frequency = 20_000;
localparam i2c_divider = clock_frequency / i2c_frequency;

// I2C clock divider
integer i2c_clock_count;
reg	i2c_clock;

always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		i2c_clock_count <= 0;
		i2c_clock <= 0;
	end else begin
		if (i2c_clock_count < i2c_divider ) begin
			i2c_clock_count <= i2c_clock_count + 1;
		end else begin
			i2c_clock_count <= 0;
			i2c_clock <= ~i2c_clock;
		end
	end
end

// I2C register configuration
reg [15:0] register_data;
reg [3:0] register_index;

always
begin
	case (register_index)
		// DATA: address_value
		0 : register_data <= {{7'b0000000}, {9'h000}};			// all zero
		1 : register_data <= {{7'b0001111}, {9'h000}};			// reset
		2 : register_data <= {{7'b0000010}, {9'h07b}};			// left headphone out
		3 : register_data <= {{7'b0000011}, {9'h07b}};			// right headphone out
		4 : register_data <= {{7'b0000100}, {9'h078}};			// analog audio path control
		5 : register_data <= {{7'b0000101}, {9'h006}};			// digital audio path control
		6 : register_data <= {{7'b0000110}, {9'h000}};			// power down control
		7 : register_data <= {{7'b0000111}, {9'h001}};			// digital audio interface format
		8 : register_data <= {{7'b0001000}, {9'h006}};			// sampling control
		9 : register_data <= {{7'b0001001}, {9'h001}};			// active control
		default : register_data <= {{7'b0000000}, {9'h000}};			// all zero
	endcase
end

// I2C controller
reg [23:0] i2c_data;
reg transfer_start;
wire transfer_ack_n;
wire transfer_complete;

I2CController 	u0	(	.CLOCK(i2c_clock),		//	Controller Work Clock
						.I2C_SCLK(I2C_SCLK),		//	I2C CLOCK
 	 	 	 	 	 	.I2C_SDAT(I2C_SDAT),		//	I2C DATA
						.I2C_DATA(i2c_data),		//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
						.GO(transfer_start),      			//	GO transfor
						.END(transfer_complete),				//	END transfor 
						.ACK(transfer_ack_n),				//	ACK
						.RESET(rst_n)	);

						
reg [1:0] transfer_state;
localparam STARTED = 2'b00;
localparam WAIT_ACK = 2'b01;
localparam INCREMENT = 2'b10;

localparam CODEC_ADDRESS = 8'h34;
						
always @(posedge i2c_clock, negedge rst_n) begin
	if (!rst_n) begin
		register_index <= 4'b0;
		transfer_state <= 2'b0;
		transfer_start <= 1'b0;
		complete <= 1'b0;
	end else begin
		if (register_index < 10) begin
			complete <= 1'b0;
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
					if (transfer_complete) begin
						if (!transfer_ack_n) begin
							transfer_state <= INCREMENT;
						end else begin
							transfer_state <= STARTED;
							transfer_start <= 1'b0;
						end
					end
				end

			endcase
		end else begin
			complete <= 1'b1;
		end
	end
end
endmodule