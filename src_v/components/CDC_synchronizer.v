module CDC_synchronizer
(
    input in,
    input clk,
    input rst_n,
    output out
);

reg regA;
reg regB;

assign out = regB;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        regA <= 1'b0;
        regB <= 1'b0;
    end
    else
    begin
        regA <= in;
        regB <= regA;
    end
end

endmodule