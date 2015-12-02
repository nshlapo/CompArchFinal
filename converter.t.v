module converter_test ();

    reg [31:0] fixed;
    reg [7:0] exp_in;
    reg load_new;
    reg clk;
    wire [31:0] float;

converter dut (fixed, exp_in, load_new, clk, float);

initial
    clk = 0;

always #10 clk =!clk;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, dut);

    fixed = 32'b1; exp_in = 32'b0; load_new = 1; #10
    load_new = 0; #1000
    $display("%b", float);
end
endmodule