module ArillaBus_interface
(
    inout [31:0] DATA,
    input [31:0] ADDR,
    input RD,
    input WR,
    input F_ERR,
    input P_ERR,
    input [23:0] K_CD,
    input clk,
    input rst_n,
    output [4:0] DEB_TIME,
    output SYNCH_EN
);

reg [5:0] deviceReg;

wire [31:0] writeValue;
wire hit;

assign writeValue = {DEB_TIME[4:0],SYNCH_EN,F_ERR,P_ERR,K_CD[23:0]};
assign DEB_TIME = deviceReg[5:1];
assign SYNCH_EN = deviceReg[0];

assign hit = ADDR == 32'H30000000;

assign DATA = (hit && RD) ? writeValue : {32{1'bz}};

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        deviceReg <= 6'd0;
    end
    else
    begin
        if(hit && WR)
        begin
            deviceReg <= DATA[31:26];
        end
    end
end

endmodule