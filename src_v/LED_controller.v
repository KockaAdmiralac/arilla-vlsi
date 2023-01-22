module LED_controller
(
    input [9:0] DEBUG_OUT,
    input MC_OUT,
    input MC_IN,
    input MC_REC_REG[7:0],
    input LED_SEL,
    output [9:0] LED
);

wire [9:0] DEBUG_LED;
wire [9:0] MC_LED;

assign DEBUG_LED = {DEBUG_OUT[9:5],1'b0,DEBUG_OUT[1],DEBUG_OUT[0],MC_IN,MC_OUT};
assign MC_LED = {MC_REC_REG[7:0],MC_IN,MC_OUT};

assign LED = LED_SEL ? MC_LED : DEBUG_LED;

endmodule