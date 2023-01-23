module Char_decoder
(
    input clk,
    input rst_n,
    input [7:0] P_DATA,
    input req,
    output [2:0] S_DATA,
    output next
);

reg [2:0]cnt;
reg [4:0]data;
reg mask;

assign next = cnt == 3'd7 && req;
assign S_DATA = (cnt==3'd7 || mask) ? 3'b000 : (data[cnt])? 3'b110 : 3'b010;

always @(posedge clk, negedge rst_n) begin
    if(!rst_n)
    begin
        cnt <= 3'd7;
        data <= 5'd0;
        mask <= 1'b0;
    end
    else
    begin
        if(req)
        begin
            if(next)
            begin
                if(P_DATA[7:5]==3'd6)
                begin
                    cnt <= 3'd7;
                    data <= P_DATA[4:0];
                    mask <= 1'b1;
                end
                else if(P_DATA[7:5]==3'd7)
                begin
                    cnt <= 3'd0;
                    data <= P_DATA[4:0];
                    mask <= 1'b1;
                end
                else
                begin
                    cnt <= P_DATA[7:5] - 3'd1;
                    data <= P_DATA[4:0];
                    mask <= 1'b0;
                end
            end
            else
            begin
                cnt <= cnt - 3'd1;
            end
        end
    end
end

endmodule