module fpMultiplierTest();
reg [31:0] A, B;
wire [31:0] Out;
reg fp_clk, int_clk;
reg dutpassed;
integer i;

fp_multiplier dut(
  .fp_clk(fp_clk),
  .int_clk(int_clk),
  .A(A),
  .B(B),
  .Out(Out)
);

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
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h41200000) begin // decimal 10
    dutpassed = 1'b0;
    $display("FP multiplier test case 1 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 2 - Multiply an integer by 1
  A = 32'h40a00000; // decimal 5
  B = 32'h3f800000; // decimal 1
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h40a00000) begin // decimal 5
    dutpassed = 1'b0;
    $display("FP multiplier test case 2 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 3 - Multiply a positive integer by a negative integer
  A = 32'h40a00000; // decimal 5
  B = 32'hc0000000; // decimal -2
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'hc1200000) begin // decimal -10
    dutpassed = 1'b0;
    $display("FP multiplier test case 3 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 4 - Multiply two negative integers
  A = 32'hc0a00000; // decimal -5
  B = 32'hc0000000; // decimal -2
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h41200000) begin // decimal 10
    dutpassed = 1'b0;
    $display("FP multiplier test case 4 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 5 - Multiply two positive decimals
  A = 32'h40b00000; // decimal 5.5
  B = 32'h40300000; // decimal 2.75
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h41720000) begin // decimal 15.125
    dutpassed = 1'b0;
    $display("FP multiplier test case 5 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 6 - Multiply a positive decimal by 1
  A = 32'h40b00000; // decimal 5.5
  B = 32'h3f800000; // decimal 1
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h40b00000) begin // decimal 5.5
    dutpassed = 1'b0;
    $display("FP multiplier test case 6 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 7 - Multiply a positive decimal by a negative decimal
  A = 32'h40b00000; // decimal 5.5
  B = 32'hc0300000; // decimal -2.75
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'hc1720000) begin // decimal -15.125
    dutpassed = 1'b0;
    $display("FP multiplier test case 6 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 8 - Multiply two negative decimals
  A = 32'hc0b00000; // decimal -5.5
  B = 32'hc0300000; // decimal -2.75
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h41720000) begin // decimal 15.125
    dutpassed = 1'b0;
    $display("FP multiplier test case 5 failed. Read 32'h%h", Out);
  end

  $display("DUT passed?: %b", dutpassed);
end

endmodule
