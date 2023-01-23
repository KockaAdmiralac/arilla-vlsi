module Async_timer
(
    input clk,
    input rst_n,
    input [31:0]BIT_TIME,
    input start,
    output sample
);

reg [31:0]cnt;

wire [31:0]RELOAD = BIT_TIME - 1;
wire [31:0]PRELOAD = {1'b0,RELOAD[31:1]};

assign sample = cnt == 0;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        cnt <= 32'd0;
    end
    else
    begin
        if(start)
        begin
            cnt <=PRELOAD;
        end
        else if(cnt == 0)
        begin
            cnt <= RELOAD;
        end
        else
        begin
            cnt <= cnt - 1;
        end
    end
end

endmodule