module intMultiplierTest();

reg clk, start, dutpassed;
reg [3:0] a, b;
wire [7:0] product;

int_multiplier #(4) dut(
  .clk(clk),
  .a(a),
  .b(b),
  .start(start),
  .product(product)
);

integer i;

initial begin
  $dumpfile("test/waveform.vcd");
  $dumpvars(0, dut);

  // Setup
  dutpassed = 1'b1;
  #5 clk = 1'b0;

  // Test Case 1 - Multiply two positive numbers
  a = 4'd5;
  b = 4'd3;
  start = 1'b1;
  #5 clk = 1'b1; #5 clk = 1'b0;
  start = 1'b0;

  for (i = 0; i < 4; i = i+1) begin
    #5 clk = 1'b1; #5 clk = 1'b0;
  end

  if (product !== 8'd15) begin
    dutpassed = 1'b0;
    $display("Failed to multiply 5 and 3. Expected 8'd15, read 8'd%d", product);
  end

  // Test Case 2 - Multiply 0 and a positive number
  a = 4'd0;
  b = 4'd3;
  start = 1'b1;
  #5 clk = 1'b1; #5 clk = 1'b0;
  start = 1'b0;

  for (i = 0; i < 4; i = i+1) begin
    #5 clk = 1'b1; #5 clk = 1'b0;
  end

  if (product !== 8'd0) begin
    dutpassed = 1'b0;
    $display("Failed to multiply 0 and 3. Expected 8'd0, read 8'd%d", product);
  end

  // Test Case 3 - Multiply a positive number and 0
  a = 4'd5;
  b = 4'd0;
  start = 1'b1;
  #5 clk = 1'b1; #5 clk = 1'b0;
  start = 1'b0;

  for (i = 0; i < 4; i = i+1) begin
    #5 clk = 1'b1; #5 clk = 1'b0;
  end

  if (product !== 8'd0) begin
    dutpassed = 1'b0;
    $display("Failed to multiply 5 and 0. Expected 8'd0, read 8'd%d", product);
  end

  // Test Case 4 - Multiply the largest positive numbers
  a = 4'd15;
  b = 4'd15;
  start = 1'b1;
  #5 clk = 1'b1; #5 clk = 1'b0;
  start = 1'b0;

  for (i = 0; i < 4; i = i+1) begin
    #5 clk = 1'b1; #5 clk = 1'b0;
  end

  if (product !== 8'd225) begin
    dutpassed = 1'b0;
    $display("Failed to multiply 15 and 15. Expected 8'd225, read 8'd%d", product);
  end

  $display("Int multiplier passed?: %b", dutpassed);
end



endmodule
