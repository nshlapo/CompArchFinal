module int_multiplier
#(parameter width = 32)
(
  output reg [2*width-1:0] product,
  input [width-1:0] a,
  input [width-1:0] b,
  input start,
  input clk
);

  reg [width-1:0] a_reg;
  reg [2*width-1:0] b_reg;

  always @(posedge clk) begin
    if (start === 1) begin
      a_reg <= a;
      b_reg <= b;
      product <= 1'b0;
    end else begin
      if (a_reg[0] === 1) begin
        product = product + b_reg;
      end
      a_reg <= a_reg >> 1;
      b_reg <= b_reg << 1;
    end
  end

endmodule
