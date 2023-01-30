module user_interface
(
	input  [9:0] switch,
	input  [3:0] button,
	output rst,
	output [9:0] debug_switch,
	output [2:0] debug_button,
	output led_select,
	output seven_segment_select
);

//button 0 reset
assign rst = ~button[0];
//switch 9 enable instruction step
//switch 8 display opcode
//switch 7 enable single step
assign debug_switch[9:0] = {switch[9],7'd0,switch[8:7]};
//button 2 single step
//button 1 instruction step
assign debug_button[2:0] = {button[2:1],1'b0};
//switch 1 select led display
assign led_select = switch[1];
//switch 0 select seven segment display
assign seven_segment_select = switch[0];

endmodule