module MC_arillaBus_interface
(
    inout [31:0] DATA,
    input [31:0] ADDR,
    input RD,
    input WR,
    input clk,
    input rst_n,
    
    output [31:0] BIT_TIME,
    output [7:0] FIFO_IN,
    input [7:0] FIFO_OUT,

    output LOOP,
    output INV,
    output SOUND_EN,
    output SOUND_SAMP,
    input TRANS_IP,
    output START_TRANS,
    output RECV_EN,
    input SEND_F,
    input SEND_NE,
    input RECV_F,
    input RECV_NE,
    output FIFO_READ,
    output FIFO_WRITE
);

reg [31:0] BTR;
reg [4:0] CSR;

wire [31:0]outval[2:0];

assign outval[0] = {21'd0,CSR[4],CSR[3],CSR[2],CSR[1],TRANS_IP,1'b0,CSR[0],SEND_F,SEND_NE,RECV_F,RECV_NE};
assign outval[1] = BTR;
assign outval[2] = {24'd0,FIFO_OUT};

assign BIT_TIME = BTR;
assign FIFO_IN = DATA[7:0];

assign LOOP = CSR[4];
assign INV = CSR[3];
assign SOUND_SAMP = CSR[2];
assign SOUND_EN = CSR[1];
assign RECV_EN = CSR[0];

assign START_TRANS = ADDR == 32'h40000000 && WR && DATA[5];
assign FIFO_READ = ADDR == 32'h40000008 && RD;
assign FIFO_WRITE = ADDR == 32'h40000008 && WR;

assign DATA = AddressFunction(ADDR,RD);

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        BTR <=32'd20;
        CSR <=5'b00000;
    end
    else
    begin
        if(WR)
        begin
            case (ADDR)
                32'h40000000: begin
                    CSR <= {DATA[10:7],DATA[4]};
                end
                32'h40000004: begin
                    BTR <= DATA;
                end
            endcase
        end
    end
end

function [31:0] AddressFunction(input [31:0] ADDR, input RD);
    if(RD)
    begin
        case (ADDR)
            32'h40000000: AddressFunction = outval[0];
            32'h40000004: AddressFunction = outval[1];
            32'h40000008: AddressFunction = outval[2];
            default     : AddressFunction = {32{1'bz}};
        endcase
    end
    else
    begin
        AddressFunction = {32{1'bz}};
    end
endfunction

endmodule