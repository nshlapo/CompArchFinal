module fpDividerTest();
reg [31:0] A, B;
wire [31:0] Out;
reg fp_clk, int_clk;
reg dutpassed;
integer i;

fp_divider dut(
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

  // Test Case 1 - Divide two positive integers
  A = 32'h41000000; // decimal 8
  B = 32'h40000000; // decimal 2
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h40800000) begin // decimal 4
    dutpassed = 1'b0;
    $display("FP divider test case 1 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 2 - Divide an integer by 1
  A = 32'h41000000; // decimal 8
  B = 32'h3f800000; // decimal 1
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h41000000) begin // decimal 8
    dutpassed = 1'b0;
    $display("FP divider test case 2 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 3 - Divide a positive integer by a negative integer
  A = 32'h41000000; // decimal 8
  B = 32'hc0000000; // decimal -2
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'hc0800000) begin // decimal -4
    dutpassed = 1'b0;
    $display("FP divider test case 3 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 4 - Divide two negative integers
  A = 32'hc1000000; // decimal -8
  B = 32'hc0000000; // decimal -2
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h40800000) begin // decimal 4
    dutpassed = 1'b0;
    $display("FP divider test case 4 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 5 - Divide two positive decimals
  A = 32'h415c0000; // decimal 13.75
  B = 32'h40b00000; // decimal 5.5
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h40200000) begin // decimal 2.5
    dutpassed = 1'b0;
    $display("FP divider test case 5 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 6 - Divide a positive decimal by 1
  A = 32'h415c0000; // decimal 13.75
  B = 32'h3f800000; // decimal 1
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h415c0000) begin // decimal 13.75
    dutpassed = 1'b0;
    $display("FP divider test case 6 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 7 - Divide a positive decimal by a negative decimal
  A = 32'h415c0000; // decimal 13.75
  B = 32'hc0b00000; // decimal -5.5
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'hc0200000) begin // decimal -2.5
    dutpassed = 1'b0;
    $display("FP divider test case 7 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 8 - Divide two negative decimals
  A = 32'hc15c0000; // decimal -13.75
  B = 32'hc0b00000; // decimal -5.5
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h40200000) begin // decimal 2.5
    dutpassed = 1'b0;
    $display("FP divider test case 8 failed. Read 32'h%h", Out);
  end

  fp_clk = 1'b1;

  // Test Case 9 -
  A = 32'h42c80000; // decimal -13.75
  B = 32'h3f800000; // decimal -5.5
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h42c80000) begin // decimal 2.5
    dutpassed = 1'b0;
    $display("FP divider test case 9 failed. Read 32'h%h", Out);
  end


  fp_clk = 1'b1;

    // Test Case 10 -
  A = 32'h40800000; // decimal 4.0
  B = 32'h40200000; // decimal 2.5
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
    if (i==25) begin
      fp_clk = 1'b0;
    end
  end

  if (Out !== 32'h3fcccccc) begin // decimal 2.5
    dutpassed = 1'b0;
    $display("FP divider test case 10 failed. Read 32'h%h", Out);
  end

  $display("FP divider passed?: %b", dutpassed);
end

endmodule
