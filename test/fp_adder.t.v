module fpAdderTest();
reg [31:0] A, B;

wire [31:0] Out;
reg dutpassed;
integer i;

wire [22:0] fracOut;
wire [7:0] expOut;

fp_adder dut(
  .A(A),
  .B(B),
  .Out(Out)
);

assign fracOut = Out[22:0];
assign expOut = Out[30:23];

initial begin
  $dumpfile("test/waveform.vcd");
  $dumpvars(0, dut);
  dutpassed = 1'b1;

  // Test Case 1 - Add 2.5 + 0.5
  // 2.5 = 1.25 * 2^1
  // 0.5 = 1.0 * 2^-1
  A = {1'b0, 8'b10000000, 23'b01000000000000000000000};
  B = {1'b0, 8'b01111110, 23'b00000000000000000000000};
  #1

  if (fracOut !== 23'b10000000000000000000000 | expOut !== 8'b10000000)
  begin
    dutpassed = 1'b0;
    $display("Failed to add 2.5 and 0.5.");
  end

  // Test Case 2 - Add 100 and 23
  // 100 = 1.5625 * 2^6
  // 23 = 1.4375 * 2^4

  A = {1'b0, 8'b10000101, 23'b10010000000000000000000};
  B = {1'b0, 8'b10000011, 23'b01110000000000000000000};
  #1

  if (fracOut !== 23'b11101100000000000000000 | expOut !== 8'b10000101)
  begin
    dutpassed = 1'b0;
    $display("Failed to add 100 and 23.");
  end

  // Test Case 3 - Add 6,500,000 and 14
  // 6,500,000 = 1.5497 * 2^22
  // 14 = 1.75 * 2^3

  A = {1'b0, 8'b10010101, 23'b10001100101110101000000};
  B = {1'b0, 8'b10000010, 23'b11000000000000000000000};
  #1

  if (fracOut !== 23'b10001100101110101011100 | expOut !== 8'b10010101)
  begin
    dutpassed = 1'b0;
    $display("Failed to add 6,500,000 and 14.");
  end

  $display("FP adder passed?: %b", dutpassed);

end

endmodule
