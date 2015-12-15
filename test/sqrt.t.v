module sqrt_test ();

    reg[31:0] A;
    reg cpu_clk, sqrt_clk, fp_clk, int_clk;
    reg dutpassed;
    wire[31:0] Out;

sqrt dut (A, cpu_clk, sqrt_clk, fp_clk, int_clk, Out);

always #200000 cpu_clk = !cpu_clk;
always #500 fp_clk = !fp_clk;
always #5 int_clk = !int_clk;
always #10000 sqrt_clk = !sqrt_clk;

initial begin
    int_clk = 0;
    fp_clk = 0;
    sqrt_clk = 1;
    cpu_clk = 0;
    dutpassed = 1'b1;

    $dumpfile("sqrt_wave.vcd");
    $dumpvars(0, dut);

    //Square root of 1
    A = 31'h3f800000; #200000

    if (Out !== 31'h3f800000) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 1. Got %h", Out);
    end

    // if (Out >) begin
    //     //test for range
    // end

    //Square root of 4
    A = 31'h40800000; #200000

    if (Out !== 31'h40000000) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 4. Got %h", Out);
    end

    // if () begin
    //     //test for range
    // end

    //Square root of 0
    A = 31'h0; #200000

    if (Out !== 31'h7b000000) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 0 (note: h7b000000 isn't actually the square root). Got %h", Out);
    end

    // if () begin
    //     //test for range
    // end

    //Square root of 9
    A = 31'h41100000; #200000

    if (Out !== 31'h40400000) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 9. Got %h", Out);
    end

    // if () begin
    //     //test for range
    // end

    //Square root of 100
    A = 31'h42c80000; #200000

    if (Out !== 31'h41200000) begin
        dutpassed = 1'b0;
        $display("Failed to take sqrt of 100. Got %h", Out);
    end

  $display("Sqrt passed?: %b", dutpassed);
    // if () begin
    //     //test for range
    // end
    $finish;
end



endmodule
