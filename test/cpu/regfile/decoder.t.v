module decoder_testbench;
  wire[31:0] out;
  reg enable;
  reg[4:0] address;
  decoder1to32 d(out, enable, address);
  reg dutpassed;

  initial begin
    dutpassed = 1;

    // -> ENABLED CASES
    enable=1'b1;

    // set address to 0; expect 32'b1
    address=5'b00000; #1000
    if (out !== 32'b1) begin
      dutpassed = 0;
      $display(" - Decoder: Test Case 1 Failed");
    end

    // set address to 1; expect 32'b10
    address=5'b00001; #1000
    if (out !== 32'b10) begin
      dutpassed = 0;
      $display(" - Decoder: Test Case 2 Failed");
    end

    // -> NON-ENABLED CASES
    enable=1'b0;

    // set address to 0, expect 0
    address=5'b00000; #1000
    if (out !== 32'b0) begin
      dutpassed = 0;
      $display(" - Decoder: Test Case 3 Failed");
    end

    // set address to 1; expect 0
    address=5'b00001; #1000
    if (out !== 32'b0) begin
      dutpassed = 0;
      $display(" - Decoder: Test Case 4 Failed");
    end

    $display("Decoder passed?: %b", dutpassed);
  end

endmodule
