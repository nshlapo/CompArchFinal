module converter (
    input [31:0] fixed,
    input [7:0] exp_in,
    input load_new, clk,
    output [31:0] float);

wire [31:0] pos_int, shifted;
wire [7:0] incremented;
wire shift_ctrl;
reg sign;
reg [7:0] exponent;
reg [31:0] fraction;

assign pos_int = fixed[31] ? (~fixed + 32'b1) : fixed;
assign shift_ctrl = ~fraction[31];
assign float = {sign, (8'd127 + exp_in + 8'd31 - exponent), fraction[30:8]};

always @(posedge clk) begin
    if (load_new) begin
        exponent <= 0;
        sign <= fixed[31];
        fraction <= pos_int;
    end

    else begin
        if (shift_ctrl) begin
            fraction <= fraction<<1;
            exponent <= exponent + 1'b1;
        end
    end
end
endmodule