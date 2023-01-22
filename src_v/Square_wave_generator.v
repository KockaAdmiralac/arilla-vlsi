module Square_wave_generator
#(
    parameter HIGH_FREQ = 32'd49999,
    parameter LOW_FREQ = 32'd99999
)
(
    input in,
    input en,
    input freqSel,
    input clk,
    input rst_n,
    output out
);

reg dff;
reg [31:0] cnt;

wire gen;
wire dffin;
wire [31:0] freq;
wire [31:0] thresh;


assign out = dff;
assign gen = in && en;
assign dffin = cnt > thresh && gen;

assign freq = freqSel ? LOW_FREQ : HIGH_FREQ;
assign thresh = {1'b0,freq[31:1]};

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        cnt <= HIGH_FREQ;
        dff <= 1'b0;
    end
    else
    begin
        if(!gen || cnt == 32'd0)
        begin
            cnt <= freq;
        end
        else
        begin
            cnt <= cnt - 1;
        end
        dff <= dffin;
    end
    
end


endmodule