module fp_multiplier
(
  input[31:0] A, B,
  input fp_clk,
  input int_clk,
  output[31:0] Out
);
  reg start;
  wire signA, signB;
  wire [7:0] expA, expB;
  wire [22:0] fracA, fracB;
  wire [23:0] coeffA, coeffB;
  wire [47:0] product;
  wire [22:0] frac_out;
  wire sign_out;
  wire [7:0] exp_out;

  assign signA = A[31];
  assign signB = B[31];
  assign expA = A[30:23];
  assign expB = B[30:23];
  assign fracA = A[22:0];
  assign fracB = B[22:0];
  assign coeffA = {1'b1, fracA};
  assign coeffB = {1'b1, fracB};

  int_multiplier #(24) dut(
    .clk(int_clk),
    .a(coeffA),
    .b(coeffB),
    .start(start),
    .product(product)
  );

  assign frac_out = product[47] ? product[46:24] : product[45:23];
  assign exp_out = expA + expB + product[47] - 127;
  xor signlog(sign_out, signA, signB);

  assign Out = {sign_out, exp_out, frac_out};

  always @(posedge fp_clk) begin
    start <= 1'b1;
  end

  always @(posedge int_clk) begin
    if (start === 1) begin
      start <= 1'b0;
    end
  end



endmodule
