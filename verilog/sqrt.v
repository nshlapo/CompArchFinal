module sqrt
(
  input[31:0] A,
  input sqrt_clk,
  input fp_clk,
  input int_clk,
  input start,
  output[31:0] Out
);

reg [31:0] sqa, a_reg;
wire [31:0] ratio, sum, shifted;

fp_divider fdiv (a_reg, sqa, fp_clk, ratio, int_clk);
fp_adder fadd (ratio, sqa, sum);


assign shifted = {sum[31], sum[30:23]-8'b1, sum[22:0]};
assign Out = sqa;

initial
    sqa = 32'h3f800000;

always @(posedge int_clk) begin
    if (start)
      sqa <= 32'h3f800000;
      a_reg <= A;
end

always @(posedge sqrt_clk) begin

    if (start == 0)
        sqa <= shifted;
end

endmodule