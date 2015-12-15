// CPU Test - runs program specified in CPU memory

module cpuTest();

reg clk, sqrt_clk, fp_clk, int_clk;

reg dutpassed;

CPU dut(
	.clk(clk),
  .sqrt_clk(sqrt_clk),
  .fp_clk(fp_clk),
  .int_clk(int_clk)
);

initial clk = 0;
initial sqrt_clk = 0;
initial fp_clk = 0;
initial int_clk = 0;
always #200000 clk=!clk;
always #10000 sqrt_clk=!sqrt_clk;
always #500 fp_clk=!fp_clk;
always #5 int_clk=!int_clk;

initial begin
	$dumpfile("test/waveform.vcd");
	$dumpvars(0, dut);

  #2000000
	$finish;
end


endmodule
