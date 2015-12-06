module fp_adder
(
  input[31:0] A, B,
  output[31:0] Out
);

  wire signA, signB;
  wire [7:0] expA, expB;
  wire [22:0] fracA, fracB;
  wire [23:0] coeffA, coeffB;
  wire sign_out;
  wire [7:0] exp_out;

  wire [23:0] Ashifted, Bshifted;
  wire [7:0] largerExp, outExp;
  wire [24:0] sum;
  wire AltB;
  wire [22:0] outFrac;

  assign signA = A[31];
  assign signB = B[31];
  assign expA = A[30:23];
  assign expB = B[30:23];
  assign fracA = A[22:0];
  assign fracB = B[22:0];
  assign coeffA = {1'b1, fracA};
  assign coeffB = {1'b1, fracB};

  assign AltB = expA < expB;

  assign Ashifted = AltB ? (coeffA >> (expB - expA)) : coeffA;
  assign Bshifted = AltB ? coeffB : (coeffB >> (expA - expB));

  assign sum = Ashifted + Bshifted;
  assign largerExp = AltB ? expB : expA;
  assign outFrac = sum[24] ? sum[23:1] : sum[22:0];

  assign Out = {1'b0, largerExp + sum[24], outFrac};


endmodule
