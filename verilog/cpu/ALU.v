`define AND and //simulate physical gate delay
`define OR or
`define NOT not
`define NOR nor
`define NAND nand
`define XOR xor
`define XNOR xnor

`define cADD  3'd0
`define cSUB  3'd1
`define cXOR  3'd2
`define cSLT  3'd3
`define cAND  3'd4
`define cNAND 3'd5
`define cNOR  3'd6
`define cOR   3'd7


module ALU(output reg[31:0] result,
           output reg carryflag,
           output reg overflag,
           output zero,
           input[31:0] a, b,
           input[2:0] selector
);
// module that calculates result to various operations and sends back correct one based on
// mux index
    wire[2:0] muxindex;
    wire inverse, carryin, carryout;
    wire[31:0] xres, nares, nores, mathres, sltres;
    reg carryflag2, overflag2;
    ALUcontrolLUT controlLUT (muxindex, inverse, carryin, selector);

    xOr32 xor32 (xres, a, b);
    nAnd32 nand32 (nares, a, b, inverse);
    nOr32 nor32 (nores, a, b, inverse);
    doMath mather (mathres, carrymath, overmath, a, b, inverse, carryin);
    SLT slt (sltres, carryslt, overslt, a, b);

    always @(*) begin
        case (muxindex)
          3'd0:  begin
            result = xres;
            carryflag = 1'b0;
            overflag = 1'b0;
            end
          3'd1:  begin
            result = nares;
            carryflag = 1'b0;
            overflag = 1'b0;
            end
          3'd2:  begin
            result = nores;
            carryflag = 1'b0;
            overflag = 1'b0;
            end
          3'd3:  begin
            result = mathres;
            carryflag = carrymath;
            overflag = overmath;
            end
          3'd4:  begin
            result = sltres;
            carryflag = 1'b0;
            overflag = overmath;
            end
          default:
            begin end
            //$display("ALU error: %b", muxindex);
        endcase
    end
    zeroTest zertest (zero, result);
endmodule

module zeroTest(output zeroflag,
                input[31:0] result);
// module that nors all result bits to find if any is not 0
    `NOR zerOr(zeroflag, result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],
      result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15],result[16],
      result[17],result[18],result[19],result[20],result[21],result[22],result[23],result[24],result[25],
      result[26],result[27],result[28],result[29],result[30],result[31]);

endmodule

module ALUcontrolLUT(output reg[2:0] muxindex,
           output reg inverse,
           output reg carryin,
           input[2:0] ALUcommand);
// module that looks up a mux index, inverse, and carryin based on the desired operation
    always @(ALUcommand) begin
        case (ALUcommand)
          `cXOR:  begin assign muxindex = 3'd0; assign inverse=0; assign carryin = 0; end
          `cNAND: begin assign muxindex = 3'd1; assign inverse=0; assign carryin = 0; end
          `cAND:  begin assign muxindex = 3'd1; assign inverse=1; assign carryin = 0; end
          `cNOR:  begin assign muxindex = 3'd2; assign inverse=0; assign carryin = 0; end
          `cOR:   begin assign muxindex = 3'd2; assign inverse=1; assign carryin = 0; end
          `cADD:  begin assign muxindex = 3'd3; assign inverse=0; assign carryin = 0; end
          `cSUB:  begin assign muxindex = 3'd3; assign inverse=1; assign carryin = 1; end
          `cSLT:  begin assign muxindex = 3'd4; assign inverse=1; assign carryin = 0; end
        endcase
    end
endmodule

module xOr32(output[31:0] xRes,
             input[31:0] a, b);
// module to do bitwise xor with a for loop
    generate
        genvar j;
        for (j=0; j<32; j=j+1) begin: xorblock
            `XOR xor32 (xRes[j], a[j], b[j]);
        end
    endgenerate
endmodule

module nAnd32(output[31:0] res,
              input[31:0] a, b,
              input inverse);
// module which does bitwise nand with a for loop, and then xors with inverse, in order to calculate and
    wire[31:0] nandRes;
    wire[31:0] inverseExtended;

    generate
        genvar l;
        for (l=0; l<32; l=l+1) begin: nandblock
            `NAND nand32 (nandRes[l], a[l], b[l]);
        end
    endgenerate

    signExtend invExtender(inverseExtended, inverse);

    xOr32 xor32 (res, nandRes, inverseExtended);

endmodule

module nOr32(output[31:0] res,
             input[31:0] a, b,
             input inverse);
// module which does bitwise nand with a for loop, and then xors with inverse, in order to calculate or
    wire[31:0] norRes;
    wire[31:0] inverseExtended;

    generate
        genvar n;
        for (n=0; n<32; n=n+1) begin: norblock
            `NOR nor32 (norRes[n], a[n], b[n]);
        end
    endgenerate

    signExtend invExtender(inverseExtended, inverse);

    xOr32 xor32 (res, norRes, inverseExtended);

endmodule

module SLT(output[31:0] res,
           output carryout, overflow,
           input[31:0] a, b);
// module which calls math module with inverse and carryin, then grabs most significant bit in order to calculate less than
    wire[31:0] mathres;

    doMath mather (mathres, carryout, overflow, a, b, 1'b1, 1'b1);

    assign res = mathres[31];

endmodule

// module SLT(output[31:0] res,
//            // output carryout, overflow,
//            input[31:0] mathres);

//     res = {mathres[31], 31'b00000000000000000000000000000000}
// endmodule

module doMath(output[31:0] res,
              output carryout, overflow,
              input[31:0] a, b,
              input inverse, carryin);
// module that xors b with inverse to invert it if necessary, then calls 32 bit adder to calculate total
    wire[31:0] paddedSub;

    signExtend extender(paddedSub, inverse);

    wire[31:0] bmod;
    xOr32 xor32 (bmod, b, paddedSub);

    fullAdder32bit fadder32 (res, carryout, overflow, a, bmod, carryin);

endmodule

module fullAdder32bit(output[31:0] sum,  // 2's complement sum of a and b
                      output carryout, overflow,
                      input[31:0] a, b,     // First operand in 2's complement format
                      input carryin);
// module that adds 32-bit numbers by calling 1-bit adders in a for loop and calculates overflow with xor
    wire [32:0] carry;
    assign carry[0] = carryin;

    generate
        genvar o;
        for (o=0; o<32; o=o+1) begin: addblock
            bitFullAdder fadder (sum[o], carry[o+1], a[o], b[o], carry[o]);
        end
    endgenerate

    assign carryout = carry[32];
    `XOR overflowcalc (overflow, carry[32], carry[31]);
endmodule

module bitFullAdder(out, carryout, a, b, carryin);
// module that adds two single bits
    output out, carryout; //declare vars
    input a, b, carryin;
    wire AxorB, fullAnd, AandB;

    `XOR AxB (AxorB, a, b); //first level gates
    `AND ABand (AandB, a, b);
    `AND Alland (fullAnd, carryin, AxorB);

    `XOR Sout (out, AxorB, carryin); //final gates
    `XOR Cout (carryout, AandB, fullAnd);
endmodule

module signExtend(signExtendedInverse, inverse);
// module that sign extends a number
    output[31:0] signExtendedInverse;
    input inverse;

    generate
        genvar index;
        for (index=0; index<32; index=index+1) begin: subpad
            assign signExtendedInverse[index] = inverse;
        end
    endgenerate
endmodule
