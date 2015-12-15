module sqrt
(
  input[31:0] A,
  input cpu_clk, sqrt_clk, fp_clk, int_clk,
  output [31:0] Out
);

reg start;
reg [31:0] sqa, a_reg;
wire [31:0] ratio, sum, shifted;

fp_divider fdiv(
  .int_clk(int_clk),
  .fp_clk(fp_clk),
  .A(A),
  .B(sqa),
  .Out(ratio)
);

fp_adder fadd (ratio, sqa, sum);


assign shifted = {sum[31], sum[30:23]-8'b1, sum[22:0]};
assign Out = sqa;

initial
    sqa = 32'h3f800000;

always @(posedge int_clk) begin
    if (start)
      sqa <= 32'h3f800000;
      a_reg <= A;
      start <= 0;
end

always @(posedge sqrt_clk) begin
    if (start == 0)
        sqa <= shifted;
end

always @(posedge cpu_clk) begin
    start <= 1;
end

endmodule
