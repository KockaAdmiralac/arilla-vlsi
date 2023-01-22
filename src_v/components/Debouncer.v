module Debouncer
(
    input in,
    input clk,
    input rst_n,
    input [31:0] RELOAD,
    output out
);

reg regA;
reg regB;
reg regC;
reg [31:0] cnt;

wire change;

assign out = regC;
assign change = regA ^ regB;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        regA <= 1'b0;
        regB <= 1'b0;
        regC <= 1'b0;
        cnt <= 32'b0;
    end
    else
    begin
        if(change)
        begin
            cnt <= RELOAD;
        end
        else if(cnt != 0) 
        begin
            cnt <= cnt - 1;
        end

        if(cnt == 0)
        begin
            regC <= regB;
        end

        regA <= in;
        regB <= regA;
    end
    
end

endmodule