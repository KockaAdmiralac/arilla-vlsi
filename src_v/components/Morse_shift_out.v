module Morse_shift_out
(
    input clk,
    input rst_n,
    input [2:0] P_DATA,
    input shift,
    output S_DATA,
    output next
);

reg [2:0]dreg;

assign S_DATA = dreg[0];

assign next = dreg[2:1] == 2'd0 && shift;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        dreg <= 3'd0;
    end
    else
    begin
        if(shift)
        begin
            if(next)
            begin
                dreg <= P_DATA;
            end
            else
            begin
                dreg <= {1'b0,dreg[2:1]};
            end
        end
    end
end

endmodule