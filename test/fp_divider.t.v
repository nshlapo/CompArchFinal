module fpDividerTest();

reg int_clk;
reg fp_clk;
reg[31:0] A,B;
wire[31:0] Out;

integer i;

fp_divider dut(
  .int_clk(int_clk),
  .fp_clk(fp_clk),
  .A(A),
  .B(B),
  .Out(Out)
);



initial begin
  $dumpfile("test/waveform.vcd");
  $dumpvars(0, dut);
  A = 32'habcabcab;
  B = 32'ha0ca0cab;
  // Setup
  fp_clk = 0;
  int_clk = 0; #5  
  fp_clk = 1;
  for (i=1;i<35;i=i+1) begin
    int_clk = 1; #5
    int_clk = 0; #5
    $display("Out: %b", Out);
  end
end
endmodule
