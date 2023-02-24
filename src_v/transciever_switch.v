module transciever_switch
(
	input  line_invert,
	input  line_loop,
	output morse_code_in,
	input  morse_code_out,
	inout  GPIO0,
	inout  GPIO1
);

wire intermediateOutput;
wire intermediateInput;

assign intermediateOutput = morse_code_out;

bufif0(morse_code_in,intermediateInput,line_loop);
bufif1(morse_code_in,morse_code_out,line_loop);

bufif0(intermediateInput,GPIO0,line_invert);
bufif0(GPIO1,intermediateOutput,line_invert);

bufif1(GPIO0,intermediateOutput,line_invert);
bufif1(intermediateInput,GPIO1,line_invert);

endmodule