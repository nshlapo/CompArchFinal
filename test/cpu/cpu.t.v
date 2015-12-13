// CPU Test - runs program specified in CPU memory

module cpuTest();

reg clk;

reg dutpassed;

CPU dut(
	.clk(clk),
  .sqrt_clk(sqrt_clk),
  .fp_clk(fp_clk),
  .int_clk(int_clk)
);

initial clk = 1;
always #1000 clk=!clk;
always #100 sqrt_clk=!sqrt_clk;
always #10 fp_clk=!fp_clk;
always #1 int_clk=!int_clk;

initial begin
	$dumpfile("test/waveform.vcd");
	$dumpvars(0, dut);

	#10000
	$finish;
end


endmodule
