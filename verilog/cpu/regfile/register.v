module register
(
output reg  q,
input       d,
input       wrenable,
input       clk
);
    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule


module register32
(
output reg[width-1:0] q,
input[width-1:0]	d,
input wrenable,
input	clk
);

  parameter width = 32; // # bits in d and q
  integer i;
  always @(posedge clk) begin
    if(wrenable) begin
      for (i = 0; i < width; i = i + 1) begin
        q[i] = d[i];
      end
    end
  end

endmodule


module register32zero
(
output reg[width-1:0] q,
input[width-1:0] d,
input wrenable,
input clk
);

  parameter width = 32; // # bits in d and q
  integer i;
  always @(posedge clk) begin
    for (i = 0; i < width; i = i + 1) begin
      q[i] = 0;
    end
  end

endmodule
