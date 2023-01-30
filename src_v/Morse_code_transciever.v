module morse_code_transciever
(
	inout  [31:0] data,
	input  [31:0] address,
	input  read,
	input  write,

	input  in,
	output out,
	
	output line_invert,
	output line_loop,
	output sound_enable,
	output sound_sample_select,
	output [7:0] receive_history,

	input  clk,
	input  rst_n
);

localparam ETX_ASCII = 8'h03;

reg transmit_reg, transmit_next;
reg receive_reg, receive_next;

wire [31:0] bit_time;
wire  [2:0] current_sign;
wire  [7:0] current_character;
wire  [7:0] current_ascii;
wire  [7:0] character_data;
wire  [7:0] character_ascii;
wire  [7:0] transmit_fifo_data_in;
wire  [7:0] transmit_fifo_data_out;
wire  [7:0] receive_fifo_data_in;
wire  [7:0] receive_fifo_data_out;

wire receive_enable;
wire sound_enable_bus;
wire start_transmission;
wire message_start;
wire shift;
wire sample;
wire next_sign;
wire next_character;
wire write_character;

wire dot;
wire dash;
wire character_break;
wire space;
wire etx;

wire transmit_fifo_read;
wire transmit_fifo_write;
wire transmit_fifo_full;
wire transmit_fifo_has_data;

wire receive_fifo_read;
wire receive_fifo_write;
wire receive_fifo_full;
wire receive_fifo_has_data;

assign sound_enable = sound_enable_bus && bit_time >= 32'd50_000;

assign current_ascii = (transmit_reg && transmit_fifo_has_data) ? transmit_fifo_data_out : 8'd0;
assign transmit_fifo_read = next_character && transmit_reg && transmit_fifo_has_data;

assign receive_fifo_data_in = character_ascii;
assign receive_fifo_write = write_character && receive_reg && !receive_fifo_full;

edge_detector message_start_detector(
	.in         (in),
	.rising     (message_start),
	.clk        (clk),
	.rst_n      (rst_n)
);

sampling_timer transmit_timer(
	.start       (1'b0),
	.bit_time    (bit_time),
	.sample      (shift),
	.clk         (clk),
	.rst_n       (rst_n)
);

sampling_timer receive_timer(
	.start       (message_start),
	.bit_time    (bit_time),
	.sample      (sample),
	.clk         (clk),
	.rst_n       (rst_n)
);

transmit_shift_register transmit_shift_register(
	.paralel_data    (current_sign),
	.shift           (shift),
	.serial_data     (out),
	.request         (next_sign),
	.clk             (clk),
	.rst_n           (rst_n)
);

receive_shift_register receive_shift_register(
	.serial_data        (in),
	.sample             (sample),
	.dot                (dot),
	.dash               (dash),
	.character_break    (character_break),
	.space              (space),
	.etx                (etx),
	.receive_history    (receive_history),
	.clk                (clk),
	.rst_n              (rst_n)
);

char_decoder char_decoder(
	.paralel_data        (current_character),
	.incoming_request    (next_sign),
	.serial_data         (current_sign),
	.outgoing_request    (next_character),
	.clk                 (clk),
	.rst_n               (rst_n)
);

char_encoder char_encoder(
	.dot                 (dot),
	.dash                (dash),
	.character_break     (character_break),
	.space               (space),
	.etx                 (etx),
	.character_data      (character_data),
	.outgoing_request    (write_character),
	.clk                 (clk),
	.rst_n               (rst_n)
);

morse_code_transmit_rom morse_code_transmit_rom(
	.in     (current_ascii),
	.out    (current_character)
);

morse_code_receive_rom morse_code_receive_rom(
	.in     (character_data),
	.out    (character_ascii)
);

fifo #(
	.BusWidth     (7),
	.DataWidth    (8)
) transmit_fifo(
	.read         (transmit_fifo_read),
	.write        (transmit_fifo_write),
	.data_in      (transmit_fifo_data_in),
	.data_out     (transmit_fifo_data_out),
	.full         (transmit_fifo_full),
	.has_data     (transmit_fifo_has_data),
	.clk          (clk),
	.rst_n        (rst_n)
);

fifo #(
	.BusWidth     (7),
	.DataWidth    (8)
) receive_fifo(
	.read         (receive_fifo_read),
	.write        (receive_fifo_write),
	.data_in      (receive_fifo_data_in),
	.data_out     (receive_fifo_data_out),
	.full         (receive_fifo_full),
	.has_data     (receive_fifo_has_data),
	.clk          (clk),
	.rst_n        (rst_n)
);

transciever_bus_interface transciever_bus_interface(
	.data_wire                   (data),
	.address_wire                (address),
	.read                        (read),
	.write_wire                  (write),
	.receive_fifo_data           (receive_fifo_data_out),
	.transmit_fifo_data          (transmit_fifo_data_in),
	.bit_time                    (bit_time),
	.line_loop                   (line_loop),
	.line_invert                 (line_invert),
	.sound_enable                (sound_enable_bus),
	.sound_sample_select         (sound_sample_select),
	.transmission_in_progress    (transmit_reg),
	.start_transmission          (start_transmission),
	.receive_enable              (receive_enable),
	.transmit_fifo_full          (transmit_fifo_full),
	.transmit_fifo_has_data      (transmit_fifo_has_data),
	.receive_fifo_full           (receive_fifo_full),
	.receive_fifo_has_data       (receive_fifo_has_data),
	.receive_fifo_read           (receive_fifo_read),
	.transmit_fifo_write         (transmit_fifo_write),
	.clk                         (clk),
	.rst_n                       (rst_n)
);

always @(posedge clk, negedge rst_n) begin
	if(!rst_n)
	begin
		transmit_reg <= 1'b0;
		receive_reg <= 1'b0;
	end
	else
	begin
		transmit_reg <= transmit_next;
		receive_reg <= receive_next;
	end
end

always @(*) begin
	transmit_next <= transmit_reg;
	receive_next <= receive_reg;

	if(start_transmission)
	begin
		transmit_next <= 1'b1;
	end
	else if((transmit_fifo_data_out == ETX_ASCII && next_character) || !transmit_fifo_has_data)
	begin
		transmit_next <= 1'b0;
	end

	if(message_start && receive_enable)
	begin
		receive_next <= 1'b1;
	end
	else if(receive_fifo_data_in == ETX_ASCII && write_character)
	begin
		receive_next <= 1'b0;
	end
end

endmodule