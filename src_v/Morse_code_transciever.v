module Morse_code_transciever
(
    input RD,
    input WR,
    input [31:0] ADDR,
    inout [31:0] DATA,

    //input clk,
    //input rst_n,

    input IN,
    output OUT,
    output INV,
    output LOOP,
    output SOUND_EN,
    output SOUND_SAMP,
    output [7:0] REC_REG
);

/*wire [31:0] BIT_TIME;
wire SF_R,SF_W,RF_R,RF_W;
wire [31:0] SF_DI;
wire [31:0] SF_DO;
wire [31:0] RF_DI;
wire [31:0] RF_DO;

wire START_TRANS;
wire TRANNS_CMPL;
reg trans;

wire RECV_EN;

wire SF_F,SF_NE,RF_F,RF_NE;

MC_arillaBus_interface u_MC_arillaBus_interface (
    .DATA           (DATA),
    .ADDR           (ADDR),
    .RD             (RD),
    .WR             (WR),
    .clk            (clk),
    .rst_n          (rst_n),
    .BIT_TIME       (BIT_TIME),
    .FIFO_IN        (SF_DI),
    .FIFO_OUT       (RF_DO),
    .LOOP           (LOOP),
    .INV            (INV),
    .SOUND_EN       (SOUND_EN),
    .SOUND_SAMP     (SOUND_SAMP),
    .TRANS_IP       (trans),
    .START_TRANS    (START_TRANS),
    .RECV_EN        (RECV_EN),
    .SEND_F         (SF_F),
    .SEND_NE        (SF_NE),
    .RECV_F         (RF_F),
    .RECV_NE        (RF_NE),
    .FIFO_READ      (RF_R),
    .FIFO_WRITE     (SF_W)
);

FIFO #(
    .BUS_WIDTH     (7),
    .DATA_WIDTH    (8)
) SF (
    .clk           (clk),
    .rst_n         (rst_n),
    .RD            (SF_R),
    .WR            (SF_W),
    .DIN           (SF_DI),
    .DOUT          (SF_DO),
    .full          (SF_F),
    .notEmpty      (SF_NE)
);

FIFO #(
    .BUS_WIDTH     (7),
    .DATA_WIDTH    (8)
) RF (
    .clk           (clk),
    .rst_n         (rst_n),
    .RD            (RF_R),
    .WR            (RF_W),
    .DIN           (RF_DI),
    .DOUT          (RF_DO),
    .full          (RF_F),
    .notEmpty      (RF_NE)
);

always @(posedge clk,negedge rst_n) begin
    if(!rst_n)
    begin
        trans <= 1'b0;
    end
    else
    begin
        if(START_TRANS)
        begin
            trans <= 1'b1;
        end
        if(TRANNS_CMPL)
        begin
            trans <= 1'b0;
        end
    end
end*/

reg clk;
reg rst_n;

reg [7:0] IN_DATA;
wire [7:0] P_DATA;

MC_ROM TXROM (
    .in     (IN_DATA),
    .out    (P_DATA)
);

wire [31:0] BIT_TIME = 32'd20;
reg start;
wire sample;

Async_timer u_Async_timer (
    .clk               (clk),
    .rst_n             (rst_n),
    .BIT_TIME          (BIT_TIME),
    .start             (start),
    .sample            (sample)
);


wire [2:0]S_DATA;
wire next;
wire req;
wire S_OUT;

Morse_shift_out u_Morse_shift_out (
    .clk       (clk),
    .rst_n     (rst_n),
    .P_DATA    (S_DATA),
    .shift     (sample),
    .S_DATA    (S_OUT),
    .next      (req)
);

Char_decoder u_Char_decoder (
    .clk            (clk),
    .rst_n          (rst_n),
    .P_DATA         (P_DATA),
    .req            (req),
    .S_DATA         (S_DATA),
    .next           (next)
);

always begin

    @(posedge next)
    IN_DATA = 0;
    @(posedge next)
    IN_DATA = 0;
    @(posedge next)
    IN_DATA = 8'h41;
    @(posedge next)
    IN_DATA = 8'h42;
    @(posedge next)
    IN_DATA = 8'h20;
    @(posedge next)
    IN_DATA = 8'h43;
    @(posedge next)
    IN_DATA = 8'h44;
    @(posedge next)
    IN_DATA = 8'h03;
    @(posedge next)
    IN_DATA = 8'h45;
    @(posedge next)
    IN_DATA = 8'h46;
    @(posedge next)
    IN_DATA = 8'h20;
    @(posedge next)
    IN_DATA = 8'h47;
    @(posedge next)
    IN_DATA = 8'h48;
    @(posedge next)
    IN_DATA = 8'h03;
end

initial begin
    
    clk = 0;

    rst_n =0;
    start =0;

    #5;

    rst_n =1;
     


    #5;

    forever begin
            clk = 1;

            #10;

            clk = 0;

            #10;        
    end
end

endmodule