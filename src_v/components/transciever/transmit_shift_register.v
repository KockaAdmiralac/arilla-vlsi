module transmit_shift_register
(
	input  [2:0] paralel_data,
	input  shift,
	output serial_data,
	output request,
	
	input  clk,
	input  rst_n
);

reg [2:0] data_reg;

assign serial_data = data_reg[0];

assign request = data_reg[2:1] == 2'b00 && shift;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		data_reg <= 3'b000;
	end
	else
	begin
		if(shift)
		begin
			if(request)
			begin
				data_reg <= paralel_data;
			end
			else
			begin
				data_reg <= {1'b0,data_reg[2:1]};
			end
		end
	end
end

endmodule