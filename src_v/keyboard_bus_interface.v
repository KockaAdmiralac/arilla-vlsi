module keyboard_bus_interface
(
	inout  [31:0] data_wire,
	input  [31:0] address_wire,
	input  read,
	input  write_wire,

	output [4:0] debounce_time,
	output synchronizer_enable,
	input  frame_error,
	input  parity_error,
	input  [23:0] key_code,
	
	input  clk,
	input  rst_n
);

localparam DEVICE_REGISTER_ADDRESS 	= 32'h30000000;

reg [31:0] data;
reg [31:0] address;
reg write;

wire hit;

reg [5:0] device_register;

wire [31:0] output_data;

assign output_data = {
	debounce_time,
	synchronizer_enable,
	frame_error,
	parity_error,
	key_code
};

assign debounce_time = device_register[5:1];
assign synchronizer_enable = device_register[0];

assign hit = address == DEVICE_REGISTER_ADDRESS;

assign data_wire = (hit && read) ? output_data : {32{1'bz}};

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		data <= 32'd0;
		address <= 32'd0;
		write <= 1'b0;
		device_register <= 6'b000000;
	end
	else
	begin
		if(write && hit)
		begin
			device_register <= data[31:26];
		end
		data <= data_wire;
		address <= address_wire;
		write <= write_wire;
	end
end

endmodule