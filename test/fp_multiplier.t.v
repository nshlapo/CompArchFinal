module fpMultiplierTest();

reg fp_clk, int_clk;
wire start;

fp_multiplier #(4) dut(
  .fp_clk(fp_clk),
  .int_clk(int_clk),
  .start(start)
);

initial begin
  $dumpfile("test/waveform.vcd");
  $dumpvars(0, dut);

  // Setup
  fp_clk = 1'b0;
  int_clk = 1'b0; #5
  $display("start x %b", start);
  fp_clk = 1'b1;
  int_clk = 1'b1; #5 int_clk = 1'b0; #5
  $display("start 1 %b", start);
  int_clk = 1'b1; #5 int_clk = 1'b0; #5
  $display("start 0 %b", start);
  int_clk = 1'b1; #5 int_clk = 1'b0; #5
  $display("start 0 %b", start);

end



endmodule
