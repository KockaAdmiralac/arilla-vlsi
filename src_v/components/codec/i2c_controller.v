module i2c_controller
(
	input  transfer_start,
	input  [23:0] transfer_data,
	output transfer_end,
	output transfer_ack_n,

	inout  i2c_sdata,
	output i2c_clk,

	input  clk,
	input  rst_n
);

//Constants
localparam CLOCK_FREQUENCY = 32'd50_000_000;
localparam I2C_FREQUENCY   = 32'd20_000;
localparam I2C_DIVIDER = CLOCK_FREQUENCY / I2C_FREQUENCY;

//I2C clock divider
reg [32:0] i2c_clock_count;
reg	i2c_clock;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
	begin
		i2c_clock_count <= 32'd0;
		i2c_clock <= 1'b0;
	end 
	else 
	begin
		if(i2c_clock_count < I2C_DIVIDER)
		begin
			i2c_clock_count <= i2c_clock_count + 32'd1;
		end 
		else 
		begin
			i2c_clock_count <= 32'd0;
			i2c_clock <= ~i2c_clock;
		end
	end
end

//Sending frames

//I2C clock rising edge detector
wire i2c_clock_falling;

edge_detector edge_inst(
	.in         (i2c_clock),
	.falling    (i2c_clock_falling),
	.clk        (clk),
	.rst_n      (rst_n)
);

reg hold_clock_reg, hold_clock_next;
reg out_reg, out_next;
reg ack_reg, ack_next;
reg [23:0] data_reg, data_next;
reg  [5:0] step_reg, step_next;

assign transfer_ack_n = ack_reg;
assign transfer_end = (step_reg == 6'd32);

//Pullup on sdata
assign i2c_sdata = out_reg ? 1'bz : 1'b0;
assign i2c_clk = hold_clock_reg | ((step_reg >= 6'd4 && step_reg <= 6'd30) ? i2c_clock : 1'b0);

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
	begin
		hold_clock_reg <= 1'b1;
		out_reg <= 1'b0;
		ack_reg <= 1'b0;
		step_reg <= 6'b111111;
		data_reg <= 24'b0;
	end 
	else 
	begin
		hold_clock_reg <= hold_clock_next;
		out_reg <= out_next;
		ack_reg <= ack_next;
		step_reg <= step_next;
		data_reg <= data_next;
	end
end

//Combinational logic
always @(*) begin
	hold_clock_next = hold_clock_reg;
	out_next = out_reg;
	ack_next = ack_reg;
	step_next = step_reg;
	data_next = data_reg;

	if(transfer_start) 
	begin
		if(i2c_clock_falling) 
		begin
			case(step_reg)
				6'd0: //RESET
				begin
					ack_next = 1'b0;
					out_next = 1'b1;
					hold_clock_next = 1'b1;
				end
				6'd1: //Start bit
				begin
					data_next = transfer_data; //Load 24 bit data buffer
					out_next = 1'b0; //creates falling edge
				end
				//SLAVE ADDRESS
				6'd2:  hold_clock_next = 1'b0;
				6'd3:  out_next = data_reg[23];
				6'd4:  out_next = data_reg[22];
				6'd5:  out_next = data_reg[21];
				6'd6:  out_next = data_reg[20];
				6'd7:  out_next = data_reg[19];
				6'd8:  out_next = data_reg[18];
				6'd9:  out_next = data_reg[17];
				6'd10: out_next = data_reg[16];
				6'd11: out_next = 1'b1; //HiZ to read ACK
				//REGISTER ADDRESS
				6'd12: //sample ACK
				begin
					ack_next = ack_reg | i2c_sdata;
					out_next = data_reg[15];
				end
				6'd13: out_next = data_reg[14];
				6'd14: out_next = data_reg[13];
				6'd15: out_next = data_reg[12];
				6'd16: out_next = data_reg[11];
				6'd17: out_next = data_reg[10];
				6'd18: out_next = data_reg[9];
				6'd19: out_next = data_reg[8];
				6'd20: out_next = 1'b1; //HiZ to read ACK
				//DATA
				6'd21: //sample ACK
				begin
					ack_next = ack_reg | i2c_sdata;
					out_next = data_reg[7];
				end
				6'd22: out_next = data_reg[6];
				6'd23: out_next = data_reg[5];
				6'd24: out_next = data_reg[4];
				6'd25: out_next = data_reg[3];
				6'd26: out_next = data_reg[2];
				6'd27: out_next = data_reg[1];
				6'd28: out_next = data_reg[0];
				6'd29: out_next = 1'b1; //HiZ to read ACK
				
				6'd30: //Stop bit
				begin
					ack_next = ack_reg | i2c_sdata;
					hold_clock_next = 1'b0;
					out_next = 1'b0;
				end
				6'd31: out_next = 1'b1; //creates rising edge
				6'd32: out_next = 1'b1;
				default: ;
			endcase
			if(step_reg < 6'd32)
			begin
				step_next = step_reg + 6'b1;
			end
		end
	end
	else
	begin
		step_next = 6'd0;
	end
end
endmodule