module fifo
#(
	parameter BusWidth = 7,
	parameter DataWidth = 8
)
(
	input  read,
	input  write,
	input  [DataWidth-1:0] data_in,
	output [DataWidth-1:0] data_out,
	output full,
	output has_data,
	
	input  clk,
	input  rst_n
);

reg [BusWidth-1:0] read_pointer;
reg [BusWidth-1:0] write_pointer;
reg   [BusWidth:0] count;

assign full = count == (2**BusWidth);
assign has_data = count != {BusWidth{1'b0}};

ram_2port #(
    .BusWidth         (BusWidth),
    .DataWidth        (DataWidth)
) u_ram_2port (
    .read_address     (read_pointer),
    .write_address    (write_pointer),
    .write            (write),
    .data_in          (data_in),
    .data_out         (data_out),
    .clk              (clk)
);

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		read_pointer <= {BusWidth{1'b0}};
		write_pointer <= {BusWidth{1'b0}};
		count <= {BusWidth+1{1'b0}};
	end
	else 
	begin
		if(read && write)
		begin
			read_pointer <= read_pointer + {{BusWidth-2{1'b0}},1'b1};
			write_pointer <= write_pointer + {{BusWidth-2{1'b0}},1'b1};
		end
		else if(read)
		begin
			read_pointer <= read_pointer + {{BusWidth-2{1'b0}},1'b1};
			count <= count - {{BusWidth-1{1'b0}},1'b1};
		end
		else if(write)
		begin
			write_pointer <= write_pointer + {{BusWidth-2{1'b0}},1'b1};
			count <= count + {{BusWidth-1{1'b0}},1'b1};
		end
	end
end

endmodule