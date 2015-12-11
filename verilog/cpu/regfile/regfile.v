//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

module regfile
(
output[31:0]	ReadData1,	   // Contents of first register read
output[31:0]	ReadData2,	   // Contents of second register read
input[31:0]	  WriteData,	   // Contents to write to register
input[4:0]	  ReadRegister1, // Address of first register to read
input[4:0]	  ReadRegister2, // Address of second register to read
input[4:0]	  WriteRegister, // Address of register to write
input		      RegWrite,	     // Enable writing of register when High
input		      Clk		         // Clock (Positive Edge Triggered)
);

  // Generate write enables for all 32 registers
  wire[31:0] decoder_out;
  decoder1to32 d(decoder_out, RegWrite, WriteRegister);

  // Make the 32 registers
  wire[31:0] reg_outputs[31:0]; // Create a 2D array of wires

  // ...make the first register (always 0)
  register32zero r0(reg_outputs[0], 32'b0, decoder_out[0], Clk);

  // ...make the remaining 31 registers
  genvar i;
  generate
    for (i = 1; i < 32; i = i + 1) begin:REGISTERS
      register32 rN(reg_outputs[i], WriteData, decoder_out[i], Clk);
    end
  endgenerate

  // Two muxes for the two addresses
  mux32to1by32 mux1(ReadData1, ReadRegister1, reg_outputs[0], reg_outputs[1], reg_outputs[2], reg_outputs[3], reg_outputs[4], reg_outputs[5], reg_outputs[6], reg_outputs[7], reg_outputs[8], reg_outputs[9], reg_outputs[10], reg_outputs[11], reg_outputs[12], reg_outputs[13], reg_outputs[14], reg_outputs[15], reg_outputs[16], reg_outputs[17], reg_outputs[18], reg_outputs[19], reg_outputs[20], reg_outputs[21], reg_outputs[22], reg_outputs[23], reg_outputs[24], reg_outputs[25], reg_outputs[26], reg_outputs[27], reg_outputs[28], reg_outputs[29], reg_outputs[30], reg_outputs[31]);
  mux32to1by32 mux2(ReadData2, ReadRegister2, reg_outputs[0], reg_outputs[1], reg_outputs[2], reg_outputs[3], reg_outputs[4], reg_outputs[5], reg_outputs[6], reg_outputs[7], reg_outputs[8], reg_outputs[9], reg_outputs[10], reg_outputs[11], reg_outputs[12], reg_outputs[13], reg_outputs[14], reg_outputs[15], reg_outputs[16], reg_outputs[17], reg_outputs[18], reg_outputs[19], reg_outputs[20], reg_outputs[21], reg_outputs[22], reg_outputs[23], reg_outputs[24], reg_outputs[25], reg_outputs[26], reg_outputs[27], reg_outputs[28], reg_outputs[29], reg_outputs[30], reg_outputs[31]);

endmodule
