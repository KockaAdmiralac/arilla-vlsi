module Morse_switch
(
    input INV,
    input LOOP,
    output MORSE_IN,
    input MORSE_OUT,
    inout GPIO0,
    inout GPIO1
);

wire intIn;
wire intOut;

assign MORSE_IN = LOOP ? MORSE_OUT : intIn; 
assign intOut = MORSE_OUT;

assign GPIO0  = INV ? intOut : 1'bz;
assign GPIO1  = INV ? 1'bz   : intOut;
assign intIn  = INV ? 1'bz   : GPIO0;
assign intOut = INV ? GPIO1  : 1'bz;

endmodule