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

  // Test Case 1 - Multiply two positive numbers
  A = 32'h40a00000;
  B = 32'h40000000;
  for (i=0;i<50;i= i+1) begin
    #5 int_clk = 1'b1; #5 int_clk = 1'b0;
  end

  if (Out !== 32'h41200000) begin
    dutpassed = 1'b0;
    $display("Failed to multiply 32'h0 and 32'h0. Expected 32'h0, read 32'h%h", Out);
  end

end

endmodule
