module fp_alu(
  output reg[31:0] out,
  input[31:0] a, b,
  input[2:0] selector,
  input cpu_clk, sqrt_clk, fp_clk, int_clk
);

parameter FPU_ADD = 3'd0; // add.s
parameter FPU_MUL = 3'd1; // mul.s
parameter FPU_DIV = 3'd2; // div.s
parameter SQRT = 3'd3;

wire [31:0] addOut, divideOut, multOut, sqrtOut;

fp_adder fpadd(
  .A(a),
  .B(b),
  .Out(addOut)
);

fp_divider fpdivide(
  .int_clk(int_clk),
  .fp_clk(fp_clk),
  .A(a),
  .B(b),
  .Out(divideOut)
);

fp_multiplier fpmultiply(
  .int_clk(int_clk),
  .fp_clk(fp_clk),
  .A(a),
  .B(b),
  .Out(multOut)
);

sqrt fpsqrt(
  .int_clk(int_clk),
  .fp_clk(fp_clk),
  .sqrt_clk(sqrt_clk),
  .cpu_clk(cpu_clk),
  .A(a),
  .Out(sqrtOut)
);

always @(*) begin
  case (selector)
    FPU_ADD: begin
      out = addOut;
    end

    FPU_MUL: begin
      out = multOut;
    end

    FPU_DIV: begin
      out = divideOut;
    end

    SQRT: begin
      out = sqrtOut;
    end

  endcase
end

endmodule
