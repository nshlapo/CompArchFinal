module testMem;
  reg clk, regWE;
  reg[9:0] InstrAddr, DataAddr;
  wire[31:0] DataIn;
  wire[31:0] DataOut, InstrOut;

  reg dutpassed;

  memory dut (.clk(clk),
                .regWE(regWE),
                .DataAddr(DataAddr),
                .InstrAddr(InstrAddr),
                .DataIn(DataIn),
                .DataOut(DataOut),
                .InstrOut(InstrOut));

  initial begin
    // Setup
    dutpassed = 1'b1;
    clk = 1'b0; #5

    // Test Case 1 - Read memory from Address 0
    regWE = 1'b0;
    InstrAddr = 10'd0;
    clk = 1'b1; #5 clk = 1'b0; #5
    if (InstrOut != 32'h201d3ffc) begin
      dutpassed = 1'b0;
      $display("Failed to read instruction from address 0. Expected 201d3ffc, read %h", InstrOut);
    end

    // Test Case 2 - Read memory from Address 4
    InstrAddr = 10'd4;
    clk = 1'b1; #5 clk = 1'b0; #5
    if (InstrOut != 32'h2008000e) begin
      dutpassed = 1'b0;
      $display("Failed to read instruction from address 4. Expected 2008000e, read %h", InstrOut);
    end

    $display("Memory passed: %b", dutpassed);
  end
endmodule
