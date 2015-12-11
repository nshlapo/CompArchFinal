// CPU Test - runs program specified in CPU memory

module cpuTest();

reg clk;

reg dutpassed;

CPU dut(
	.clk(clk)
);

initial clk = 1;
always #10 clk=!clk; // 50MHz Clock

initial begin
	$dumpfile("test/waveform.vcd");
	$dumpvars(0, dut);

	#10000
	$finish;
end


endmodule
