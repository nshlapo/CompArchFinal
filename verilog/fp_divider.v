module fp_divider
(
  input[31:0] A, B,
  input fp_clk,
  input int_clk,
  output[31:0] Out
);

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
