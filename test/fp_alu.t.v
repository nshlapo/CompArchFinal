module fpAluTest();
reg [31:0] A, B;
reg [2:0] selector;
wire [31:0] Out;
reg cpu_clk, sqrt_clk, fp_clk, int_clk;
reg dutpassed;
integer i;

fp_alu dut(
  .fp_clk(fp_clk),
  .int_clk(int_clk),
  .sqrt_clk(sqrt_clk),
  .cpu_clk(cpu_clk),
  .selector(selector),
  .a(A),
  .b(B),
  .out(Out)
);

// for addition tests
wire [22:0] fracOut;
wire [7:0] expOut;
assign fracOut = Out[22:0];
assign expOut = Out[30:23];


initial begin
  $dumpfile("test/waveform.vcd");
  $dumpvars(0, dut);
  dutpassed = 1'b1;

  // Setup
  fp_clk = 1'b0;
  #5
  fp_clk = 1'b1;
  int_clk = 1'b0;

  // Test Case 1 - Multiply two positive integers
  A = 32'h40a00000; // decimal 5
  B = 32'h40000000; // decimal 2
  selector = 3'd1;
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h41200000) begin // decimal 10
    dutpassed = 1'b0;
    $display("FP ALU test case 1 (multiplication) failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 2 - Multiply two negative integers
  A = 32'hc0a00000; // decimal -5
  B = 32'hc0000000; // decimal -2
  selector = 3'd1;
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h41200000) begin // decimal 10
    dutpassed = 1'b0;
    $display("FP ALU test case 2 (multiplication) failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 3 - Divide two positive integers
  A = 32'h41000000; // decimal 8
  B = 32'h40000000; // decimal 2
  selector = 3'd2;
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h40800000) begin // decimal 4
    dutpassed = 1'b0;
    $display("FP ALU test case 3 (division) failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 4 - Divide a positive decimal by a negative decimal
  A = 32'h415c0000; // decimal 13.75
  B = 32'hc0b00000; // decimal -5.5
  selector = 3'd2;
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'hc0200000) begin // decimal -2.5
    dutpassed = 1'b0;
    $display("FP ALU test case 4 (division) failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 5 - Add 2.5 + 0.5
  // 2.5 = 1.25 * 2^1
  // 0.5 = 1.0 * 2^-1
  A = {1'b0, 8'b10000000, 23'b01000000000000000000000}; // decimal 2.5
  B = {1'b0, 8'b01111110, 23'b00000000000000000000000}; // decimal 0.5
  selector = 3'd0;
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (fracOut !== 23'b10000000000000000000000 | expOut !== 8'b10000000)
  begin
    dutpassed = 1'b0;
    $display("FP ALU test case 5 (addition) failed. Read 32'h%h", Out);
  end

  // Test Case 6 - Add 6,500,000 and 14
  // 6,500,000 = 1.5497 * 2^22
  // 14 = 1.75 * 2^3

  A = {1'b0, 8'b10010101, 23'b10001100101110101000000}; // decimal 6,500,000
  B = {1'b0, 8'b10000010, 23'b11000000000000000000000}; // decimal 14
  #1

  if (fracOut !== 23'b10001100101110101011100 | expOut !== 8'b10010101)
  begin
    dutpassed = 1'b0;
    $display("FP ALU test case 6 (addition) failed. Read 32'h%h", Out);
  end

  $display("FP ALU passed?: %b", dutpassed);
end

endmodule
