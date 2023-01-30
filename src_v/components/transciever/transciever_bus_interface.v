module transciever_bus_interface
(
	inout  [31:0] data_wire,
	input  [31:0] address_wire,
	input  read,
	input  write_wire,
	
	input  [7:0] receive_fifo_data,
	output [7:0] transmit_fifo_data,
	
	output [31:0] bit_time,

	output line_loop,
	output line_invert,
	output sound_enable,
	output sound_sample_select,
	input  transmission_in_progress,
	output start_transmission,
	output receive_enable,
	input  transmit_fifo_full,
	input  transmit_fifo_has_data,
	input  receive_fifo_full,
	input  receive_fifo_has_data,
	output receive_fifo_read,
	output transmit_fifo_write,

	input  clk,
	input  rst_n
);

localparam CONTROL_STATUS_REGISTER_ADDRESS 	= 32'h40000000;
localparam BIT_TIME_REGISTER_ADDRESS 		= 32'h40000004;
localparam DATA_REGISTER_ADDRESS 			= 32'h40000008;

reg [31:0] data;
reg [31:0] address;
reg write;

reg [31:0] bit_time_register;
reg  [4:0] control_status_register;

wire [31:0] output_data[2:0];

assign output_data[0] = {
	21'd0,
	line_loop,
	line_invert,
	sound_sample_select,
	sound_enable,
	transmission_in_progress,
	1'b0,
	receive_enable,
	transmit_fifo_full,
	transmit_fifo_has_data,
	receive_fifo_full,
	receive_fifo_has_data
};
assign output_data[1] = bit_time_register;
assign output_data[2] = {24'd0,receive_fifo_data};

assign transmit_fifo_data = data[7:0];
assign bit_time = bit_time_register;

assign line_loop 			= control_status_register[4];
assign line_invert 			= control_status_register[3];
assign sound_sample_select 	= control_status_register[2];
assign sound_enable 		= control_status_register[1];
assign receive_enable 		= control_status_register[0];

assign start_transmission  = address == CONTROL_STATUS_REGISTER_ADDRESS && write && data[5];
assign receive_fifo_read   = address == CONTROL_STATUS_REGISTER_ADDRESS && write && data[11];
assign transmit_fifo_write = address == DATA_REGISTER_ADDRESS           && write;

assign data_wire = address_function(address, read);

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		data <= 32'd0;
		address <= 32'd0;
		write <= 1'b0;
		bit_time_register <= 32'd20;
		control_status_register <= 5'b00000;
	end
	else
	begin
		if(write)
		begin
			case(address)
				CONTROL_STATUS_REGISTER_ADDRESS: begin
					control_status_register <= {data[10:7],data[4]};
				end
				BIT_TIME_REGISTER_ADDRESS: begin
					bit_time_register <= data;
				end
			endcase
		end
		data <= data_wire;
		address <= address_wire;
		write <= write_wire;
	end
end

function [31:0] address_function(input [31:0] address, input read);
	if(read)
	begin
		case(address)
			CONTROL_STATUS_REGISTER_ADDRESS	: address_function = output_data[0];
			BIT_TIME_REGISTER_ADDRESS		: address_function = output_data[1];
			DATA_REGISTER_ADDRESS			: address_function = output_data[2];
			default     					: address_function = {32{1'bz}};
		endcase
	end
	else
	begin
		address_function = {32{1'bz}};
	end
endfunction

endmodule