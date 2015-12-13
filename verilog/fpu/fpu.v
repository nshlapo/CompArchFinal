module FPU(
  input cpu_clk, sqrt_clk, fp_clk, int_clk, fp_alu_src, fp_reg_dst,
  input[2:0] fp_alu_ctrl,
  input [4:0] Rs, Rt, Rd,
  input [15:0] immediate
);

wire [4:0] regDst;
wire [31:0] regData1, regData2, aluIn2, aluOut, paddedImm;

assign paddedImm = {immediate, 16'b0};
assign regDst = fp_reg_dst ? Rd : Rt;
assign aluIn2 = fp_alu_src ? paddedImm : regData2;

regfile regfile(
  .ReadData1(regData1),
  .ReadData2(regData2),
  .WriteData(aluOut),
  .ReadRegister1(Rs),
  .ReadRegister2(Rt),
  .WriteRegister(regDst),
  .RegWrite(1'b1),
  .Clk(cpu_clk)
);

fp_alu fpalu(
  .fp_clk(fp_clk),
  .int_clk(int_clk),
  .sqrt_clk(sqrt_clk),
  .cpu_clk(cpu_clk),
  .selector(fp_alu_ctrl),
  .a(regData1),
  .b(aluIn2),
  .out(aluOut)
);

endmodule
