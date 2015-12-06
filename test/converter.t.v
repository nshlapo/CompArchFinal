module converter_test ();

    reg [31:0] fixed;
    reg [7:0] exp_in;
    reg load_new;
    reg clk;
    reg dutpassed;
    wire [31:0] float;

converter dut (fixed, exp_in, load_new, clk, float);

always #5 clk =!clk;

initial begin
    clk = 0;
    dutpassed = 1'b1;
    $dumpfile("test/waveform.vcd");
    $dumpvars(0, dut);

    // $display("           Expected              |              Result");
    //Test zero exponent
    fixed = 32'b1; exp_in = 8'b0; load_new = 1; #10
    load_new = 0; #1000
    // $display("00111111100000000000000000000000 | %b", float);

    if (float !== 32'b00111111100000000000000000000000) begin
        dutpassed = 1'b0;
        $display("Failed to convert positive number with zero exponent", float);
    end

    //Test non-zero exponent
    fixed = 32'b1; exp_in = 8'b1; load_new = 1; #10
    load_new = 0; #1000
    // $display("01000000000000000000000000000000 | %b", float);

    if (float !== 32'b01000000000000000000000000000000) begin
        dutpassed = 1'b0;
        $display("Failed to convert positive number with positive exponent", float);
    end

    //Test negative exponent
    fixed = 32'b1101; exp_in = 8'b11111111; load_new = 1; #10
    load_new = 0; #1000
    // $display("01000000110100000000000000000000 | %b", float);

    if (float !== 32'b01000000110100000000000000000000) begin
        dutpassed = 1'b0;
        $display("Failed to convert positive number with negative exponent", float);
    end

    //Test negative number
    fixed = 32'b11111111111111111111111111111111; exp_in = 32'b0; load_new = 1; #10
    load_new = 0; #1000
    // $display("10111111100000000000000000000000 | %b", float);

    if (float !== 32'b10111111100000000000000000000000) begin
        dutpassed = 1'b0;
        $display("Failed to convert negative number with zero exponent", float);
    end

    $display("DUT passed?: %b", dutpassed);
    $finish;
end
endmodule
