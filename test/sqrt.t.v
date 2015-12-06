module sqrt_test ();

    reg[31:0] A;
    reg sqrt_clk, fp_clk, int_clk, start;
    reg dutpassed;
    wire[31:0] Out;

sqrt dut (A, sqrt_clk, fp_clk, int_clk, start, Out);

always #5 int_clk = !int_clk;
always #180 fp_clk = !fp_clk;
always #2000 sqrt_clk = !sqrt_clk;

initial begin
    int_clk = 0;
    fp_clk = 0;
    sqrt_clk = 0;
    dutpassed = 1'b1;

    $dumpfile("wave.vcd");
    $dumpvars(0, dut);

    //Square root of 1
    A = 31'h3f800000; start = 1; #5
    start = 0; #1000

    if (Out !== 31'h3f800000) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 1")
    end

    // if (Out >) begin
    //     //test for range
    // end

    //Square root of 4
    A = 31'h40800000; start = 1; #5
    start = 0; #1000

    if (Out !== 31'h40000000) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 2")
    end

    // if () begin
    //     //test for range
    // end

    //Square root of 0
    A = 31'h0; start = 1; #5
    start = 0; #1000

    if (Out !== 31'h0) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 0")
    end

    // if () begin
    //     //test for range
    // end

    //Square root of 10,000
    A = 31'h461c4000; start = 1; #5
    start = 0; #1000

    if (Out !== 31'h42c80000) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 10,000")
    end

    // if () begin
    //     //test for range
    // end

  $display("Sqrt passed?: %b", dutpassed);


endmodule
