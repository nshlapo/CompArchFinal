module memory(
  input clk, regWE,
  input[9:0] DataAddr, InstrAddr,
  input[31:0] DataIn,
  output[31:0] DataOut, InstrOut
);

  reg [31:0] mem[1023:0];
  always @(posedge clk)
    if (regWE)
      mem[DataAddr] <= DataIn;
  initial $readmemh("data/fp_sqrt.dat", mem); // Test expects "data/sum.dat"
  assign DataOut = mem[DataAddr];
  assign InstrOut = mem[InstrAddr >> 2];
endmodule
