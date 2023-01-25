module EdgeDetector (
    input clk,
    input rst_n,
    input in,
    output out_re,
	 output out_fe
);

    reg ff1_next, ff1_reg;
    reg ff2_next, ff2_reg;

    assign out_re = ff1_reg & ~ff2_reg;
	 assign out_fe = ~ff1_reg & ff2_reg;
    always @(posedge clk, negedge rst_n)
        if (!rst_n) begin
            ff1_reg <= 1'b0;
            ff2_reg <= 1'b0;
        end
        else begin
            ff1_reg <= ff1_next;
            ff2_reg <= ff2_next;
        end

    always @(*) begin
        ff1_next = in;
        ff2_next = ff1_reg;
    end

endmodule