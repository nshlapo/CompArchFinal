module fp_multiplier

(
  input[31:0] A, B,
  input fp_clk,
  input int_clk,
  output reg start
);
wire signA, signB;
wire [7:0] expA, expB;
wire [22:0] fracA, fracB;

assign signA = A[31];
assign signB = B[31];
assign expA = A[30:23];
assign expB = B[30:23];
assign fracA = A[22:0]; //add MSB
assign fracB = B[22:0]; //add MSB

  int_multiplier #(4) dut(
    .clk(int_clk),
    .a(fracA),
    .b(fracB),
    .start(start),
    .product(product)
  );

  always @(posedge fp_clk) begin
    start <= 1'b1;
  end

  always @(posedge int_clk) begin
    if (start === 1) begin
      start <= 1'b0;
    end
  end

endmodule
