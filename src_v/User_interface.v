module User_interface
(
    input [9:0] SW,
    input [3:0] BTN,
    output rst,
    output [9:0] D_SW,
    output [2:0] D_BTN,
    output [1:0] CNTRL
);

assign rst = ~BTN[0];
assign D_SW[9:0] = {SW[9],7'd0,SW[8],SW[7]};
assign D_BTN[2:0] = {BTN[2:1],1'b0};
assign CNTRL[1:0] = SW[1:0];

endmodule