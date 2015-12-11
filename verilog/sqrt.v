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

always @(posedge sqrt_clk) begin
    a_reg <= A;

    if (start)
        sqa <= 32'b1;

    else
        sqa <= shifted;
end

endmodule
