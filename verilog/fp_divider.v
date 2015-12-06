module fp_divider
(
  input [31:0] A, B,
  input fp_clk,
  output[31:0] Out,
  input int_clk
);

//decode wires
wire a_sign, b_sign;
wire[7:0] a_exp, b_exp;
wire[22:0] a_frac, b_frac;
//calculation regs
reg start;
reg zero;
reg[47:0] b_reg, a_reg;
reg[24:0] Q;
//out wires
reg[22:0] out_frac;
wire[7:0] out_exp;
wire out_sign;

//decode the inputs
assign a_sign = A[31];
assign b_sign = B[31];
assign a_exp = A[30:23];
assign b_exp = B[30:23];
assign a_frac = A[22:0];
assign b_frac = B[22:0];


always @(posedge fp_clk) begin
  start <= 1'b1;
end

//calculate the quotient Q = A/B (timed to int_clk) by subtracting powers of the denominator B
always @(posedge int_clk) begin
  if (start===1) begin //Set initial values
    start <= 0;
    b_reg <= {1'b1, b_frac, 24'b0}; //
    a_reg <= {1'b1, a_frac, 24'b0}; //a_reg holds the remainder
    Q <= 0;
  end
  else begin
    if (zero === 0) begin //Check that the denominator hasn't bottomed out, which signals the end of the division.
      if(b_reg<=a_reg) begin
        a_reg <= a_reg-b_reg;
      end
      b_reg <= (b_reg >> 1); //right shift divides by two
      Q <= (Q+1) << 1; //Make space for the next digit of the quotient
      zero <= (b_reg[47:24]===24'b0);
    end
    else begin //ending sequence, assign frac out and the exponent
	if (Q[24]===1) begin
	  out_frac <= Q[23:1];
	end
	else begin
	  out_frac <= Q[22:0];
        end
    end
  end
end
//exponent logic
assign out_exp = a_exp - b_exp - Q[24] + 127;
//sign bit logic
xor sign(out_sign, a_sign, b_sign);
//Concatenate the output values
assign Out = {out_sign, out_exp, out_frac};

endmodule

// module
// #(width = 32)
// (
// input clk,
// input start,
// input[width-1:0] A, B,
// output[2*width-1:0] Q
// );
// reg[width*2-1:0] a_reg, r_reg;

// always @(posedge clk) begin
//    if (start===1) begin
//   a_reg <= {A,31'b0};
//   r_reg <= {B,31'b0};
//   Q <= 63'b0;
//    end
//    else begin
//   if (a_reg>r_reg) begin
//      r_reg <= r_reg-a_reg;
//      Q <= Q+1;
//   end
//   a_reg >> 2;
//   Q << 2;
//    end
// end
