module FPU(
  input cpu_clk, fp_clk, int_clk
);

wire [31:0] regData1, regData2, aluIn, aluOut, paddedImm;

regfile regfile(
  .ReadData1(),
  .ReadData2(),
  .WriteData(),
  .ReadRegister1(),
  .ReadRegister2(),
  .WriteRegister(),
  .RegWrite(),
  .Clk()
);

endmodule
