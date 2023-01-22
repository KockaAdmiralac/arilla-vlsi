module POR_counter
#(
    parameter POR_VALUE = 5050
)
(
    input rst,
    input clk,
    output rst_p,
    output rst_n
);

integer val;

assign rst_p = val != 0;
assign rst_n = val == 0;

always @(posedge clk) begin
    if(rst)
    begin
        val <= POR_VALUE;
    end
    else if(val != 0)
    begin
        val <= val - 1;
    end
end

endmodule