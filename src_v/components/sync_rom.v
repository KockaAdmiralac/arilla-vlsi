module sync_rom
#(
	parameter BusWidth = 10,
	parameter DataWidth = 8,
	parameter InitializationFile = "rom.hex"
)
(
	input      [BusWidth-1:0] read_address,
	output reg [DataWidth-1:0] data_out,

	input  clk
);

reg [DataWidth-1:0] rom [(2**BusWidth)-1:0] /* synthesis romstyle = "logic" */;

initial
begin
	$readmemh(InitializationFile, rom);
end

always @(posedge clk) begin
	data_out <= rom[read_address];
end

endmodule