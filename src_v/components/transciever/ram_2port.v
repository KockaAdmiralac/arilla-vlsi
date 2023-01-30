module ram_2port
#(
	parameter BusWidth = 7,
	parameter DataWidth = 8
)
(
	input      [BusWidth-1:0] read_address,
	input      [BusWidth-1:0] write_address,
	input      write,
	input      [DataWidth-1:0] data_in,
	output reg [DataWidth-1:0] data_out,
	
	input      clk
);

reg [DataWidth-1:0] memory [(2**BusWidth)-1:0] /* synthesis ramstyle = "M9K" */;

always @(posedge clk) begin
	if(write) 
	begin
		memory[write_address] <= data_in;
	end
	data_out <= memory[read_address];
end

endmodule