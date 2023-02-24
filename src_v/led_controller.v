module led_controller
(
	input  [9:0] debug_leds,
	input  [7:0] receive_history,
	input  morse_code_in,
	input  morse_code_out,
	input  led_select,
	output [9:0] led
);

wire [9:0] debug_mode;
wire [9:0] morse_code_mode;

//debug_leds[9:5] opcode
//debug_leds[1:0] halted, fault
assign debug_mode = {debug_leds[9:5],1'b0,debug_leds[1:0],morse_code_in,morse_code_out};
assign morse_code_mode = {receive_history,morse_code_in,morse_code_out};

assign led = led_select ? morse_code_mode : debug_mode;

endmodule